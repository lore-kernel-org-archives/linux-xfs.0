Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out2.mail.ruhr-uni-bochum.de ([134.147.42.229]:55549 "EHLO
        out2.mail.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752017AbeENUK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 16:10:56 -0400
Received: from mx2.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
        by out2.mail.ruhr-uni-bochum.de (Postfix mo-ext) with ESMTP id 40lBSf2N9Cz4y5M
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 22:02:42 +0200 (CEST)
Received: from out2.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
        by mx2.mail.ruhr-uni-bochum.de (Postfix idis) with ESMTP id 40lBSf1nmTz4y67
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 22:02:42 +0200 (CEST)
Received: from mail1.mail.ruhr-uni-bochum.de (mail1.mail.ruhr-uni-bochum.de [134.147.42.227])
        by out2.mail.ruhr-uni-bochum.de (Postfix mi-int) with ESMTP id 40lBSf1PRxz4y5M
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 22:02:42 +0200 (CEST)
Received: from webmail.ruhr-uni-bochum.de (vmrz0224.rz.ruhr-uni-bochum.de [134.147.64.15])
        by mail1.mail.ruhr-uni-bochum.de (Postfix) with ESMTPSA id 40lBSd6vcBzyXK
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 22:02:41 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2018 22:02:41 +0200
From: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>
Subject: How to reliably measure fs usage with reflinks enabled?
Message-ID: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

How can one reliably measure filesystem usage on partitions that were 
compiled with -m reflink=1 ?
Here are some numbers i am measuring with df -h (on different partitions 
holding the same data):
7.7G of 36G  (-b size=512  -m crc=0 )
8.6G of 36G  (-b size=4096 -m crc=1 )
11G  of 36G  (-b size=1024 -m crc=1,reflink=1,rmapbt=1 -i sparse=1 )
32G  of 864G (-b size=4096 -m crc=1,reflink=1 )

I already ruled out fragmentation as a cause. The data does not contain 
many duplicates (roughly 200mb could be freed by deduplicating). Since 
measuring fs usage on btrfs also isn't trivial, i would suspect that 
there are similar problems happening here. But i could not find any 
information on how to measure fs usage properly when using xfs with 
reflinks. Kernel in use is 4.14.40.

Tarik Ceylan

(I am not subscribed to this list, i'd be grateful if you could CC me in 
your reply)
