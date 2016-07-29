Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 332E07CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 18:35:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA079AC005
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 16:35:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1hqdrJvYd49XDV5R for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2016 16:35:27 -0700 (PDT)
Date: Sat, 30 Jul 2016 09:35:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: partition 100% full No space left on device. looks like xfs is
	corrupted or a bug
Message-ID: <20160729233524.GD16044@dastard>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4278AB9734C1445A8E48635B155149F8@dinulap>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lista Unx <lista.unx@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 29, 2016 at 12:01:42PM +0300, Lista Unx wrote:
> Hello xfs experts,
> 
> I am crawling in the dark from few days and I have no idea how to fix the following problem. On a centos 7 system:

Ok, so you followed my advice on why you couldn't post to the list,
but you ignored my answer as to the cause of the changing numbers of
inodes. I'll repeat it here for the benefit of everyone, so they
don't waste time chasing ghosts.

That is, inodes are dynamically allocated so the number of supported
inodes is directly proportional to the amount of free space left in
the filesystem. You have filesystems with different amounts of free
space, so the number of inodes the filesystem can support is
different. free up some space, the number goes up. Used some space,
the number goes down. This is expected.

Hence the only thing that may be an issue is this:

> # uname -a
> Linux 1a 3.10.0-327.el7.x86_64 #1 SMP Thu Nov 19 22:10:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> df is reporting 100% full of / and du is reporting only 1.7G usage from 50GB available (less than 4%). I want to mention that / is xfs. See below:
> 
> # df -a|grep ^/
> /dev/mapper/centos-root  52403200 52400396      2804 100% /
>                                      ^^^^^^^^^^   ^^^^^^^^^^
> /dev/sda1                  503040   131876    371164  27% /boot
> /dev/mapper/centos-home 210529792    35204 210494588   1% /home
> 
> du is estimating just 1.7G usage of /
> # du -sch /* --exclude=home --exclude=boot
.....
> 1.7G    total
> [root@localhost ~]#

That's probably because there are open but unlinked files present in
the filesystem, and du will not find them. e.g. large O_TMPFILE
files, or files that applications are using as scratch space. You
may even have zombie processes hanging about holding unlinked files
open.

lsof might find those files, it might not. There might also be
orphan inodes on the unlinked lists, and without an unclean shutdown
log recovery won't process them. So it may simply be best to run
sync, then press the reset button to do a hard restart which
will trigger log recovery on restart. If the problem still persists,
then xfs_repair is really the only option to find out where the
space has gone and recover it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
