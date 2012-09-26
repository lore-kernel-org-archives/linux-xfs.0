Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QKJY5f249743 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 15:19:34 -0500
Message-ID: <506363A0.8060409@sgi.com>
Date: Wed, 26 Sep 2012 15:20:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfs: reduce code duplication handling inode32/64
	options
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-4-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-4-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 09/20/12 08:32, Carlos Maiolino wrote:
> Add xfs_set_inode32() to be used to enable inode32 allocation mode. this will
> reduce the amount of duplicated code needed to mount/remount a filesystem with
> inode32 option.
> This patch also changes xfs_set_inode64() to return the maximum AG number that
> inodes can be allocated instead of set mp->m_maxagi by itself, so that the
> behaviour is the same as xfs_set_inode32().
> This simplifies code that calls these functions and needs to know the maximum
> AG that inodes can be allocated in.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
