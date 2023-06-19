Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5C8EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jun 2023 08:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjFSIwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjFSItv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 04:49:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747E51710
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 01:48:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25edb50c3acso1408394a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 01:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687164517; x=1689756517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DsQxKLQEFCVT2ILf3I+TEMX1wWPTRkpiPLealrIaT38=;
        b=gB/8sk02ocxgIsGJymxcDEIiShCse612DaeR8xncsohXpo4vdC8EPigNHFZBvli/2I
         jeETMTrv0FIwltvEreQx8zE4WRTjBbfobyGhCs79uHlkpAOEYRFTpF+5D7J3+IyBEaag
         HD4DJEz2u1he5z2hu1aXkbF7YkpJSZKH4bgD/qDh//O55TuUPIDIlxffIqxytzPwjbe1
         CAyg8oxAYIb67Rli0ZLXmWkS4IA2WyMvN5r3ydqhfGFzQ4qtzi71VmzhlMIdp/TlVJUl
         Xml78VcDmMAfZS+AI9h/AEWylE/SqrjfE85QYF7nPENw3vfBzxqnOBnghNiEKAvCa5bU
         cJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687164517; x=1689756517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DsQxKLQEFCVT2ILf3I+TEMX1wWPTRkpiPLealrIaT38=;
        b=BBfENDVM1M2sAK6ZkFemX+b3V7s8wkJ2WVkeA/pj1V0NW/YWP6+S0+HGn5UqhVs6sU
         kL4xpD6Cj7ni8UAe0d3CbuWdJG7cP/q+uTEJS+51JfRgkkkPLrL4xgWEbwLDvnl/9u0n
         G/yA9fYIFdxSOkvmD3uRH7b9uGKrOG6LeywL6561VJmn7ssPAsn9aNyyq4gKvInI/wvK
         d+ScNcDbhAFwb3AhTlF+Omo+LFl0+23I0r7VnSnw5HC7dxSKJqiVSYTPpVLTE+nRxFNG
         ZG3WQ0SV1YbONvh0s6oplaHHuR8zN3jwDbg/5N25kX9+jQWKbRRnCPDNyh+92iJpaI7G
         UnSA==
X-Gm-Message-State: AC+VfDw2qbMuImdUKflIYo2GOxRKjKhjlDf3fQdZ6EVv9tLuPPTMVfjv
        wOEE8y8FmYdKAVGrvCgxfA3mwA==
X-Google-Smtp-Source: ACHHUZ68gjnZSUJeeMw6PcVMglNpsBzzUPH7W0q3j4EeXHhmjHB/RXN4uEube2exq52BnGtn7o3fbA==
X-Received: by 2002:a17:90a:19c9:b0:255:d86c:baec with SMTP id 9-20020a17090a19c900b00255d86cbaecmr9205798pjj.46.1687164516899;
        Mon, 19 Jun 2023 01:48:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090abc8300b0025be7b69d73sm5266329pjr.12.2023.06.19.01.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:48:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBAYr-00DajP-2J;
        Mon, 19 Jun 2023 18:48:33 +1000
Date:   Mon, 19 Jun 2023 18:48:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: journal geometry is not properly bounds checked
Message-ID: <ZJAWYXDFJrlqCbQu@dread.disaster.area>
References: <20230619070032.1912781-1-david@fromorbit.com>
 <87r0q7n9bu.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0q7n9bu.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 19, 2023 at 01:59:57PM +0530, Ritesh Harjani wrote:
> Dave Chinner <david@fromorbit.com> writes:
> > +	if (sbp->sb_logsunit > 1) {
> > +		if (sbp->sb_logsunit % sbp->sb_blocksize) {
> > +			xfs_notice(mp,
> > +		"log stripe unit %u bytes must be a multiple of block size",
> > +				sbp->sb_logsunit);
> > +			return -EFSCORRUPTED;
> > +		}
> > +		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
> > +			xfs_notice(mp,
> > +		"log stripe unit %u bytes must be a multiple of block size",
> > +				sbp->sb_logsunit);
> 
> I guess this xfs_notice message needs to be corrected.
> 
> > +			return -EFSCORRUPTED;
> > +		}
> > +	}
> > +
> > +
> > +
> > +
> 
> too many new lines here ^^^

Fixed.

> 
> > -	 * We can, however, reject mounts for CRC format filesystems, as the
> > +	 * We can, however, reject mounts for V5 format filesystems, as the
> >  	 * mkfs binary being used to make the filesystem should never create a
> >  	 * filesystem with a log that is too small.
> >  	 */
> >  	min_logfsbs = xfs_log_calc_minimum_size(mp);
> > -
> >  	if (mp->m_sb.sb_logblocks < min_logfsbs) {
> >  		xfs_warn(mp,
> >  		"Log size %d blocks too small, minimum size is %d blocks",
> >  			 mp->m_sb.sb_logblocks, min_logfsbs);
> >  		error = -EINVAL;
> 
> Are we using this error now?

I'm not changing the existing error for this case.

> 
> > -	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
> > -		xfs_warn(mp,
> > -		"Log size %d blocks too large, maximum size is %lld blocks",
> > -			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
> > -		error = -EINVAL;
> > -	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
> > -		xfs_warn(mp,
> > -		"log size %lld bytes too large, maximum size is %lld bytes",
> > -			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
> > -			 XFS_MAX_LOG_BYTES);
> > -		error = -EINVAL;
> > -	} else if (mp->m_sb.sb_logsunit > 1 &&
> > -		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
> > -		xfs_warn(mp,
> > -		"log stripe unit %u bytes must be a multiple of block size",
> > -			 mp->m_sb.sb_logsunit);
> > -		error = -EINVAL;
> > -		fatal = true;
> > -	}
> > -	if (error) {
> > +
> >  		/*
> >  		 * Log check errors are always fatal on v5; or whenever bad
> >  		 * metadata leads to a crash.
> >  		 */
> > -		if (fatal) {
> > +		if (xfs_has_crc(mp)) {
> >  			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
> >  			ASSERT(0);
> >  			goto out_free_log;
> 
> yes, only here in goto out_free_log we will return "error".
> Then why not shift error = -EINVAL in this if block?

Because I tried to change as little as needed to fix the issue. I
didn't think it was necessary to move it from where it was....

Fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
