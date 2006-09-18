Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 07:42:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IEgHZd009800
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 07:42:19 -0700
Message-ID: <450EB025.5020007@oss.sgi.com>
Date: Mon, 18 Sep 2006 09:41:41 -0500
From: linux-xfs@oss.sgi.com
MIME-Version: 1.0
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
References: <200609181519.18448.christian.gattermair@mci.edu>
In-Reply-To: <200609181519.18448.christian.gattermair@mci.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: christian gattermair <christian.gattermair@mci.edu>
Cc: xfs@oss.sgi.com

christian gattermair wrote:

> xfs_repair works but can not find any superblock. any hints?
> 
> xfs_repair /dev/sdb1
> Phase 1 - find and verify superblock...
> error reading superblock 11 -- seek to offset 1134332153856 failed
> couldn't verify primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...
> ...
> ...
> ..............found candidate secondary superblock...
> error reading superblock 11 -- seek to offset 1134332153856 failed

That's about a terabyte into your 3t fs, but you can't seek to it?  Any kernel 
messages when this happens?  What does /proc/partitions and/or parted  say about 
the size of /dev/sdb1?  Seems like maybe your device itself is not as expected.

-Eric
