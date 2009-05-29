Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TDm8Ua057209 for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:48:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 765F11302398
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 06:54:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ww8DzIqWGgxgcLII for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 06:54:27 -0700 (PDT)
Message-ID: <4A1FE7A2.9030302@sandeen.net>
Date: Fri, 29 May 2009 08:48:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfsprogs: add xfs_reno(8)
References: <20090528151804.GA31976@infradead.org> <200905290837.11098@zmi.at>
In-Reply-To: <200905290837.11098@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Donnerstag 28 Mai 2009 Christoph Hellwig wrote:
>> The Linux port of xfs_reno
> 
> When used, does it move inodes on disk, or just change the numbers?

Both.  location == number == location == number ...

> Because there seems to be still danger on inode64, would it be worth to 
> sometimes run xfs_reno to get most files back to inode32, but still 
> mount with inode64? I know this would create big inodes again, but at 
> least old data would be safe.

that sounds like going in circles....  I wouldn't recommend it.

Either you want 64-bit inodes.... or not.

-Eric

> mfg zmi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
