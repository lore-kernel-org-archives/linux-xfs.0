Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U4hcVx258740 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 22:43:39 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A405188A78D
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 20:42:56 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id L7ualgFQhPjM2jF4 for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2009 20:42:56 -0800 (PST)
Message-ID: <4982854D.8000808@sandeen.net>
Date: Thu, 29 Jan 2009 23:42:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] enable possibility of ALL different atime mount options
References: <200901300322.02079.edvx1@systemanalysen.net>
In-Reply-To: <200901300322.02079.edvx1@systemanalysen.net>
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
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

Roland Eggner wrote:
> Utako Kusaka has provided this patch
> http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
> It works for me GRACEFULLY with ALL different atime mount options: atime|noatime|relatime.
> Note, the mount options are effective, not only accepted.
> Prior to this patch, mount option atime has been ignored.



> Please put the patch to mainline, it would save worries for users, who need the traditional atime
> bahavior.  Think of some corner cases for desktop usage.
> 

Which specific problem is this fixing for you?

you say that atime is ignored; but:

default mounts:

[root@inode test]# echo foo > atimetestfile
[root@inode test]# stat atimetestfile
Access: 2009-01-30 04:36:47.470348714 -0600
[root@inode test]# cat atimetestfile
foo
[root@inode test]# stat atimetestfile
Access: 2009-01-30 04:36:57.450339777 -0600

remount as noatime:

[root@inode test]# mount -o remount,noatime .
[root@inode test]# stat atimetestfile
Access: 2009-01-30 04:36:57.450339777 -0600
[root@inode test]# cat atimetestfile
foo
[root@inode test]# stat atimetestfile
Access: 2009-01-30 04:36:57.450339777 -0600

it would appear to be working...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
