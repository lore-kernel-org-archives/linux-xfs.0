Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:44514 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJHSDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 14:03:10 -0400
Received: by mail-ed1-f42.google.com with SMTP id z21-v6so12742677edb.11
        for <linux-xfs@vger.kernel.org>; Mon, 08 Oct 2018 03:52:02 -0700 (PDT)
Received: from amb.local (31-179-17-47.dynamic.chello.pl. [31.179.17.47])
        by smtp.gmail.com with ESMTPSA id w56-v6sm5676752edd.78.2018.10.08.03.52.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 03:52:01 -0700 (PDT)
From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: repair: realloc(): invalid next size
Message-ID: <41451342-4fd0-76a7-0e8f-810583821775@gmail.com>
Date: Mon, 8 Oct 2018 12:52:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: pl
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Big fs, ton of small files, repair takes 36h until this happens:

rebuilding directory inode 30363993060
rebuilding directory inode 30398868604
rebuilding directory inode 30414474627
rebuilding directory inode 30425006954
rebuilding directory inode 30447937553
rebuilding directory inode 30529556616
rebuilding directory inode 30537494728
rebuilding directory inode 30569826838
rebuilding directory inode 31060721895
Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
xfs_repair: warning - iflush_int failed (-117)
Warning: recursive buffer locking at block 31060721776 detected
Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
xfs_repair: warning - iflush_int failed (-117)
Warning: recursive buffer locking at block 31060721776 detected
Metadata corruption detected at 0x41f980, inode 0x73b5d00e7 data fork
xfs_repair: warning - iflush_int failed (-117)
realloc(): invalid next size
Aborted


Fails somewhere in 0x41f9db <xfs_dir2_sf_verify+603>

Complete log at
https://ixion.pld-linux.org/~arekm/xfs-1/repair.txt

Test was done with xfs_repair 4.17.0 and 4.18.0 with the same result.

kernel 4.18.5

Running under gdb now.

Any ideas?

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
