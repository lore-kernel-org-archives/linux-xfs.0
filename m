Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbeJFV0I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 Oct 2018 17:26:08 -0400
Subject: Re: XFS mount problem
References: <20181006140317.148fe46d@acer-suse.lan>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <93a3ae91-b69a-a8a6-f196-c539333e3027@sandeen.net>
Date: Sat, 6 Oct 2018 09:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <20181006140317.148fe46d@acer-suse.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Howorth <dave@howorth.org.uk>, linux-xfs@vger.kernel.org

On 10/6/18 8:03 AM, Dave Howorth wrote:
> We had a very brief power-glitch last night, but it was enough to cause
> my PC to reboot. But the reboot didn't come up cleanly.
> 
> It was complaining about not being able to mount an XFS filesystem
> that I use for storing recorded TV programmes. In fact mount claims
> 'wrong fs type':
> 
> # mount -v /srv/live-tv/
> mount: /srv/live-tv: wrong fs type, bad option, bad superblock
> on /dev/mapper/mint_vg-live--tv_lv, missing codepage or helper program,
> or other error.

You need to look to the kernel logs to know what actually went wrong
with the mount.

> The mount is being tried against fstab:
> 
> # grep live-tv /etc/fstab
> #LABEL=LiveTV         /srv/live-tv         xfs        noatime,noacl 0 2
> /dev/mint_vg/live-tv_lv   /srv/live-tv    xfs        noatime,noacl 0 2
> 
> I normally mount this filesystem by label but I commented that out to
> get the system to boot and I added the /dev line as a more basic method
> to see if it helped, but it gives the same error.
> 
> # l /dev/mint_vg/live-tv_lv
> lrwxrwxrwx 1 root root 7 Oct  6 09:45 /dev/mint_vg/live-tv_lv -> ../dm-3
> 
> The XFS filesystem is in an LV. lv/pv/vgscan all report everything
> normal; I don't think there's a problem at the LVM level.
> 
> I tried xfs_repair -n:
> 
> # xfs_repair -n /dev/dm-3
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is
> being ignored because the -n option was used.  Expect spurious
> inconsistencies which may be resolved by first mounting the filesystem
> to replay the log.

The log is dirty as expected.  But at least xfs_repair thinks it is an
xfs filesystem, and it looks intact.

Try 

# mount /dev/dm-3 /srv/live-tv 

and if that fails, type "dmesg" to show the kernel message, look towards the
end to see what it thinks went wrong.

>         - scan filesystem freespace and inode maps...
> sb_ifree 81, counted 80
> sb_fdblocks 12504226, counted 12276402
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> imap claims a free inode 135 is in use, would correct imap and clear
> inode
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
> entry "Coronation Street Omnibus.ts" at block 0 offset 3848 in
> directory inode 96 references free inode 135 would clear inode number
> in entry at offset 3848...
>         - agno = 3
>         - agno = 2
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> entry "Coronation Street Omnibus.ts" in directory inode 96 points to
> free inode 135, would junk entry bad hash table for directory inode 96
> (no data entry): would rebuild
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> 
> 
> This is openSUSE Leap 15.0
> 
> I'm a bit stuck now; my XFS foo is not strong today, it seems. Can
> anybody suggest what my next steps should be? I'll keep googling but I
> hope somebody may have more informed ideas :)

Look at the end of "dmesg" output when mount fails.

-Eric
