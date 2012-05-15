Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FIUmVl204598 for <xfs@oss.sgi.com>; Tue, 15 May 2012 13:30:49 -0500
Message-ID: <4FB2A0D6.3050409@sgi.com>
Date: Tue, 15 May 2012 13:30:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
In-Reply-To: <20120514203449.GE16099@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 05/14/12 15:34, Ben Myers wrote:

> Protect xfs_sync_worker by using the s_umount semaphore at the read level to
> provide exclusion with unmount while work is progressing.
>

> -			xfs_log_force(mp, 0);
> +	if (down_read_trylock(&mp->m_super->s_umount)) {

Okay, the s_umount has down_write() performed upon it when it is
created and does not do a up_write until the filesystem mount is
complete.

This test is just like the one in grab_super_passive(). The if
statements have to be separated to know to do the corresponding
up_read().

> +		if (!(mp->m_flags&  XFS_MOUNT_RDONLY)) {
...
> +		up_read(&mp->m_super->s_umount);

Looks good.

Reveiewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
