Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QLPYft226720 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 16:25:35 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E6ED107E9A0
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 14:34:41 -0700 (PDT)
Received: from linta.de (isilmar.linta.de [213.133.102.198]) by cuda.sgi.com
	with ESMTP id DS5asNssnhBh5oGd for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2009 14:34:41 -0700 (PDT)
Date: Fri, 26 Jun 2009 23:26:11 +0200
From: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Subject: Re: corrupt file system -- "Structure needs cleaning"
Message-ID: <20090626212611.GI29416@mail.physik.uni-wuppertal.de>
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
	<4A452CF7.3040807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A452CF7.3040807@sandeen.net>
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
To: xfs@oss.sgi.com

Thus spake Eric Sandeen (sandeen@sandeen.net):

> > [14:44] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
> 
> xfs_check doesn't actually fix anything; I'd run xfs_repair.  Use -n
> first if you want to see what it would do.

I thought that if xfs_check doesn't show any errors, the filesystem is
fine and doesn't need an xfs_repair. Is that wrong?

Anyway xfs_repair looks healthy to me:

-------------------8<---------------------
[23:23] root@jetway:~ # xfs_repair /dev/mapper/hda_crypt_vg-home
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
[23:23] root@jetway:~ # 
-------------------8<---------------------

> If it doesn't find anything, then I guess you had some in-memory corruption.

I'll run memtest.

Thanks,

    Hendrik

-- 
"You have to take the most direct road to go instead of your 
 meeting, you have to, this one ended, leave at once the CERN
 domain."         (imprint on the CERN visitor ID cards)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
