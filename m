Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FACBC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D4322249
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZYXVFqVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgJOKC7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 06:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgJOKC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 06:02:59 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35015C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 03:02:59 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hk7so1710735pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 03:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mHNXNcZithUU19UPRc8tBQp1VvScADPWbV0N6a0VbRw=;
        b=ZYXVFqVqUOtIDNRcwS5CAYl0+afgyMLysccZ8w7i7L02k3B9B+UD6SemtfqodcFPmA
         GHHhzEh9kp6PGTvdYE3GFLAIPK+nkIHkcmQInBaLLgyMFCF5vjaOrYvY3PwSyk0wzGN0
         DWspDLbmSs1H4JW04dHboU2aY+eWd88I9DK7Zq4Hcavx/fRRyFvODj3F6hzClfN0S2zp
         BZGphviUzbJRjVzKNO4r0q1vfvYBwrN5WyNPFO2mLrBK+V6PHgYQxp1O3Vt5X45mTYjC
         VDbhancbJBfYzmLoeyVjsfHeuFcV8SNNwjHrKQCjOsv1chQs1sEgsi94bPitxiWNO7WW
         XhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mHNXNcZithUU19UPRc8tBQp1VvScADPWbV0N6a0VbRw=;
        b=KL3Q49/MidBWPVgVnrVd2BAUjwG8hQ1EM8BAZuJARPOBBLopeoQQ0CNk9seoNXkDFl
         aP/Dr7d7FsuI4crC+cBYLfNEUI7WMJLkmPZKDlkN8VRXhh93ODT5iZPM0j5uKsM4kGKJ
         KxrKrEaDmjcRekq1okT+3CzJZ7lIeszpJ6Brd/Mk3WbZBF/MM5Mx0+rixGIhAbSlysGJ
         NkNqCPd7cURGHb+6rvox2+8E5423aBGY4ydvKSKJn87ncF1JiPM3tznsfSop4W7F6eUW
         BdwIellojDvWCrjFNCSDisdSrCThaXuQI5BKEZT8rdxtWkxS4PNmY//jVsCl4KVfvtvP
         4skA==
X-Gm-Message-State: AOAM531+wbmoRqOpo2jS1bknd8TjUwQTHs/spU//Nghwu6WWeHl12Yyu
        gyijFhESFaFbuTa/THf1AAg=
X-Google-Smtp-Source: ABdhPJwhP5jHrZU8fWEor6gHa+YwT12GQ1sFcg4qBt2EDnUmbdHh6ouycBX1Src5ljFEVokH2A06mA==
X-Received: by 2002:a17:90b:4d0d:: with SMTP id mw13mr3543327pjb.36.1602756178708;
        Thu, 15 Oct 2020 03:02:58 -0700 (PDT)
Received: from garuda.localnet ([122.167.224.49])
        by smtp.gmail.com with ESMTPSA id t17sm2762196pjs.39.2020.10.15.03.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 03:02:58 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 11/11] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Thu, 15 Oct 2020 15:32:54 +0530
Message-ID: <3688628.2sUYEX9xRT@garuda>
In-Reply-To: <20201015084110.GJ5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <20201012092938.50946-12-chandanrlinux@gmail.com> <20201015084110.GJ5902@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 15 October 2020 2:11:10 PM IST Christoph Hellwig wrote:
> On Mon, Oct 12, 2020 at 02:59:38PM +0530, Chandan Babu R wrote:
> > This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> > helps userspace test programs to get xfs_bmap_btalloc() to always
> > allocate minlen sized extents.
> > 
> > This is required for test programs which need a guarantee that minlen
> > extents allocated for a file do not get merged with their existing
> > neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> > Directories, Xattrs and extension of realtime inodes need this since the
> > file offset at which the extents are being allocated cannot be
> > explicitly controlled from userspace.
> > 
> > One way to use this error tag is to,
> > 1. Consume all of the free space by sequentially writing to a file.
> > 2. Punch alternate blocks of the file. This causes CNTBT to contain
> >    sufficient number of one block sized extent records.
> > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > After step 3, xfs_bmap_btalloc() will issue space allocation
> > requests for minlen sized extents only.
> > 
> > ENOSPC error code is returned to userspace when there aren't any "one
> > block sized" extents left in any of the AGs.
> 
> Can we figure out a way to only build the extra code for debug kernels?
> 

Ok. I will try to get this implemented.

-- 
chandan



