Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B09BC00140
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 05:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiGaF3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 01:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiGaF3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 01:29:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1991412A99
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 22:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659245361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rCrOFJqZxbbgJ+s8VwpS7V+KIMcif4/6hgvlB3G/aJQ=;
        b=LPea/AOuckg3JBGyvXLyoCMUKaLUayEfsQDCMjwhiBE+vAHbjaQJotgP41JZ+LbBHpzwcv
        HmITeSZQWmgBpalShdfJqqKd+eSo28Dn/wJSeRUlbwC8YvaA6/n356OF7i4FlyvQCLjL/L
        Omo138e3fv44cnzKFVpJBNNwN6gzBNQ=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-bOZymN1QMJug3j4shQJ3IA-1; Sun, 31 Jul 2022 01:29:19 -0400
X-MC-Unique: bOZymN1QMJug3j4shQJ3IA-1
Received: by mail-ot1-f71.google.com with SMTP id z4-20020a9d71c4000000b0061c59fd62e9so3909823otj.20
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 22:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rCrOFJqZxbbgJ+s8VwpS7V+KIMcif4/6hgvlB3G/aJQ=;
        b=6tbdQTvARGaAhzrS54sHr4nGqkR7RHS3pDA12k+aEo/KRRNUBCWA+ryDI03UlYBuV7
         FLk8380SVcAQJ5ZTBG0olmEsy9IucOtXx3G8ZdUR/iTcd4BRZxAABxV7K5YxbkSUNJfB
         ohgk0VI7aAbjm8McQ5h5sVLX3PomHT1tORST1c3zv2mcTz/QTrk+RXJCkcDSBM6mYUzM
         dsp2HpbXwOfOVSWgnh1WrcZeUXh6Pt2/nQP4jDioAApUsscmkMuiL5VbZTv5ivx9v22J
         xkq6pWZsEa9hEUAUjQ7xKtly2kq2omMWpp4l5Aw09i39iidJ4uFA9bulPfgXlxZcW3Qt
         lbmg==
X-Gm-Message-State: ACgBeo09mQF35go9WLysvEReLlpjULjFdIFNW3P4bUCrb3bt8kzk6Txh
        DoarfoKP+Iyy3SJPOrFZOqu7+ovg6T0t+xK7X6rzSp9mO7pUPgyM/yYiUEZbrrgZyp2Qq3kJPew
        S+6Ky9DFdCS+C+lZyNj3A
X-Received: by 2002:a05:6870:e60e:b0:10e:d4ee:a3ae with SMTP id q14-20020a056870e60e00b0010ed4eea3aemr174710oag.91.1659245358638;
        Sat, 30 Jul 2022 22:29:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR46R0Ak11npx+Xxnx0bUM9CvSasmFH92vdl+Yy+X/Ues5pa+jzu3QTVxwu7yzcDIlq9YiRb9A==
X-Received: by 2002:a05:6870:e60e:b0:10e:d4ee:a3ae with SMTP id q14-20020a056870e60e00b0010ed4eea3aemr174704oag.91.1659245358366;
        Sat, 30 Jul 2022 22:29:18 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k22-20020a056870149600b0010e63d0afbbsm999943oab.55.2022.07.30.22.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 22:29:17 -0700 (PDT)
Date:   Sun, 31 Jul 2022 13:29:12 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <20220731052912.u3mcvvhl2dintaqq@zlang-mailbox>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
 <165903223512.2338516.9583051314883581667.stgit@magnolia>
 <YuLunHKTHbw1wcvZ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuLunHKTHbw1wcvZ@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 01:16:28PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 28, 2022 at 11:17:15AM -0700, Darrick J. Wong wrote:
> > +SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> > +	echo "xfs_repair on restored fs returned $?"
> 
> Wouldn;t it make more sense to have a version of _scratch_xfs_repair
> rather than doing a somewhat unexpected override of this global
> variable?

Any detailed ideas about how to have a new version of _scratch_xfs_repair? I'll
keep this patch unmerged this week, before Darrick reply your discussion.

Currently a few cases do some overriding [1] before calling _scratch_* helpers.
And good news is this kind of "override" affect only the environment seen by
its follow command/function. So I generally don't have objection if it works
well. But it's welcome if we have a better idea to deal with this kind of
requirement :)

Thanks,
Zorro


[1]
$ grep -rsn SCRATCH_DEV= tests/
tests/btrfs/160:36:old_SCRATCH_DEV=$SCRATCH_DEV
tests/btrfs/160:38:SCRATCH_DEV=$DMERROR_DEV
tests/btrfs/146:39:old_SCRATCH_DEV=$SCRATCH_DEV
tests/btrfs/146:41:SCRATCH_DEV=$DMERROR_DEV
tests/btrfs/146:62:SCRATCH_DEV=$old_SCRATCH_DEV
tests/xfs/507:198:LARGE_SCRATCH_DEV=yes _check_xfs_filesystem $loop_dev none none
tests/xfs/185:75:SCRATCH_DEV="$ddloop"
tests/xfs/234:56:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
tests/xfs/234:57:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
tests/xfs/336:68:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
tests/xfs/336:69:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
tests/xfs/157:61:       SCRATCH_DEV=$orig_ddev
tests/xfs/157:76:SCRATCH_DEV=$fake_datafile
tests/xfs/129:56:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
tests/xfs/129:57:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
tests/ceph/005:27:SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
tests/ceph/005:29:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
tests/ceph/005:31:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
tests/ceph/005:33:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount

> 

