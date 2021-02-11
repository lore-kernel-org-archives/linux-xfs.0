Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57764C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF0264E7D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBKR3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 12:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232344AbhBKR1q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 12:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA03601FF;
        Thu, 11 Feb 2021 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613064425;
        bh=rzq03sKab5HVpQ0GhuFlAoJuGXOLVLhiWbKr8XSZdvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HQETWM3/g2nz+qcSdFC21f24XXyc1/g5MXNG6sqRfZP7zRrFa3fC9eV/MGX6mRSyw
         gPEJrstI/26VS7PCcLsdkwpj2ONLZ9hXfNOJh5a8QrkAlBw5GhpO853CadbNb1BPN9
         /Vpa9yII4Wj9L5b4wDVkEkgKUfV+IS6jHnIDe83YVYB1T3UhvDXEGpBYRHhCUKjsvL
         vGVL3rHtjI0Fi15rDNdPNl8M0cQdH22DjfLIL36unHJhqV0yCdJRJL1nQAI0HO1FpH
         PqG/6Uace9v+DnmH/xS2JvxAuBGYq/mkZCMLujiGlKB8G5SDB9D6A0RlUari6NTgrm
         5esQkH5CKyzZw==
Date:   Thu, 11 Feb 2021 09:27:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/6] check: don't abort on non-existent excluded groups
Message-ID: <20210211172705.GI7190@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292580215.3504537.12419725496679954055.stgit@magnolia>
 <20210211140019.GD222065@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211140019.GD222065@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 09:00:19AM -0500, Brian Foster wrote:
> On Tue, Feb 09, 2021 at 06:56:42PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't abort the whole test run if we asked to exclude groups that aren't
> > included in the candidate group list, since we actually /are/ satisfying
> > the user's request.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  check |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/check b/check
> > index e51cbede..6f8db858 100755
> > --- a/check
> > +++ b/check
> > @@ -243,7 +243,7 @@ _prepare_test_list()
> >  		list=$(get_group_list $xgroup)
> >  		if [ -z "$list" ]; then
> >  			echo "Group \"$xgroup\" is empty or not defined?"
> > -			exit 1
> > +			continue
> >  		fi
> 
> Is this only for a nonexistent group? I.e., 'check -x nosuchgroup ...' ?
> If so, what's the advantage?

I wrote this for groups that exist somewhere but would never have been
selected for this filesystem type in the first place.  For example,
'dangerous_scrub' (aka fuzz testing for xfs_scrub) is only found in
tests/xfs/group, so running:

# FSTYP=ext4 ./check -x dangerous_scrub

fails because ./check cannot select any of the dangerous_scrub tests for
an ext4 run so it doesn't recognize the group name.  IOWs, it's too
stupid to realize that excluding a group that can't be selected should
be a no-op.

--D

> Brian
> 
> >  
> >  		trim_test_list $list
> > 
> 
