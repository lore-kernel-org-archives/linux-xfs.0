Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1I9bwmu022840 for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 03:37:58 -0600
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23AA712DD36
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 01:37:24 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by
	cuda.sgi.com with ESMTP id UEGuPVUYPEgGhBcW for
	<xfs@oss.sgi.com>; Wed, 18 Feb 2009 01:37:24 -0800 (PST)
Message-ID: <499BD6BB.2000406@aei.mpg.de>
Date: Wed, 18 Feb 2009 10:36:59 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: xfs problems (possibly after upgrading from linux kernel	2.6.27.10
	to .14)
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed>
In-Reply-To: <20090218091935.GD8830@disturbed>
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
To: david@fromorbit.com
Cc: linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

Dave Chinner schrieb:
> On Tue, Feb 17, 2009 at 03:49:16PM +0100, Carsten Aulbert wrote:
>> Hi all,
>>
>> within the past few days we hit many XFS internal errors like these. Are these
>> errors known (and possibly already fixed)? I checked the commits till 
>> 2.6.27.17 and there does not seem anything related to this.
> 
> .....
> 
>> Feb 16 20:34:49 n0035 kernel: [275873.335916] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_
> 
> A transaction shutdown on create. That implies some kind of ENOSPC
> issue.
> 
>> Do you need more information or can I send these nodes into a re-install?
> 
> More information. Can you get a machine into a state where you can
> trigger this condition reproducably by doing:
> 
> 	mount filesystem
> 	touch /mnt/filesystem/some_new_file
> 
> If you can get it to that state, and you can provide an xfs_metadump
> image of the filesystem when in that state, I can track down the
> problem and fix it.

I can try doing that on a few machines, would a metadump help on a
machine where this corruption occurred some time ago and is still in
this state?

> 
>> Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff8801a7c06c00
> 
> However, this implies some kind of memory corruption is occurring.
> That is reading the inode out of the buffer before flushing the
> in-memory state to disk. This implies someone has scribbled over
> page cache pages.
> 
> 
>> Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff802dd15b
> 
> And that is another buffer that has been scribbled over.
> Something is corrupting the page cache, I think. Whether the
> original shutdown is caused by the some corruption, i don't
> know.
> 

At least on two nodes  we ran memtest86+ overnight and so far no error.

>> plus a few more nodes showing the same characteristics 
> 
> Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> after you upgraded from .10 to .14?

As far as I can see this only happened after the upgrade about 14 days
ago. What strikes me odd is that we only had this occurring massively on
Monday and Tuesday this week.

I don't know if a certain access pattern could trigger this somehow.

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
