Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582F3C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 11:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E864A207F7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 11:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+JnNOBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406366AbgJPLbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 07:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406087AbgJPLbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 07:31:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FECC061755
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 04:31:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so1278048pgl.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 04:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNPVFMxR93qvrZiVfZ0bcmBktXeXn0H/Pw2Ltw2lCOs=;
        b=i+JnNOBTEjiC1fBQmnbjPig1e5DEKcfOq9ddaIBtkvDiqrxS9TiE2wybdlHJktkI1g
         xU6EFY0atoeyaPI5XHS1Nvqc9qLNsWGvqcdYnQs4JKg/HroA81LwaI8EJWGzFkBtn6id
         JKNTPcYrmynjPj+JC4CNgJTdRkIOFeTIpHJoQ+fNavLPZUWnSxzda4e0F9Y9iMJczH3D
         up/wcR8WbrAcuq2xeWcEZSWYfcHQFbvB3lAZ38iX0hFFH5jQ6DG9KEFrKaA70E+W1nH0
         T1/qDZyyH1fSGq8eE+2II/PgpWCaoMwx+cMLEiSFstbZaQrgW8nTbji8CUPHJs2FJ1ZY
         obnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNPVFMxR93qvrZiVfZ0bcmBktXeXn0H/Pw2Ltw2lCOs=;
        b=ZsWfZQo899HWzZaEWc9ocMoKdthunlrxjl1WcMAQ9aT8AGnzweql3Srozj2bEmlY10
         MBTp2Wk1O8bXIsY39rqiaHozFvE+j8fYdFtuKPsgVn8hlZmiVAa/Wry45zeRuPgGERDy
         pcHTuLTKea1rBq62zQLEYcQE5csdlr03Eqke8TwSim5JHP04bmRMDRREoZIevjbQCS6m
         xsWYVCxbyyH1ysV6z99D6MtV3IsZSu0NsmJsnHhdA/IASXQUjpdo0b8brddjZw39eDb/
         iFwUUSG+g3RC8ppe3IlZQ+s7bNP8iGfJoienhcGZ+AtiqjxaBkIfUmcImvy2tGw79cnv
         Ah9Q==
X-Gm-Message-State: AOAM533Df4m/Td4D6EJlyDPs/pfiVOza4tiQ3NQfuCgP/xJY1qgPsyQM
        H1i39K1rm1HklEweVNuHJMI=
X-Google-Smtp-Source: ABdhPJxRz2RDf/OcnCiC5tYJisitLMbLV8K+1IYz522raXbrVd2AeaQ9875RiEFY/yacrcvmJidGpg==
X-Received: by 2002:a63:214d:: with SMTP id s13mr2642177pgm.449.1602847878858;
        Fri, 16 Oct 2020 04:31:18 -0700 (PDT)
Received: from garuda.localnet ([122.167.154.211])
        by smtp.gmail.com with ESMTPSA id p62sm2644765pfb.180.2020.10.16.04.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 04:31:18 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 11/11] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Fri, 16 Oct 2020 17:01:15 +0530
Message-ID: <7126589.1pso20JOtx@garuda>
In-Reply-To: <20201015184107.GB9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <3688628.2sUYEX9xRT@garuda> <20201015184107.GB9832@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 16 October 2020 12:11:07 AM IST Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 03:32:54PM +0530, Chandan Babu R wrote:
> > On Thursday 15 October 2020 2:11:10 PM IST Christoph Hellwig wrote:
> > > On Mon, Oct 12, 2020 at 02:59:38PM +0530, Chandan Babu R wrote:
> > > > This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> > > > helps userspace test programs to get xfs_bmap_btalloc() to always
> > > > allocate minlen sized extents.
> > > > 
> > > > This is required for test programs which need a guarantee that minlen
> > > > extents allocated for a file do not get merged with their existing
> > > > neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> > > > Directories, Xattrs and extension of realtime inodes need this since the
> > > > file offset at which the extents are being allocated cannot be
> > > > explicitly controlled from userspace.
> > > > 
> > > > One way to use this error tag is to,
> > > > 1. Consume all of the free space by sequentially writing to a file.
> > > > 2. Punch alternate blocks of the file. This causes CNTBT to contain
> > > >    sufficient number of one block sized extent records.
> > > > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > > > After step 3, xfs_bmap_btalloc() will issue space allocation
> > > > requests for minlen sized extents only.
> > > > 
> > > > ENOSPC error code is returned to userspace when there aren't any "one
> > > > block sized" extents left in any of the AGs.
> > > 
> > > Can we figure out a way to only build the extra code for debug kernels?
> 
> Yeah, I was gonna say that too.  You're basically installing a new
> allocator algorithm, but wow it scatters pieces of itself all over the
> place. :/

Right. I have almost completed refactoring the code into relevant functions. I
will execute the test suite and if everything goes well I will be posting the
next version of the patchset soon.

Thanks for the review comments.

-- 
chandan



