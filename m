Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A809EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jul 2023 22:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjGJWHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 18:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJWHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 18:07:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE07CB1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 15:07:50 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-668711086f4so3195925b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 15:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689026870; x=1691618870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yXlC3vCug7dGJje39dSSt20g1gPIQkzSekXpa7x+ytw=;
        b=B2LqsDp51YQK0xT3s4Kdnmp3zrfRGZdM6i2cQKQA3+c/QFF15iWtmu8DxQ8zuISnIa
         B2t5AMYH/7haU7o6SxLxvnQRe/ww5+FLgdVdrbs7a+1dks9TpFGTvcVHLHWh/7b3MZHj
         iCn8R/YldPTsYxIAmWzqCbfW0msphMXoSCot+SEQM27g3vTPqaXM/C45RMOUxqJuZa5x
         mmndUp8MPh1FDIhlnYc/uuTfisC/dn1PtQ+9iX8aFWCKsz5Bzm5AEWjGeEo5XnK2SUbo
         edJW7uw7MoymQga/K2YOmHu60LQK+zNB/Cjpqw2qlZ6sluYoioI2TujEWh9s0SOIyZce
         V/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689026870; x=1691618870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXlC3vCug7dGJje39dSSt20g1gPIQkzSekXpa7x+ytw=;
        b=jo30w4ghI1pa1xc/yWdKa61wqmSLkNSLwK/vr4QNYh1S0oZ9WfmSiIjZ/zFWY5re4Z
         LkxLRgzkEKIrxj+IfeeDapFYPlicSZsTB4OHTtHadeZgHasQyz78I1Jrfwcx6ae/2yVy
         S1CqBrWHKKiY/3VI6lvBZcM2/iKx9khB78TnreANgWdti2/8QRzJ5GA3y45E4YOsUhnK
         zp9fQX55yMzlOF+DhYqmPa7H0PSZVjCdtZFCnVKHb4WWSeDmuGXPyLyOA4DhP5obJMp9
         m8rbAJs+j4PK0coMxZfBEuSVRzP5dK6RlAT4EjH9XzRaU+bPjd+p5XhotEo6pumf7QTX
         1gbw==
X-Gm-Message-State: ABy/qLbKQLNWyjqBEj7i8VGbardh+7o5UbQwR9eVtVCDGRYbMX118U/i
        zOZJ3JgWWelSTUohna8iv7oByg==
X-Google-Smtp-Source: APBJJlHJmdZocLbdnzQr4hZhYKMrU+zYrGdWybeFMBqbIxfEmWE1Ps55cZhsYwom6i25IzuHorWsKA==
X-Received: by 2002:a05:6a00:802:b0:673:6cb4:7b0c with SMTP id m2-20020a056a00080200b006736cb47b0cmr21270397pfk.2.1689026870138;
        Mon, 10 Jul 2023 15:07:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id j9-20020a62b609000000b00678afd4824asm251124pff.175.2023.07.10.15.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 15:07:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qIz2o-004YFl-1u;
        Tue, 11 Jul 2023 08:07:46 +1000
Date:   Tue, 11 Jul 2023 08:07:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <ZKyBMpFH1sSsS7L5@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
 <20230620044443.GE11467@frogsfrogsfrogs>
 <ZJFAqTaV6AO37v04@dread.disaster.area>
 <20230705231736.GT11441@frogsfrogsfrogs>
 <ZKs/eo/13sCfEqvQ@dread.disaster.area>
 <20230709233216.GE11456@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709233216.GE11456@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 09, 2023 at 04:32:16PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 10, 2023 at 09:15:06AM +1000, Dave Chinner wrote:
> > On Wed, Jul 05, 2023 at 04:17:36PM -0700, Darrick J. Wong wrote:
> > > Concrete example:
> > > 
> > > So let's pretend that we have an xfs with fs blocksize 4k and dir
> > > blocksize 8k.  Let's suppose the directory's data fork maps fsblock 16,
> > > resulting in a buffer (daddr 128, length 16).  Let us further suppose
> > > the inobt then allocates fsblock 17, resulting in a buffer (daddr 136,
> > > length 8).  These are crosslinked.
> > 
> > RIght, that's an intersection of {128,16} and {136,8}. The search
> > region for buffer invalidation is {128, 8} {128, 16} and {136, 8}.
> > They are the only possible buffers that can be cached in that region
> > for a 4kB block size filesystem, as there can be no metadata buffers
> > starting at daddrs 129-135 or 137-143...
> 
> <nod> There's nothing in this flag that *prevents* someone from spending
> a lot of time pounding on the buffer cache with a per-daddr scan.  But
> note that the next patch only ever calls it with fsblock-aligned daddr
> and length values.  So in the end, the only xfs_buf queries will indded
> be for {128, 8} {128, 16} and {136, 8} like you said.
> 
> See the next patch for the actual usage.  Sorry that I've been unclear
> about all this and compounding it with not very good examples.  It's
> been a /very/ long time since I actually touched this code (this rewrite
> has been waiting for merge since ... 2019?) and I'm basically coming in
> cold. :(
> 
> Ultimately I make invalidation scan code look like this:
> 
> /* Buffer cache scan context. */
> struct xrep_bufscan {
> 	/* Disk address for the buffers we want to scan. */
> 	xfs_daddr_t		daddr;
> 
> 	/* Maximum number of sectors to scan. */
> 	xfs_daddr_t		max_sectors;
> 
> 	/* Each round, increment the search length by this number of sectors. */
> 	xfs_daddr_t		daddr_step;
> 
> 	/* Internal scan state; initialize to zero. */
> 	xfs_daddr_t		__sector_count;
> };
> 
> /*
>  * Return an incore buffer from a sector scan, or NULL if there are no buffers
>  * left to return.
>  */
> struct xfs_buf *
> xrep_bufscan_advance(
> 	struct xfs_mount	*mp,
> 	struct xrep_bufscan	*scan)
> {
> 	scan->__sector_count += scan->daddr_step;
> 	while (scan->__sector_count <= scan->max_sectors) {
> 		struct xfs_buf	*bp = NULL;
> 		int		error;
> 
> 		error = xfs_buf_incore(mp->m_ddev_targp, scan->daddr,
> 				scan->__sector_count, XBF_LIVESCAN, &bp);
> 		if (!error)
> 			return bp;
> 
> 		scan->__sector_count += scan->daddr_step;
> 	}
> 
> 	return NULL;
> }

.....

Yup, that's much better, will do for now.

I suspect this could be smarter with a custom rhashtable walker; all
the buffers at a given daddr should have the same key (i.e. daddr)
so should hash to the same list, so we should be able to walk an
entire list in one pass doing a bjoin/binval callback on each
non-stale buffer that matches the key....

But that can be done later, it's not necessary for correctness and
this looks a lot better than the original code.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
