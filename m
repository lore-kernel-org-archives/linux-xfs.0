Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8560CA9EC9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 23:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792EE214D9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 23:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=box.com header.i=@box.com header.b="EhdrDXrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfKDXiZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 18:38:25 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:39144 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKDXiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 18:38:24 -0500
Received: by mail-oi1-f172.google.com with SMTP id v138so15823011oif.6
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2019 15:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=box.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=jgdECRzLT2bDFdqX3Dd4Tjbd66UJ6LA9LOKkORj3gTA=;
        b=EhdrDXrmhBBj3vbKJoRiTViNQaFTfS+mrDhk5Z+5TL3zpM2bR2a4rkM9rsL7rYyCS+
         DNJq3bSpd6ms5283eHLh5kYCeOvQclC03GPPdmetCu0lr/hw2E2ytUmxVClmEEcGnsvi
         eGUWQtPm1R7eqCL17aP44j5u49DLmGBDFYVb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jgdECRzLT2bDFdqX3Dd4Tjbd66UJ6LA9LOKkORj3gTA=;
        b=eNO4Qi4pZMQMV53n30Hp0BUijCaYi4oUsawMitAfCZsoc2YchR6Lpk9+Pz+egfWwKo
         BzqdRZLhMbqqTlDlbqvb92Fjr4ugU/mE40Ouoyilyoj5qpDQcZRf6t2Xaz2IL7M8sOuq
         TMwXJ1rkFbgnDIRAVYfQPPqz7EBOeUiNM41hsx4NEF9UAK7hUfV+2J8hxxEsQxjSWvoD
         vd/gBCLIuvGr60bMF6jOMKuFcfbYza4P7znsG5a7mOUwFCBepDpm6GH0M8biXs4cvHJd
         3G26o47oFJPPeekdGaNdNYzQ1NlEffvxsopjkrdYTtLwlLwYvsTtcpU1aPi9b9ZzdRNU
         0Qgw==
X-Gm-Message-State: APjAAAWf7flU92PVCAieJSN6xP+HykC62mOI+gnkGkKWyMfN6bSBSJJM
        k0PmGkq3sZstnpk/4cq6REauc8T5z43zk1QJds7Q5dA3gK8=
X-Google-Smtp-Source: APXvYqzV2C1NOYVHrIskbonmII4uhl6mCNaBzidz9CmvnnlawGizITjqxqegSwbh40o1S8w8vw12GT6HYV4sFjWN9zE=
X-Received: by 2002:aca:4742:: with SMTP id u63mr1391133oia.177.1572910703163;
 Mon, 04 Nov 2019 15:38:23 -0800 (PST)
MIME-Version: 1.0
From:   Chris Holcombe <cholcombe@box.com>
Date:   Mon, 4 Nov 2019 15:38:12 -0800
Message-ID: <CAL3_v4PZLtb4hVWksWR_tkia+A6rjeR2Xc3H-buCp7pMySxE2Q@mail.gmail.com>
Subject: XFS: possible memory allocation deadlock in kmem_alloc
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After upgrading from scientific linux 6 -> centos 7 i'm starting to
see a sharp uptick in dmesg lines about xfs having a possible memory
allocation deadlock.  All the searching I did through previous mailing
list archives and blog posts show all pointing to large files having
too many extents.
I don't think that is the case with these servers so I'm reaching out
in the hopes of getting an answer to what is going on.  The largest
file sizes I can find on the servers are roughly 15GB with maybe 9
extents total.  The vast majority small with only a few extents.
I've setup a cron job to drop the cache every 5 minutes which is
helping but not eliminating the problem.  These servers are dedicated
to storing data that is written through nginx webdav.  AFAIK nginx
webdav put does not use sparse files.

Some info about the servers this issue is occurring on:

nginx is writing to 82TB filesystems:
 xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=82, agsize=268435424 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=21973302784, imaxpct=1
         =                       sunit=16     swidth=144 blks
naming   =version 2              bsize=65536  ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

xfs_db -r /dev/sdb1
xfs_db> frag
actual 6565, ideal 5996, fragmentation factor 8.67%
Note, this number is largely meaningless.
Files on this filesystem average 1.09 extents per file

I see dmesg lines with various size numbers in the line:
[6262080.803537] XFS: nginx(2514) possible memory allocation deadlock
size 50184 in kmem_alloc (mode:0x250)

Typical extents for the largest files on the filesystem are:

find /mnt/jbod/ -type f -size +15G -printf '%s %p\n' -exec xfs_bmap
-vp {} \; | tee extents
17093242444 /mnt/jbod/boxfiler3038-sdb1/data/220190411/ephemeral/2019-08-12/18/0f6bee4d6ee0136af3b58eef611e2586.enc
/mnt/jbod/boxfiler3038-sdb1/data/220190411/ephemeral/2019-08-12/18/0f6bee4d6ee0136af3b58eef611e2586.enc:
 EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET
           TOTAL FLAGS
   0: [0..1919]:            51660187008..51660188927 24
(120585600..120587519)     1920 00010
   1: [1920..8063]:         51660189056..51660195199 24
(120587648..120593791)     6144 00011
   2: [8064..4194175]:      51660210816..51664396927 24
(120609408..124795519)  4186112 00001
   3: [4194176..11552759]:  51664560768..51671919351 24
(124959360..132317943)  7358584 00101
   4: [11552760..33385239]: 51678355840..51700188319 24
(138754432..160586911) 21832480 00111


Memory size:
 free -m
              total        used        free      shared  buff/cache   available
Mem:          64150        6338         421           2       57390       57123
Swap:          2047           6        2041

cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

cat /proc/buddyinfo
Node 0, zone      DMA      0      0      1      0      1      0      0
     0      0      1      3
Node 0, zone    DMA32  31577     88      2      0      0      0      0
     0      0      0      0
Node 0, zone   Normal  33331   3323    582     87      0      0      0
     0      0      0      0
Node 1, zone   Normal  51121   6343    822     77      1      0      0
     0      0      0      0

tuned-adm shows 'balanced' as the current tuning profile.

Thanks for your help!
