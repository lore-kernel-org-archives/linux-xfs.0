Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39990 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763533AbdAET3g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jan 2017 14:29:36 -0500
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
 <20170105191316.GD17846@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <78985020-cef8-9d2c-431c-201b8d02c173@sandeen.net>
Date: Thu, 5 Jan 2017 13:19:47 -0600
MIME-Version: 1.0
In-Reply-To: <20170105191316.GD17846@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Xingbo Wu <wuxb45@gmail.com>, linux-xfs@vger.kernel.org

On 1/5/17 1:13 PM, Darrick J. Wong wrote:
>>> It later leads to IO error:
>>> `dmesg`:
>>> [1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
>>> [1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664
> The kernel complains about "sector 2930266664", which is in 512-byte blocks.
> 
> 2930266664 * 512 = 1500296531968, or halfway across your 3TB disk.
> 
> Makes sense since the log generally ends up halfway across the disk.
> Not sure if there's any output before 1807875.741674 but this sort of
> looks like a disk error or something?

Oh, right.  Like my physics teacher said, "think units before you think
numbers!"  ;)  I usually remember ...

This doesn't look like a size mismatch problem, this looks like a failing
disk problem.

-Eric
