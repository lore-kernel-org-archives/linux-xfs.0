Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1594BC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE20208DB
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TA+f7xMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgCXQOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:14:04 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:33962 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbgCXQOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 12:14:04 -0400
Received: by mail-io1-f49.google.com with SMTP id h131so18728489iof.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 09:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WKIE6mFv650sYytq1AHE6P17KUjAE0+DJyqi7xii92M=;
        b=TA+f7xMsDKzqtIvIuBxk6E9prSH1HfuProSXrhs8v7venmXaToatmrMcJB4wbzYO23
         DKDGC2sVmDFgj9ghppKqwKxM+VFaYENopTJjM5vu1Qzrb21vQFCUgLxwLPk4LuZqwpyS
         OMwWvSc8nF3Y47t0fjaoPN2M2RTnKcup47vSODETpCoogM7WmxvKtrl7Ej01UP9X/Cc8
         sdVFquOHTGa7tjS7LP6KKo/WANXUvD/j8jUDjB2+t1Jg78A+knO/J+bNGluF4OJXenDS
         sVVcjvfGgT10fSfcoq/msCd5r9iyeu4tfOfXB6Zt7CK1JMlRF9btFY/dIPg3rmd8Dus9
         Tomg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WKIE6mFv650sYytq1AHE6P17KUjAE0+DJyqi7xii92M=;
        b=FCRlJ3mMs2y9hbs173wfJgBSyCZ5wDscqnlj45NdqBsc7DoHc3+xmiEO2j4+ir8e3/
         afBIQB4zwWUgUw/witAh/BUjlORw7YP2D/lJzJ6bAADK06WcS/s2bl/u+oQdRQUg2LpR
         Jxzz8c3nz1qvyGPDnmlwpdVud1Sql7ap8nJ4lNMxJz8xvlwAVYHKDfUERxQOOjiFIB5z
         rQWmhhWtU5IGY0GrngSCk72oZV9j3CmThgVVYbirpHOgpnLip6tIJ9eiqTRKt2RT2DgQ
         cRNe2pMm60IpBt/KUpNJsiSbFgkOOtlEBPiG6bHTq+pZhqV3oS2C4flOSkx4osY7M2N/
         99+w==
X-Gm-Message-State: ANhLgQ0KKbEiRd/NsNn5khpRLTQ7bZer3rur2orrk4OOvOME0QHo7RjB
        gJTjJ6Q/Wp7bNy+RgPlyIvt6B0tlqU/z5XH1JtiwOgo5
X-Google-Smtp-Source: ADFU+vt4XZmZoy9Leca7g5fKpIgXr6IEYdPwaW0hOC8f94LINaa8dHqdnYPzPoTyB3Dsf8hAAqOXUigd//4ZpZxIkxs=
X-Received: by 2002:a02:3808:: with SMTP id b8mr26361189jaa.136.1585066441937;
 Tue, 24 Mar 2020 09:14:01 -0700 (PDT)
MIME-Version: 1.0
From:   Pawan Prakash Sharma <pawanprakash101@gmail.com>
Date:   Tue, 24 Mar 2020 21:43:25 +0530
Message-ID: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
Subject: xfs duplicate UUID
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I am using ZFS filesystem and created a block device(ZVOL) and mounted
and formatted that as xfs filesystem. I have one application running
which is using this xfs file system.

Now, when I am creating a ZFS snapshot and ZFS clone and trying to
mount the clone filesystem, I am getting duplicate UUID error and I am
not able to moiunt it.

After searching I found there is xfs_freeze binary available to freeze
the file system. xfs_freeze is intended to be used with volume
managers and hardware RAID devices that support the creation of
snapshots. As zfs file system is volume manager also so this looks
good solution. So I tried the below steps:-

1. xfs_freeze -f <mountpath>
2. take the zfs snapshot
3. create the clone from the snapshot
4. xfs_freeze -u <mountpath>
5. generate new uuid with "xfs_admin -U generate <device>"

This is not working. xfs_admin command itself is throwing the error,
it is returning this error :

ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_admin.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

But this error does not make any sense since as per man page
(https://linux.die.net/man/8/xfs_freeze)

All dirty data, metadata, and log information are written to disk,
then why I am getting this error. Am I missing something?


Regards,
Pawan.
