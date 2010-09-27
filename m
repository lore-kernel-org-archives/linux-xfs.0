Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RHrHOt198072 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 12:53:17 -0500
Subject: Re: [PATCH 0/18] xfs: metadata scalability V4
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285552073-14663-1-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
Date: Mon, 27 Sep 2010 12:52:27 -0500
Message-ID: <1285609947.2380.70.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2010-09-27 at 11:47 +1000, Dave Chinner wrote:
> xfs: Metadata scalability patchset V4

As far as I'm concerned I'm prepared to pull this series
in whenever you send a request.  Nice work.

					-Alex

> Version 4:
> o removed xfs_ichgtime by open coding the only unlogged time change
>   and moved xfs_trans_ichgtime() to xfs_trans_inode.c
> o cleaned up trylock semantics in per-ag reclaim locking algorithm.
> o made xfs_inode_ag_walk_grab() STATIC.
> 

. . . 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
