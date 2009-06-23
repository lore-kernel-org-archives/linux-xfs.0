Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NF0wo1033657 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:00:58 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B89808F808E
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 08:01:23 -0700 (PDT)
Message-Id: <AE31FB8A-6C11-4177-85AB-794839A88080@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A3B5C14.9070101@dermichi.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS and atime update strangeness
Date: Tue, 23 Jun 2009 10:01:22 -0500
References: <4A3B5C14.9070101@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Jun 19, 2009, at 4:36 AM, Michael Weissenbacher wrote:

> Hi XFS-List!
> As i have been playing around with atime settings recently, i  
> noticed that XFS handles atime updates very differently than other  
> filesystems (at least different than ext2/3/4 and reiserfs). In fact  
> it does not record atime changes permanently, it seems that atimes  
> are only stored in the inode cache. I was testing this on a Gentoo  
> Box with kernel 2.6.28-gentoo-r5 and 2.6.30 Vanilla.
>
>
> How to reproduce?
>
> invincible usr # ls -lu portage/header.txt
> -rw-r--r-- 1 root root 121 2009-06-18 22:06 portage/header.txt
> invincible usr # date
> Fri Jun 19 11:24:53 CEST 2009
> invincible usr # cat portage/header.txt > /dev/null
> invincible usr # ls -lu portage/header.txt
> -rw-r--r-- 1 root root 121 2009-06-19 11:24 portage/header.txt
> invincible usr # umount portage && mount portage
> invincible usr # ls -lu portage/header.txt
> -rw-r--r-- 1 root root 121 2009-06-18 22:06 portage/header.txt
>
> So after umount && mount the atime instantly went back to the old  
> value. I can also sometimes reproduce it by doing "sync && echo 3 > / 
> proc/sys/vm/drop_caches". If i wait for a day the atime also reverts  
> back. Rebooting the machine has the same effect.

Right. All this says that atime is updated in the incore inode,
but never makes it to disk.
Agree, it's easily reproducible in all latest releases.

> I haven't found anything in the official documentation stating this.

That's definitely not a feature to be documented. It has to
be fixed.

> The only reference i found was a while back in the mailing list:
> http://oss.sgi.com/archives/xfs/2007-10/msg00171.html

And again a year later

http://oss.sgi.com/archives/xfs/2008-10/msg02064.html

> I think there should be at least some information about this  
> behavior in the official docs and the FAQ. IMO This feature/bug

bug :)

> of XFS also collides with the recent change to make relatime the  
> default in kernel 2.6.30.

If we properly sync the xfs inode to disk, whenever linux inode
is dirtied with updated atime, it will work exactly as in VFS
(whatever you see before remount), i.e. as relatime.

For this we need the patch suggested by Dave Chinner:

http://oss.sgi.com/archives/xfs/2008-10/msg02102.html

> Is there any way to enable permanent atime updates in case someone  
> wants them?

That's another good request I'd like to address as well. The
above mentioned patch just makes it behave as relatime.

Thanks for bringing this up.

Felix

>
>
> Michael
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
