Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 13:21:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TLLCJj021332
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 13:21:14 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1109D5780EA
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 13:21:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id bGQUrQk6Ofx8g4kZ for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 13:21:33 -0800 (PST)
Message-ID: <479F98BC.6060507@sandeen.net>
Date: Tue, 29 Jan 2008 15:21:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <20080129171658.GB21228@citd.de> <479F893A.1030402@sandeen.net> <20080129203731.GA29094@puku.stupidest.org>
In-Reply-To: <20080129203731.GA29094@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Matthias Schniedermeyer <ms@citd.de>, xfs@oss.sgi.com, Barry Naujok <bnaujok@sgi.com>

Chris Wedgwood wrote:
> On Tue, Jan 29, 2008 at 02:14:50PM -0600, Eric Sandeen wrote:
>
>   
>> [root@magnesium tmp]# mkfs.xfs -dfile,name=xfsfile,size=750156369920
>>     
>
> I see this too except I'm pre-creating a file of the right length:
>
> -rw-r--r-- 1 root root 750156369920 Jan 29 12:35 xfsfile
>
> [...]
>
> /root/xfsfile  xfs    524G  4.2M  524G   1% /mnt/tmp
>
>   
I think this fixes it, but it was just a quickie so pls double check :)

if agcount * agsize <= dblocks, then the last ag shouldn't be "small"

-Eric

Index: xfsprogs-2.9.5/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-2.9.5.orig/mkfs/xfs_mkfs.c
+++ xfsprogs-2.9.5/mkfs/xfs_mkfs.c
@@ -523,7 +523,8 @@ validate_ag_geometry(
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
 	 */
-	if ( dblocks % agsize != 0 &&
+	if ( agcount * agsize > dblocks &&
+	     dblocks % agsize != 0 &&
 	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
 		fprintf(stderr,
 	_("last AG size %lld blocks too small, minimum size is %lld blocks\n"),
@@ -1808,7 +1809,8 @@ _("size %s specified for log subvolume i
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
 	 */
-	if ( dblocks % agsize != 0 &&
+	if ( agcount * agsize > dblocks &&
+	     dblocks % agsize != 0 &&
 	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
 		dblocks = (xfs_drfsbno_t)((agcount - 1) * agsize);
 		agcount--;
