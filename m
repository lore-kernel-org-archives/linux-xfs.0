Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF37C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53B020663
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLczaazk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389312AbgF3PXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389250AbgF3PXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:23:23 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83AC061755
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 08:23:23 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e64so16489966iof.12
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 08:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wf3aTu9i2iRqTfmGvmEKvC2RnUh/esFJ2QFi4//mgvw=;
        b=NLczaazkqD6owL1wqmLXyQRawOzYXc3LdtmoOSWuc2wo196A70fFXNw7G9eWlaCjke
         BBJEEVSC/ZCQ659TBK1/zueWU27F6n1LC3rK7dXi5RrL2SQN8oKQkSnrGvgc6n4FVrDS
         Fcpd79FWkPjGO1S3bLoE+vHix50RH1c0jf9smKimlzBBt4xTwufBEUCHu+899bz3gFTF
         A754yzhESwVYjgLCNOytJosjQ+FVS8jCOOu0dtXmF3a5i1Sof5O+Lxuadf8q1leC0PCc
         SI3qKW4NRUPcWs1nvQmpTuYr3pcAtDkCBG5z+lB2MTXC2n0U5IUCzfea5oP2lMaWr8PT
         z6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wf3aTu9i2iRqTfmGvmEKvC2RnUh/esFJ2QFi4//mgvw=;
        b=HE2xlmpMj9W/ee3mtHKPyTFHYOBHY3xLwnx3Th/6UpEE4Tc1H97oXY2RUOPN+yV1OC
         azqr4XzMrAQcEV5hTeJgmeliaCGzQGNxk4XZffJLCCt4zv1y3uZBJKYDqh2eRK7y9Gph
         QCx5t7JT2hYY361zoOOyJrZWHH36sIQqnHLw6O4Ng+jn87a878sCAF8B89B4L3Ajb5tP
         9XlLypqD4n28liCn+J8Q2EI/dhR0MCqOZcwjCM2AzKYN3U30U+zzbl2dOPOFgUCbj/0b
         lFbEBDHu+cFYLC+3TTwVbsxQaOYOalEFx7KpVsIMY8MViIpOpK78EqoXDiX+jXbobB+7
         0udg==
X-Gm-Message-State: AOAM532I2W/ak4p0Fr4nxWO0gTnOIfIS+WMCH4b3B9pB/UnsBpTbPriX
        GjcK0Ax/SmCR3zSVQm1vIedJmOZDzlQtVx+uxzo=
X-Google-Smtp-Source: ABdhPJy93NvA1VskawsF4sSxpyyLK7wcSnLaJPKwMhD+/bWSjCYOfQ64kJBU6FhM7kC1g0xNzpRhrfcZfdnIuwLC22c=
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr22108267iox.203.1593530602990;
 Tue, 30 Jun 2020 08:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200623052059.1893966-1-david@fromorbit.com> <20200623211910.GG7606@magnolia>
 <20200623221431.GB2005@dread.disaster.area> <20200629170048.GR7606@magnolia>
In-Reply-To: <20200629170048.GR7606@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 30 Jun 2020 18:23:12 +0300
Message-ID: <CAOQ4uxiuEVW=d+g_3kj+zdTc_ngEkF+nGnJ+M2g1aU3SqsFa+w@mail.gmail.com>
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> /me wonders if someone could please check all the *_ops that point to
> generic helpers to see if we're missing obvious things like lock
> taking.  Particularly someone who wants to learn about xfs' locking
> strategy; I promise it won't let out a ton of bees.
>

The list was compiled manually by auditing 'git grep '_operations.*=' fs/xfs'
structs for non xfs_/iomap_/noop_ functions.
I am not sure if all iomap_ functions are safe in that respect, but I suppose
those were done recently with sufficient xfs developers review...

fs/xfs/xfs_aops.c:const struct address_space_operations
xfs_address_space_operations = {
        .error_remove_page      = generic_error_remove_page,

generic_error_remove_page() calls truncate_inode_page() without MMAPLOCK
Is that safe? not sure

fs/xfs/xfs_file.c:static const struct vm_operations_struct xfs_file_vm_ops = {
        .map_pages      = filemap_map_pages,

Fixed by $SUBJECT

fs/xfs/xfs_file.c:const struct file_operations xfs_file_operations = {
        .splice_read    = generic_file_splice_read,

Will call xfs_file_read_iter, so looks fine

       .splice_write   = iter_file_splice_write,

Will call xfs_file_write_iter, so looks fine

       .get_unmapped_area = thp_get_unmapped_area,

Looks fine?

fs/xfs/xfs_file.c:const struct file_operations xfs_dir_file_operations = {
        .read           = generic_read_dir,
        .llseek         = generic_file_llseek,

No page cache, no dio, no worries?

Thanks,
Amir.
