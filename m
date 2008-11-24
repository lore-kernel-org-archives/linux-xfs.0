Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAOBdJWa000781 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 05:39:20 -0600
Received: from col0-omc4-s10.col0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45A8E15C5E24
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 03:39:13 -0800 (PST)
Received: from col0-omc4-s10.col0.hotmail.com (col0-omc4-s10.col0.hotmail.com
	[65.55.34.212]) by cuda.sgi.com with ESMTP id l0x2vBSMwSAGRvMU
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 03:39:13 -0800 (PST)
Message-ID: <COL110-W25D31A7548A252BA99A013A5080@phx.gbl>
From: ". ." <moonraket@hotmail.com>
Subject: fatal error -- bad magic # (0x0) for directory data block (bno 0
	fsbno 7)
Date: Mon, 24 Nov 2008 11:39:13 +0000
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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


Hi,

I'm getting this error after running xfs_repair on a disk:
fatal error -- bad magic # (0x0) for directory data block (bno 0 fsbno 7)

It all started with smartmontools telling there was a bad block, via http://smartmontools.sourceforge.net/badblockhowto.html and http://oss.sgi.com/archives/xfs/2005-08/msg00099.html I tried to determine what file exactly it was, but an md5sum of it said everything was ok. I tried both the manual calculation and the convert method to get the fsb, both giving me a different inode/file.
Giving no result, I used badblocks in non-destructive mode on an area around the fsb I calculated, and it it seems it was after that the disk listed nothing when mounted. Could badblocks in non-destructive mode have caused that?
Then, an umount/mount didn't help and an xfs_check and xfs_repair later it gave that fatal error.
There's also a lot of other errors in that repair-log:
"
bad magic number 0xa371 on inode 148
bad version number 0x1c on inode 148
bad inode format in inode 148
bad magic number 0xfd35 on inode 149
bad version number 0xffffffb9 on inode 149
bad (negative) size -8929491557123885919 on inode 149
"
etc...

If wanted I can attach logs of the xfs_check/repair, smartctl error ...

Thanks for any help, please CC me as I'm not subscribed to the list.



   C.


_________________________________________________________________
Invite your mail contacts to join your friends list with Windows Live Spaces. It's easy!
http://spaces.live.com/spacesapi.aspx?wx_action=create&wx_url=/friends.aspx&mkt=en-us

[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
