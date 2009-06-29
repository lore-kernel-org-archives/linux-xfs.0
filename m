Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5TKiBdX153064 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 15:44:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DF4D1291F29
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 13:50:53 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5IMahsKh7yMVIqZh for
	<xfs@oss.sgi.com>; Mon, 29 Jun 2009 13:50:53 -0700 (PDT)
Message-ID: <4A4927B9.7050304@sandeen.net>
Date: Mon, 29 Jun 2009 15:44:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Correct usage of inode64/running out of inodes
References: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
	<4A491887.8050509@sandeen.net>
	<OFBF693EDC.C9829EF7-ON862575E4.006F5BEE-862575E4.00711ED9@genco.com>
In-Reply-To: <OFBF693EDC.C9829EF7-ON862575E4.006F5BEE-862575E4.00711ED9@genco.com>
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
To: Adam Donald <Adam.Donald@gencopharma.com>
Cc: xfs@oss.sgi.com

Adam Donald wrote:

> Thank you for your response.  To be honest, I only ran out of "space"
> (inodes) once on this volume a month or so ago, and I recall receiving a
> ENOSPC type error at that time.  At the time I received out of space
> errors I found the xfs_db command and have since started to monitor the
> ifree value, deleting files when I felt that ifree was dipping too low,
> as I was unable to apply the inode64 option without first taking down
> various production systems.  When the time came this past weekend to
> apply the inode64 option, I was expecting the ifree option value to
> shoot up dramatically (several hundred, perhaps), and instead the ifree
> value remained unaffected, the same as mounting the volume without the
> inode64 option.  

I don't -think- that the inode64 option affects the value reported via
statfs (though maybe it should; for dynamically allocated inodes it's
all make-believe anyway)

> Given the fact that I have this volume mounted with the inode64 option,
> have roughly 7.5TB free, and show ifree with a double digit number
> (currently 30 on our system), is there a an inconsistency between the
> total amount of free space available and the number of free inodes
> available?

hand-wavily, no, it seems fine... the way xfs reports free inodes (or
available inodes) is to look at how many blocks are free, and then how
many inodes -could- be created in that number of blocks, which is why
it's often absurdly high numbers.

inode32 behavior, fragmented free space, or lack of stripe-aligned space
(I think...) can sometimes cause spurious ENOSPC when looking for a new
inode...

-Eric

> Thanks again for the input, I appreciate it!
> 
> 
> AD

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
