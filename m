Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016B7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 13 May 2022 15:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiEMPc3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 May 2022 11:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378806AbiEMPc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 11:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4E7A800
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 08:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AB0B83029
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 15:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED0CC34100;
        Fri, 13 May 2022 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652455944;
        bh=Mpnzcn6RMTk1EZh5QH047QG3/+vKd0X7uZHLaaGfZGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8//MLhTta3liIXTQqhMnaOctkroEDLsssLsFBYYzZDOfBTwn/ypw4mBbcnlFrQVJ
         B01BR55tKJeeHtFt0R/GAQ1fQXaqkGlzL3CfzCCFLpkLqXJ/E7D/Nk3CX/Lk21wV5I
         TcUigUrU5sXCqLPgcU/ph1ktSQ16vE7JDUAl9Bi8+odYplcaed8hKESlISNNq18MyR
         ztHh0XULHPVcRJJYI+LciVRZk0l5mBUmX37hF2kp7XImvd1PifPlRY0qN+bzmKPFk5
         xCD5SI8YBlgYa65Zgp5Q7oYFAAVvAHOlbZIIC1OeEPL1yF19hDsogXYS38eubS6qHy
         iPTSmDzkpZXvw==
Date:   Fri, 13 May 2022 08:32:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_scrub: make phase 4 go straight to fstrim if
 nothing to fix
Message-ID: <Yn56CHxrxg05BdCx@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176688994.252160.6045763886457820977.stgit@magnolia>
 <82de68be-0119-8e2a-c584-def6a0680034@sandeen.net>
 <20220512231253.GJ27195@magnolia>
 <f97e6357-1973-6105-b450-b36d60dc4885@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f97e6357-1973-6105-b450-b36d60dc4885@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 08:18:15AM -0500, Eric Sandeen wrote:
> On 5/12/22 6:12 PM, Darrick J. Wong wrote:
> > On Thu, May 12, 2022 at 05:34:37PM -0500, Eric Sandeen wrote:
> >> On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <djwong@kernel.org>
> >>>
> >>> If there's nothing to repair in phase 4, there's no need to hold up the
> >>> FITRIM call to do the summary count scan that prepares us to repair
> >>> filesystem metadata.  Rearrange this a bit.
> >>>
> >>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >>
> >>
> >>> +
> >>> +	/*
> >>> +	 * If errors remain on the filesystem, do not trim anything.  We don't
> >>> +	 * have any threads running, so it's ok to skip the ctx lock here.
> >>> +	 */
> >>> +	if (ctx->corruptions_found || ctx->unfixable_errors == 0)
> >>> +		return 0;
> >>> +
> >>> +maybe_trim:
> >>> +	trim_filesystem(ctx);
> >>> +	return 0;
> >>>  }
> >>
> >> I'm a little confused by the unfixable_errors test, is that correct?
> >>
> >> Why do you bail out if there are 0 unfixable errors?
> > 
> > Oooops.  That was a logic inversion bug. :(
> 
> I'll fix it up and commit it with:
> 
> +	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
> +		return 0;
> 
> if you want to confirm that's correct?

Yes, that's correct, thank you.

--D

> -Eric
