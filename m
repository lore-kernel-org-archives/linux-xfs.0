Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R5Gpl3072019 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 00:16:51 -0500
Date: Mon, 27 Jul 2009 01:17:32 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: xfs@oss.sgi.com

----- "Eddy Zhao" <eddy.y.zhao@gmail.com> wrote:

> >
> > I don't recommend you pull the usb disk out while the filesystem is
> still
> > mounted (if you can avoid it).
> >
> 
> Doing that to emulate power loss scenario our device might experience.
> 
> >
> > I would start by looking through the change history for
> fs/xfs/xfs_log_recover.c
> > and paying particular attention to anything to do with inode
> transactions.
> >
> 
> Not quite familiar with XFS code :(
We all start somewhere!

> 
> >
> > Or try some intermediate kernels and see if you can narrow the fix
> down to a set of
> > changes.
> >
> 
> I'll try to bisect (It will take some time...)
> 
> >
> > # mount /dev/sda1 /mnt/
> > UDF-fs: No VRS found
> > XFS mounting filesystem sda1
> > Starting XFS recovery on filesystem: sda1 (dev: sda1)
> > Filesystem "sda1": xfs_inode_recover: Bad inode magic number, dino
> ptr
> > = 0xc8266700, dino bp = 0xc8281b40, ino = 0
> 
> Because XFS log is OK to 2.6.28 system, which means the log is correct
> in itself.
> Would it be easy for you to debug the problem by compare 2.6.10 log
> recovery code fail point and the corresponding 2.6.28 log record?
Easy?  Not exactly.  Diff'ing 2.6.10 version of fs/xfs/xfs_log_recover.c
with mainline shows over 300 differences.  If you really want to be able
to replay the log on a different system it really has to be running the
same version of XFS for there to be any chance of it working properly.

It should also be the same architecture too - is it possible you have a
32 bit kernel on the 2.6.10 system and a 64 bit kernel on the 2.6.28
system?  If so then this fix might help

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6d192a9b82212abf1e0e89da6e3a952afba7e4d6

I think it went into 2.6.18.

> 
> Thanks
> Eddy 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
