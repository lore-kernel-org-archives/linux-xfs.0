Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTKt8bM002926 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:55:09 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29196500EA
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:55:07 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id spZXjncUtE3walT5
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:55:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 8B2B01C1A2435
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 21:55:06 +0100 (CET)
Date: Mon, 29 Dec 2008 21:55:06 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: A rescue tool: xfs_irecover
Message-ID: <alpine.LSU.2.00.0812292059020.15355@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
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



Something must have went awry at a friend; anyway, xfs_check returned 
the presence of problems, and xfs_repair was ran to rectify these. The 
end result was that there were a total of ~500 inodes left according to 
the superblock. While people can go debate on whose fault it was (cosmic 
radiation, take your pick), I set out on getting the data back.

XFS's data layout makes it very easy to recover (inode magic bytes is a 
key component--most inferior filesystems do not seem to have such). What 
I did is scan and extract all inodes, giving me back about ~11000 inodes 
with useful data (some NUL bytes here and there, but still, rather 
complete compared to a lousy 500 inodes).

Here, I want to share this little tool -- called it xfs_irecover.

Currently housed inside a tool collection of mine; xfs_irecover
just got imported into it.
http://dev.medozas.de/gitweb.cgi?p=hxtools;a=commit;h=8b75265ce475e1f696801285c37e86c933e0a086

Apologies for not having bothered using libxfs, but I needed to get 
something working fast. This also explains all the hacks involved, like 
reading the inode from the block device itself (in the 'ir_extract' 
function) and only calling out to xfs_db for grabbing the extent list (I 
was not sure whether the extent list always has to fit within the 
inode). Furthermore, it makes conservative use of forking, only ever 
starts one instance of xfs_db [doing it once for every node using 
`xfs_db -c inode 0 -c print` is prohibitively expensive at 250 GB with 
inode_size=256] and (ab)uses its command-line interface in as far that 
xfs_db even needs a patch to set stdin and stdout to non-buffering mode. 

But that makes it reasonably fast. The disk was, as mentioned, a ~250GB 
with an inode size of 256, and that makes for a lot of potential inodes; 
processing the ~11000 took about 20-30 minutes.

Various options control extraction; as xfs_irecover ignores any 
directories and/or free/in-use bitmaps, even the "legitimately deleted" 
(deleted before the desaster) inodes can be recovered, it may run over 
scrapped data that can selectively be ignored. Inodes with ridiculously 
large "core.size" values or empty extent lists are skipped, for others, 
core.size is ignored if the number of bytes that the extent list spans 
is just 'slightly' larger (core.size < S, but a hexdump shows there's 
more than S bytes of "intereting" data, for a chosen S, something like 
that).

There probably is room for improvement, like analyzing S_ISDIR inodes 
and looking at the filenames it contains, to help in giving recovered 
inodes some name.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
