Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2567C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 09:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD736611C4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 09:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhKDJXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 05:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhKDJXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 05:23:03 -0400
X-Greylist: delayed 668 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 Nov 2021 02:20:25 PDT
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE7FC061714
        for <linux-xfs@vger.kernel.org>; Thu,  4 Nov 2021 02:20:25 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 1A499Fdf022689
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 4 Nov 2021 10:09:15 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 1A499Fdf022689
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1636016955;
        bh=nFljF/R29E+pV4B4+Uxbf9i5fxtXiskDaIUFRt90z88=;
        h=Date:From:To:Cc:Subject:From;
        b=BgyUACL1orB+Oi9D5ESImGYbIsK25DNWKwxfeZCFps/4DOOuu7GZm/RJuJzeu99xr
         t95iV/IIqGK2/Cqqq+deiAXUhsBmTLIUbCEvFSHNmVWfzSxVSd8+/X+mOd1aAIyBS+
         V6RtpljH6PsRgU1XYS4lS1elw/fcbtuVcYDBaZYU=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 1A499Fvt044733
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 4 Nov 2021 10:09:15 +0100
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 1A499FuP008430;
        Thu, 4 Nov 2021 10:09:15 +0100
Date:   Thu, 4 Nov 2021 10:09:15 +0100
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     linux-xfs@vger.kernel.org
Cc:     nikola.ciprich@linuxbox.cz
Subject: XFS / xfs_repair - problem reading very large sparse files on very
 large filesystem
Message-ID: <20211104090915.GW32555@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.85/SpamAssassin v3.004006 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by Kaspersky antivirus, database version: 2021-11-04T00:29:00
X-Milter-Copy-Status: O
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello fellow XFS users and developers,

we've stumbled upon strange problem which I think might be somewhere
in XFS code.

we have very large ceph-based storage on top which there is 1.5PiB volume
with XFS filesystem. This contains very large (ie 500TB) sparse files,
partially filled with data.

problem is, trying to read those files leads to processes blocked in D
state showing very very bad performance - ~200KiB/s, 50IOPS.

I tried running xfs_repair on the volume, but this seems to behave in
very similar way - very quickly it gets into almost stalled state, without
almost any progress..

[root@spbstdnas ~]# xfs_repair -P -t 60 -v -v -v -v /dev/sdk
Phase 1 - find and verify superblock...
        - max_mem = 154604838, icount = 9664, imem = 37, dblock = 382464425984, dmem = 186750208
Memory available for repair (150981MB) may not be sufficient.
At least 182422MB is needed to repair this filesystem efficiently
If repair fails due to lack of memory, please
increase system RAM and/or swap space to at least 364844MB.
        - block cache size set to 4096 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 1454674 tail block 1454674
        - scan filesystem freespace and inode maps...
        - found root inode chunk
libxfs_bcache: 0x26aa3a0
Max supported entries = 4096
Max supported entries = 4096
Max utilized entries = 4096
Active entries = 4048
Hash table size = 512
Hits = 0
Misses = 76653
Hit ratio =  0.00
MRU 0 entries =   4048 (100%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Dirty MRU 16 entries =      0 (  0%)
Hash buckets with   2 entries      5 (  0%)
Hash buckets with   3 entries     11 (  0%)
Hash buckets with   4 entries     30 (  2%)
Hash buckets with   5 entries     36 (  4%)
Hash buckets with   6 entries     57 (  8%)
Hash buckets with   7 entries     90 ( 15%)
Hash buckets with   8 entries     80 ( 15%)
Hash buckets with   9 entries     74 ( 16%)
Hash buckets with  10 entries     62 ( 15%)
Hash buckets with  11 entries     31 (  8%)
Hash buckets with  12 entries     16 (  4%)
Hash buckets with  13 entries     10 (  3%)
Hash buckets with  14 entries      7 (  2%)
Hash buckets with  15 entries      2 (  0%)
Hash buckets with  16 entries      1 (  0%)
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2


        - agno = 3
  

VM has 200GB of RAM, but the xfs_repair does not use more then 1GB,
CPU is idle. it just only reads the same slow speed, ~200K/s, 50IOPS.

I've carefully checked, and the storage speed is much much faster, checked
with blktrace which areas of the volume it is currently reading, and trying
fio / dd on them shows it can perform much faster (as well as randomly reading
any area of the volume or trying randomread or seq read fio benchmarks)

I've found one, very old report pretty much resembling my problem:

https://www.spinics.net/lists/xfs/msg06585.html

but it is 10 years old and didn't lead to any conclusion.

Is it possible there is still some bug common for XFS kernel module and xfs_repair?

I tried 5.4.135 and 5.10.31 kernels, xfs_progs 4.5.0 and 5.13.0
(OS is x86_64 centos 7)

any hints on how could I further debug that?

I'd be very gratefull for any help

with best regards

nikola ciprich


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
