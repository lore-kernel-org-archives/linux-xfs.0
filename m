Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT9eqEh139089 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 03:40:53 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01F2313F7B36
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:42:33 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id oqKjlyQH0JavSOBi for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:42:33 -0800 (PST)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] xfs: don't truncate prealloc from frequently accessed
	inodes
References: <1290991431-20519-1-git-send-email-david@fromorbit.com>
	<1290991431-20519-3-git-send-email-david@fromorbit.com>
Date: Mon, 29 Nov 2010 10:42:29 +0100
In-Reply-To: <1290991431-20519-3-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Mon, 29 Nov 2010 11:43:51 +1100")
Message-ID: <87vd3glb3u.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
>
> To avoid this problem, keep a count of the number of ->release calls
> made on an inode. For most cases, an inode is only going to be opened
> once for writing and then closed again during it's lifetime in
> cache. Hence if there are multiple ->release calls, there is a good
> chance that the inode is being accessed by the NFS server. Hence
> count up every time ->release is called while there are delalloc
> blocks still outstanding on the inode.

Seems like a hack. It would be cleaner and less fragile to add a
explicit VFS hint that is passed down from the nfs server, similar
to the existing open intents.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
