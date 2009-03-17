Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HHT658171583 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 12:29:26 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA2F81A33E2
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 10:28:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id dWcyJaRvEVqv9GIA for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 10:28:45 -0700 (PDT)
Message-ID: <49BFDDC5.9060500@sandeen.net>
Date: Tue, 17 Mar 2009 12:28:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lost files + indentical Foldernames on XFS Partition
References: <49BFDC6E.6050607@liga01.de>
In-Reply-To: <49BFDC6E.6050607@liga01.de>
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
To: Steffen.Knauf@liga01.de
Cc: xfs@oss.sgi.com

Steffen Knauf wrote:
> Hello,
> 
> today i have a strange behavior. I have a a directory which contains 
> lots of indentical Folders with the same Name and Inode.

What kernel?

Can you cut and paste what you see?

> I don't create Hardlinks or something else. On the other side some files 
> are suddenly vanished. A "ls -al" result in the following error: 
> "Access  to bla not possible: File or Directory not found."
> I don't find some Errormessages in the logfile. I don't know whether a 
> xfs_check make sense.

xfs_repair -n will check the filesystem without actually modifying anything.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
