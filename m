Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1836C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 20:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjKJUhq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 15:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbjKJUhe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 15:37:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DFF4C0F
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 12:37:04 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1cc7077d34aso21183175ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 12:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699648623; x=1700253423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8jWEMwJHDlhctM1+MLldwwy811AIS3PvgiQH1Ctcwsc=;
        b=QaqB1Us6UZzaCPfONreTef6guJs6xre9O3KeBksp4Sk5qTwi6CBc4lygpgTfw9ovUj
         AJYMwSYTnN1Eh91CfQcSREeNsg96T5ruiPCMjQizMeEZ+VHDJwoQjarGCS0CXav62883
         SApQS9p5FvpuYjCqvEFiWYTkQewyiH5N268+WjG3w+WD9locGZqUqS+58tvEYDqgBPLt
         GKkgGavCARXUrCX3EiV2IqDE2DoN17nzCm2nyB/7zdeI3uHx45r1XsSGlK0Rem0bahqQ
         R9vTaDFuwfS4MWB7/aFuwjHTAC/XaOTN0wCcowSvA+kis55mOE/dVzdRbK0qpOkq2/wb
         /f8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699648623; x=1700253423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jWEMwJHDlhctM1+MLldwwy811AIS3PvgiQH1Ctcwsc=;
        b=NXOWN4gOX9tItnCre1MfVg1FJ0rN93tjZMXeUVpS82XkX27TQ4pozOFsUXsDy/E4g5
         aQKZppPnzHKJltCE1XYc+OYJkLqReVlrn4lpig0lYbOqoJ1QT46KeRUmK3rYFl9it29p
         MUK6Pw5YVsjxcb+tF8WqkIoN2NWp1n44Jb2Mh4GrMoeUmq4yYPkNZ4+QVb9Ker0t9V+P
         cdxg0dQTiCaJ63EAzMPNxi4yg7DMDMXr9NPe/OsZ75Js8Wtgkw1RxZSdDuXbJvcT/WOs
         uTpc+Gf+9s3TAbWkQwn+IAaWtK9b/aJXq3EgheAR+KV+2RZ/ZDnDXAmI6pk664X0q86l
         QcUQ==
X-Gm-Message-State: AOJu0YyHxrXCSk+Du0Yj9AfjgOv1H322U/ZiHWGZalgkxl1F7WQqMU91
        GeEJGldi3NoOOgtHzfyVknZvcUXFIQmmTYGgLWs=
X-Google-Smtp-Source: AGHT+IERJvlCS8fh0h5jFfsON6fQfyP8+PcTnGq8bA7RAdHFO28UQW+gyVSeFUzeqORV0c1tTM7OGg==
X-Received: by 2002:a17:902:d2ce:b0:1cc:688e:5b24 with SMTP id n14-20020a170902d2ce00b001cc688e5b24mr452132plc.39.1699648623308;
        Fri, 10 Nov 2023 12:37:03 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id z12-20020a1709027e8c00b001c898328289sm49748pla.158.2023.11.10.12.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 12:37:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r1YFP-00Atya-2W;
        Sat, 11 Nov 2023 07:36:59 +1100
Date:   Sat, 11 Nov 2023 07:36:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 2/2] xfs: recovery should not clear di_flushiter
 unconditionally
Message-ID: <ZU6Ua7JLAioBP7PY@dread.disaster.area>
References: <20231110044500.718022-1-david@fromorbit.com>
 <20231110044500.718022-3-david@fromorbit.com>
 <20231110193255.GK1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110193255.GK1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 11:32:55AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 10, 2023 at 03:33:14PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
> > zero padding in the inode, except when NREXT64=1 configurations are
> > in use and the zero padding is no longer padding but holds the 64
> > bit extent counter.
> > 
> > This manifests obviously on big endian platforms (e.g. s390) because
> > the log dinode is in host order and the overlap is the LSBs of the
> > extent count field. It is not noticed on little endian machines
> > because the overlap is at the MSB end of the extent count field and
> > we need to get more than 2^^48 extents in the inode before it
> > manifests. i.e. the heat death of the universe will occur before we
> > see the problem in little endian machines.
> > 
> > This is a zero-day issue for NREXT64=1 configuraitons on big endian
> > machines. Fix it by only clearing di_flushiter on v2 inodes during
> > recovery.
> > 
> > Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
> > cc: stable@kernel.org # 5.19+
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> > index f4c31c2b60d5..dbdab4ce7c44 100644
> > --- a/fs/xfs/xfs_inode_item_recover.c
> > +++ b/fs/xfs/xfs_inode_item_recover.c
> > @@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
> >  	 * superblock flag to determine whether we need to look at di_flushiter
> >  	 * to skip replay when the on disk inode is newer than the log one
> >  	 */
> > -	if (!xfs_has_v3inodes(mp) &&
> > -	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> > -		/*
> > -		 * Deal with the wrap case, DI_MAX_FLUSH is less
> > -		 * than smaller numbers
> > -		 */
> > -		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> > -		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> > -			/* do nothing */
> > -		} else {
> > -			trace_xfs_log_recover_inode_skip(log, in_f);
> > -			error = 0;
> > -			goto out_release;
> > +	if (!xfs_has_v3inodes(mp)) {
> > +		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> > +			/*
> > +			 * Deal with the wrap case, DI_MAX_FLUSH is less
> > +			 * than smaller numbers
> > +			 */
> > +			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> > +			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> > +				/* do nothing */
> > +			} else {
> > +				trace_xfs_log_recover_inode_skip(log, in_f);
> > +				error = 0;
> > +				goto out_release;
> > +			}
> >  		}
> > +
> > +		/* Take the opportunity to reset the flush iteration count */
> > +		ldip->di_flushiter = 0;
> 
> Hmm.  Well this fixes the zeroday problem, so thank you for getting the
> root of this!
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Though hch did suggest reducing the amount of indenting here by
> compressing the if tests together.  I can't decide if it's worth
> rearranging that old V4 code since none of it's scheduled for removal
> until 2030, but it /is/ legacy code that maybe we just don't care to
> touch?

I'd prefer not to touch it. It's now all isolated in a
"!xfs_has_v3inodes()" branch, so I think we can largely ignore the
grot for now. If we have to do a larger rework of this code in
future, then we can look at reworking it.

But right now, I really don't feel like risking breaking something
else by doing unnecessary cleanups on code we haven't needed to
touch in over a decade.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
