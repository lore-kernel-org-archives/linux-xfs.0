Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F86AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbiECXce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 19:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiECXcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:32:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1513E0C9
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 16:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D7761764
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 23:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D61AC385A4;
        Tue,  3 May 2022 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651620538;
        bh=W4PNIeF0b9IOWyISJds6S7qXUqpadhZQ3ZwZmXJN0jE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIFPZzGN9DGtJu1+yTwuG9FmRpGOHeRcJPWGxe+x1uD8UlDIZGVN091LQfoGfQ1JV
         7RtETcvh4q8AIsch6aIh8gAFHMT9UYX9IBOGPHumA6BlH/Ht5R9SWGFqhfClUqeMDY
         Iow8DN5BQK/yAJJ9MBAVrRCGljLzqETN6hAvgEUpsAC2A3joVuNBCcrDM9gbEdhZ22
         HQM4bYBp/c4TRQPsfqms+r+mvsdn4gusopIBJRkA1oxciIo8105CNZ2gLXy67gPBUE
         wXof8g/sfHRj8JTofQOv6yX00HldtlnnrlrcGgSMloc0OIU3wrbJCt61JKLUfTlyOF
         gzrRHLCTDBufQ==
Date:   Tue, 3 May 2022 16:28:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <20220503232858.GM8265@magnolia>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-5-david@fromorbit.com>
 <20220503225918.GI8265@magnolia>
 <20220503231858.GE1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503231858.GE1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 09:18:58AM +1000, Dave Chinner wrote:
> On Tue, May 03, 2022 at 03:59:18PM -0700, Darrick J. Wong wrote:
> > On Mon, May 02, 2022 at 06:20:18PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because stupid dumb fuzzers.
> > 
> > Dumb question: Should we make db_flds[] in db/sb.c (userspace) report
> > each individual feature flag as a field_t?
> 
> Maybe, but we do already have the versionnum command that dumps the
> feature bits in text/human readable format....

The fuzz tests in fstests just do:

# xfs_db /dev/sda -c '<goto metadata>' -c 'print' | awk '{print $1}'

to find the fields that it should fuzz, so if we don't call out
individual bit fields in the features flags, it'll never fuzz them.
I guess I"ll look into changing that...

--D

> > I've been wondering why none
> > of my fuzz tests ever found these problems, and it's probably because
> > it never hit the magic bits that $scriptkiddie happened to hit.
> 
> Yeah, you've probably never cleared just the dirv2 bit. That one has
> an assert on it these days because the kernel only supports v2-based
> directory formats.  In other cases, things still work but we
> probably don't do the right thing for v5 formats :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
