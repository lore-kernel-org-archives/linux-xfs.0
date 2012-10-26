Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QDCV9q228063 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 08:12:31 -0500
Message-ID: <508A8D0B.2030000@sgi.com>
Date: Fri, 26 Oct 2012 08:15:55 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [v3, 3/3] xfs: Print error when unable to allocate inodes or
	out of free inodes.
References: <f0a97d0a46ee8f8bbc42a742274dde7a4c76801b.1348641483.git.rprabhu@wnohang.net>
In-Reply-To: <f0a97d0a46ee8f8bbc42a742274dde7a4c76801b.1348641483.git.rprabhu@wnohang.net>
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
To: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On 09/26/2012 01:56 AM, Raghavendra D Prabhu wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>
> When xfs_dialloc is unable to allocate required number of inodes due to global
> ceiling, or AGs are out of free inodes but not allowed to allocate inodes or
> unable to allocate without continguous free space, printk the error in
> ratelimited manner.
>
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>

Thanks Raghavendra,

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
