Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HwMmf080867 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:58:22 -0500
Message-ID: <506F2013.7080606@sgi.com>
Date: Fri, 05 Oct 2012 12:59:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch v4 07/13] [PATCH 07/13] xfs: syncd workqueue is no more
References: <20121005171853.985930109@sgi.com>
	<20121005171946.545918929@sgi.com>
In-Reply-To: <20121005171946.545918929@sgi.com>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On 10/05/12 12:19, Ben Myers wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> With the syncd functions moved to the log and/or removed, the syncd
> workqueue is the only remaining bit left. It is used by the log
> covering/ail pushing work, as well as by the inode reclaim work.
>
> Given how cheap workqueues are these days, give the log and inode
> reclaim work their own work queues and kill the syncd work queue.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
