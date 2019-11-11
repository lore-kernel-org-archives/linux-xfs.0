Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBBBC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721842173B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573493261;
	bh=P2LkTSuFNlz7ftbVPIs9n1cLmNLd5du1j4yvz0vZ/HM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RSgO5iDmHCGzP5WYKLTSlnt2MpA9WMMPGlHMxq56f9HS7Eh3A62HSNpk+h/ygevHT
	 wQwgLVoMt1Fl5zkJimY/MKD2Foye6g4W75XQQPbejFkg3smkzqbajHY1Ztue8xmNEz
	 CJk50vWe1pevOY3Oq5Q/O0MOtchnnn/BOl0zTTN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKKR1k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:27:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfKKR1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Nov 2019 12:27:40 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABE520856;
        Mon, 11 Nov 2019 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573493259;
        bh=P2LkTSuFNlz7ftbVPIs9n1cLmNLd5du1j4yvz0vZ/HM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xoj2pc9uwTRoJlmd0UubipQHS2r+pGYfIBanY++BkZunv2uzszVcA3Q1hGU2TsCrD
         +JgRwpD2MI+apIgSBuxC1YsIX3K2LOPE9pRm5rPp+NlMby7mWdC4Le0yV3zoKuz+3B
         5eAvn1vWW1grEwboYZj/bJk2HHNOusbZnPuuGLDQ=
Date:   Mon, 11 Nov 2019 09:27:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix memory leak in add_enckey
Message-ID: <20191111172737.GB56300@gmail.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
 <20191107214606.GA1160@google.com>
 <2b089dfc-8961-742d-2bab-9b5b471dc26f@sandeen.net>
 <a142f525-c45f-c245-58ad-879f94a636cb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a142f525-c45f-c245-58ad-879f94a636cb@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 09:13:45AM -0600, Eric Sandeen wrote:
> On 11/7/19 3:58 PM, Eric Sandeen wrote:
> > On 11/7/19 3:46 PM, Eric Biggers wrote:
> >> On Thu, Nov 07, 2019 at 10:50:59AM -0600, Eric Sandeen wrote:
> >>> Invalid arguments to add_enckey will leak the "arg" allocation,
> >>> so fix that.
> >>>
> >>> Fixes: ba71de04 ("xfs_io/encrypt: add 'add_enckey' command")
> >>> Fixes-coverity-id: 1454644
> >>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>> ---
> >>>
> >>> diff --git a/io/encrypt.c b/io/encrypt.c
> >>> index 17d61cfb..c6a4e190 100644
> >>> --- a/io/encrypt.c
> >>> +++ b/io/encrypt.c
> >>> @@ -696,6 +696,7 @@ add_enckey_f(int argc, char **argv)
> >>>  				goto out;
> >>>  			break;
> >>>  		default:
> >>> +			free(arg);
> >>>  			return command_usage(&add_enckey_cmd);
> >>>  		}
> >>>  	}
> >>>
> >>
> >> The same leak happens later in the function too.  How about this instead:
> > 
> > whoops yes it does.  I kind of hate "retval = command_usage" but seeing the
> > memset of the key on the way out it's probably prudent to have one common
> > exit point after the function gets started.
> > 
> > Care to send this as a formal patch?
> 
> <interprets silence as a "no"> ;)
> 
> I'll just incorporate your fixes as an addendum to my patch, then.
> 
> -Eric

Sorry, I didn't receive this because I was dropped from Cc, and I'm not
currently subscribed to linux-xfs.  The patch you committed looks fine, thanks.

- Eric
