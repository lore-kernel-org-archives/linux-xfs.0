Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S5Zpvu089336 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:35:51 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD85E1959DF
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:35:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	D8CiwMJcukBAUqPM for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2011 22:35:48 -0700 (PDT)
Date: Wed, 28 Sep 2011 15:35:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 64-bit inodes and back again
Message-ID: <20110928053539.GF3159@dastard>
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E828BE1.8030003@cchtml.com>
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
To: Michael Cronenworth <mike@cchtml.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 27, 2011 at 09:52:17PM -0500, Michael Cronenworth wrote:
> Dave Chinner on 09/27/2011 08:10 PM wrote:
> > I'm pretty sure this was fixed in 2.6.37.
> 
> I upgraded to kernel 2.6.38. The files are now visible.
> 
> Michael Cronenworth wrote:
> >>xfs_reno is a tool designed to move all 64 bit inodes back into the
> >>32 bit inode space again.
> >>
> >>http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool
> >
> >I'll give this a shot first.
> 
> I did try this tool first, but it didn't seem to work for me:
> 
> # xfs_reno -vv /tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64
> 
> xfs_reno: Cannot stat /tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64:
> Invalid argument
> # xfs_reno -fvv /tmp/q.save
> Scanning directory tree...
> Processing 1 directory...
> xfs_reno: directory: 97367 1 /tmp/q.save
> xfs_reno: unable to duplicate directory attributes: /tmp/q.save
> 0 seconds elapsed
> Done.
> # ls -l /tmp/q.save/
> ls: cannot access /tmp/q.save/b0afb399c40e9a45061b5cee73770def741d270e-qt-4.7.4-2.fc14-x86_64:
> Invalid argument
> ls: cannot access /tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64:
> Invalid argument
> total 8
> drwxr-xr-x. 2 root root 4096 Sep 27 22:33 310514e5d8aff198342a469b59311b7fa3af0d28-qt-webkit-4.7.4-2.fc14-x86_64
> ??????????? ? ?    ?       ?            ?
> 7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64
> ??????????? ? ?    ?       ?            ?
> b0afb399c40e9a45061b5cee73770def741d270e-qt-4.7.4-2.fc14-x86_64
> -rw-------. 1 root root   83 Sep 27 22:38 xfs_reno.recover

It has to be able to access the files with inode numbers > 32 bit,
so you need to run it on the 2.6.38 kernel. Once you've done that,
you should be able to read all the files back on the .35 kernel,
too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
