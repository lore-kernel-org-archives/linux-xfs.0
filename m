Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE713C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D906F600CC
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbhHSDH3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhHSDH1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB016108E;
        Thu, 19 Aug 2021 03:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629342410;
        bh=Pym+vsXaAu78PZnp917GuaEdY/oR5TzGwH8h0wya0c0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mn6vX+8B2urK8UIRuGDz22dn8vdFNQUmhXV0il3esqvYxy+D4Dcp2SPsZups2pOaR
         MCosnToyMNI4Pox439L3oGqjz10Ab2aEXPw5E/OP+ZLunbEU9OvObfO4iTph9wMLUf
         SyvUObdaTCHTxNV3uP66izXaji6Ja8zdg/0CTQU0S/oORUz7rykJIrcJrvINGmipc+
         8vHMjPM+44qOGX4dt+/iR+ThdF+1zUUa7JiRWYzrKJNm6Du76LBMcEzQLpMQjZlFTI
         Euj4KzRzP2D6su1W4Wnm+FFXpOtIsxknCg+2HuTVfDciD+fTN77lGXRyXQPKDHRBEh
         AYQ26lGUb3hPg==
Date:   Wed, 18 Aug 2021 20:06:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: disambiguate units for ftrace fields tagged
 "len"
Message-ID: <20210819030649.GM12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378154.761813.12918362378497157448.stgit@magnolia>
 <20210819030147.GZ3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819030147.GZ3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 01:01:47PM +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2021 at 04:43:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Some of our tracepoints have a field known as "len".  That name doesn't
> > describe any units, which makes the fields not very useful.  Rename the
> > fields to capture units and ensure the format is hexadecimal.
> > 
> > "blockcount" are in units of fs blocks
> > "daddrcount" are in units of 512b blocks
> 
> Hmmm. This is the first set of units I'll consider suggesting a
> change in naming - "blockcount" seems ambiguous and easily mistaken,
> while "daddrcount" just seems a bit wierd. Perhaps:
> 
> "fsbcount" is a length in units of fs blocks
> "bbcount" is a length in units of basic (512b) blocks

I like that suggestion.  Will update.

--D

> .....
> > @@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
> >  		__entry->length = be32_to_cpu(in_f->icl_length);
> >  		__entry->gen = be32_to_cpu(in_f->icl_gen);
> >  	),
> > -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
> > +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u blockcount 0x%x "
> >  		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
> >  		  __entry->length, __entry->gen)
> 
> THis one could probably do with a bit of help - count is the number
> of inodes, so the order of the tracepoint probably should be
> reworked to put the fsbcount directly after the agbno. i.e.
> 
> TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x isize %u count %u gen %u",
> ....
> 
> The rest of the conversions look good, though.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
