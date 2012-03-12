Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2C0uaLj227071 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 19:56:36 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8Kue722lFapAK0m9 for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 17:56:34 -0700 (PDT)
Date: Mon, 12 Mar 2012 11:56:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 1B files, slow file creation, only AG0 used
Message-ID: <20120312005632.GY5091@dastard>
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
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
To: Michael Spiegle <mike@nauticaltech.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 09, 2012 at 06:13:27PM -0800, Michael Spiegle wrote:
> We're seeing some very strange behavior with XFS on the default kernel
> for CentOS 5.6 (note, I have also 3.2.9 and witnessed the same issue).
>  The dataset on this server is about 1B small files (anywhere from 1KB
> to 50KB).  We first noticed it when creating files in a directory.  A
> simple 'touch' would take over 300ms on a completely idle system.  If
> I simply create a different directory, touching files is 1ms or
> faster.  Example:
> 
> # time touch 0
> real    0m0.323s
> user    0m0.000s
> sys     0m0.323s
> 
> # mkdir tmp2
> # time touch tmp2/0
> real    0m0.001s
> user    0m0.000s
> sys     0m0.000s

Entirely normal. some operations require Io to complete (e.g.
reading directory blocks to find where to insert the new entry),
while adding the first file to a directory generally requires zero
IO. You're seeing the difference between cold cache and hot cache
performance.

> We've done quite a bit of testing and debugging, and while we don't
> have an answer yet, we've noticed that our filesystem was created with
> the default of 32 AGs.  When using xfs_db, we notice that all
> allocations appear to be in AG0 only.

Go look up what the inode32 and inode64 mount options do. The
default is inode32....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
