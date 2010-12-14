Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBE4g82k069194 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 22:42:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BB3D1CC0DF6
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 20:43:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	qdrixxL0E26J8DBR for <xfs@oss.sgi.com>;
	Mon, 13 Dec 2010 20:43:58 -0800 (PST)
Date: Tue, 14 Dec 2010 15:43:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode64 mount option added after data exists
Message-ID: <20101214044355.GB16267@dastard>
References: <C92BDD2E.1C75%ivan.novick@emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C92BDD2E.1C75%ivan.novick@emc.com>
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
To: Ivan.Novick@emc.com
Cc: xfs@oss.sgi.com

On Mon, Dec 13, 2010 at 05:24:46PM -0500, Ivan.Novick@emc.com wrote:
> Hi all,
> 
> Quick question about the inode64 mount option.
> 
> Is it safe to add this mount option to a file system that was
> already created and wrote lots of data without it.

Yes.

> Will it still work as intended in this case (use 64 bit inodes)?

Yes, for newly created inodes and data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
