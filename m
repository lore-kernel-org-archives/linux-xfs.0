Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QKZttW224186 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 15:35:55 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28ACDAC01D
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 13:36:22 -0700 (PDT)
Message-Id: <B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: corrupt file system -- "Structure needs cleaning"
Date: Fri, 26 Jun 2009 15:36:20 -0500
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Cc: xfs@oss.sgi.com


On Jun 26, 2009, at 2:58 PM, Hendrik Hoeth wrote:

>
> This is how I recovered (well, most of the data I had copied is
> corrupt at the target location):

Some files would not make it to disk when filesystem shut down.
I'd expect that such files are short. Do you have other indication
that the files are corrupt?

> -------------------8<---------------------
> [14:40] root@jetway:/var/log # umount /home
> [14:43] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
> ERROR: The filesystem has valuable metadata changes in a log which  
> needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it  
> before
> re-running xfs_check.  If you are unable to mount the filesystem,  
> then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt  
> a mount
> of the filesystem before doing this.
> [14:43] root@jetway:/var/log # mount /home/
> [14:43] root@jetway:/var/log # umount /home/
> [14:44] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
> [14:44] root@jetway:/var/log # mount /home/
> -------------------8<---------------------

Seems like no corruption on disk.
The system detected in memory corruption and shut the filesystem
down to avoid writing bad (meta)data to disk. I don't have answer
for that problem, however you can continue to use the filesystem,
and may never see this problem again. If it happens again, it
could be useful to run debug XFS, which may point to the problem.

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
