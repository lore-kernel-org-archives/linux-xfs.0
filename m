Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA48D29DF8
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 12:18:40 -0600 (CST)
Message-ID: <52C1B900.8080002@sgi.com>
Date: Mon, 30 Dec 2013 12:18:40 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/10] xfs: implement bulkstat per allocation group
References: <52BEB47B.3090001@oracle.com>
In-Reply-To: <52BEB47B.3090001@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/28/13 05:22, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> With xfs_perag_bulkstat(), we can return stat information in bulk by
> inode as per the given allocation group number and start inode number
> in it via a new ioctl(2) in the future.
>
> Refactor xfs_bulkstat() with it.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---


causes xfs/183 to assert for me:

XFS: Assertion failed: fs_is_ok, file: /root/xfs/fs/xfs/xfs_itable.c, 
line: 409

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
