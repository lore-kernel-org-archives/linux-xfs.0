Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ALWAed023351 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 15:32:10 -0600
Message-ID: <4F358CD6.9000602@sgi.com>
Date: Fri, 10 Feb 2012 15:32:06 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -v2 2/3] xfs: make inode quota check more general
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, xfs@oss.sgi.com

On 02/06/12 06:50, Mitsuo Hayasaka wrote:
> The xfs checks quota when reserving disk blocks and inodes. In the block
> reservation, it checks if the total number of blocks including current
> usage and new reservation exceed quota. In the inode reservation,
> it checks using the total number of inodes including only current usage
> without new reservation. However, this inode quota check works well
> since the caller of xfs_trans_dquot() always sets the argument of the
> number of new inode reservation to 1 or 0 and inode is reserved one by
> one in current xfs.
>
> To make it more general, this patch changes it to the same way as the
> block quota check.
>

Does not hurt to be consistent with the block reservations.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
