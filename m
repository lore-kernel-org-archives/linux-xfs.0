Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145858.alnmqbyqqnjqonue@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:43592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdBXMaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 07:30:20 -0500
Date: Fri, 24 Feb 2017 07:30:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair fails to recognize corruption reported by kernel -
 possible bug?
Message-ID: <20170224123017.GA59560@bfoster.bfoster>
References: <CADcJnz_TWkhhPVr7fmVHoZtjOkGDJxTqtcuz_Ef15rguUW3bdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADcJnz_TWkhhPVr7fmVHoZtjOkGDJxTqtcuz_Ef15rguUW3bdA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mathias Troiden <mathias.troiden@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 23, 2017 at 11:14:47PM +0300, Mathias Troiden wrote:
> Original topic: https://bbs.archlinux.org/viewtopic.php?pid=1692896
> 
> Hi list,
> 
> My system fails to start login manager with following messages in journal:
> 
> >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
> >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
> >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
> >kernel: XFS (sda1): xfs_iread: validation failed for inode 34110192 failed
> >kernel: ffff88040e8bc000: 49 4e a1 ff 03 01 00 00 00 00 00 00 00 00 00 00  IN..............
> >kernel: ffff88040e8bc010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >kernel: ffff88040e8bc020: 58 aa 04 b8 2e e3 65 3a 57 41 fe 12 00 00 00 00  X.....e:WA......
> >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
> >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
> >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
> 
> 
> and subsequent core dump of the login manager.
> 

What kernel and xfsprogs versions? Also, please provide 'xfs_info <mnt>'
output for the fs.

>From the output above, it looks like you could have a zero-sized
symlink, which triggers xfs_dinode_verify() failure. It's quite possible
I'm misreading the raw inode buffer output above too, however.. Did you
have any interesting "events" before this problem started to occur? For
example, a crash or hard reset, etc.?

Could you run 'find <mnt> -inum 34110192 -print' on the fs and report
the associated filename? You could try 'stat <file>' as well but I'm
guessing that's just going to report an error.

Note that another way to get us details of the fs is to send an
xfs_metadump image. An md image skips all file data in the fs and
obfuscates metadata (such as filenames) such that no sensitive
information is shared. It simply provides a skeleton metadata image for
us to debug. To create an obfuscated metadump, run 'xfs_metadump -g
<dev> <outputimg>,' compress the resulting image file and send it along
(feel free to send directly) or upload it somewhere.

Brian

> 
> However, neither 'xfs_repair -d' run from running system nor
> 'xfs_repair -n' run from liveUSB recognized a problem i.e. returned
> output expected of clean FS.
> 
> Memtester, 'find /mnt/ -type f -exec dd if={} of=/dev/null status=none
> \;', SMART test outputs are also clean.
> 
> The issue I've encountered after logging into tty2 was that I couldn't
> start X - perhaps that's where the corruption occured:
> >sudo startx
> >zsh: command startx not found
> 
> sda1 is my root partition.
> 
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
