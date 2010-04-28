Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SLc5Tm009104 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 16:38:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F24D22FAE44
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 14:40:09 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ndAN9vvUnVqJKTEj for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 14:40:09 -0700 (PDT)
Message-ID: <4BD8AB38.7050004@sandeen.net>
Date: Wed, 28 Apr 2010 16:40:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Enabling lazy counters damages filesystem
References: <4BD84771.4030804@mejor.pl>
In-Reply-To: <4BD84771.4030804@mejor.pl>
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
To: =?windows-1252?Q?Marcin_Miros=3Faw?= <marcin@mejor.pl>
Cc: xfs@oss.sgi.com

Marcin Miros?aw wrote:
> Hello,
> Please look at this:
> # mkfs.xfs -f /dev/malowazne/test
> meta-data=/dev/malowazne/test    isize=256    agcount=4, agsize=524288 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=2097152, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # xfs_check /dev/malowazne/test
> # xfs_check /dev/malowazne/test
> 
> It's still clean.
> 
> # xfs_admin -c 1 /dev/malowazne/test
> Enabling lazy-counters
> # xfs_check /dev/malowazne/test
> sb_features2 (0xa) not same as sb_bad_features2 (0x8)

ok, I guess that mechanism is not hitting both sb fields.

Should be a trivial fix, something like below.

-Eric

diff --git a/repair/phase1.c b/repair/phase1.c
index 618796e..dbfbc9b 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -117,11 +117,13 @@ phase1(xfs_mount_t *mp)
 		if (lazy_count && !xfs_sb_version_haslazysbcount(sb)) {
 			sb->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 			sb->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			sb->sb_bad_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 			primary_sb_modified = 1;
 			printf(_("Enabling lazy-counters\n"));
 		} else
 		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
 			sb->sb_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			sb->sb_bad_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 			printf(_("Disabling lazy-counters\n"));
 			primary_sb_modified = 1;
 		} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
