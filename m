Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0UHYgwg041671 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 11:34:42 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4266DCFF23
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 09:34:00 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id ndvXAabUy0jiNvLE for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 09:34:00 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH] enable possibility of ALL different atime mount options
Date: Fri, 30 Jan 2009 10:50:00 +0100
References: <200901300322.02079.edvx1@systemanalysen.net>
	<4982854D.8000808@sandeen.net> <49828666.7040809@sandeen.net>
In-Reply-To: <49828666.7040809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901301050.00469.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>

On Friday Jan 30th 2009 at 05:47:34 Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Roland Eggner wrote:
> >> Utako Kusaka has provided this patch
> >> http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
> >> It works for me GRACEFULLY with ALL different atime mount options: atime|noatime|relatime.
> >> Note, the mount options are effective, not only accepted.
> >> Prior to this patch, mount option atime has been ignored.
> > 
> > 
> > 
> >> Please put the patch to mainline, it would save worries for users, who need the traditional atime
> >> bahavior.  Think of some corner cases for desktop usage.
> >>
> > 
> > Which specific problem is this fixing for you?
> > 
> > you say that atime is ignored; but:
> 
> Sorry, I probably replied too quickly.  But I am still curious to know
> what problem you are seeing that this patch fixes.
> 
> Thanks,
> -Eric

On Wed Oct 17th 2007 at 13:56:00 +0900 Utako Kusaka wrote:
>The atime is changed for reading but it returns to a previous value
>after unmount.
And his patch fixes this, nothing more and nothing less.
Think of desktop machines, where you sometimes need precise atime stamps,
and where atime only inode updates don't hurt performance because CPUs are
almost always idle.  Think of e.g. important cron jobs, you want to know
exactly, if at all, when and in which sequence they were executed.

-- 
Roland Eggner

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
