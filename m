Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D870A7F55
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 05:44:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8900BAC001
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 03:44:00 -0800 (PST)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	XKhHoea2vIuj2t6L (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jan 2013 03:43:58 -0800 (PST)
Received: by mail-qc0-f172.google.com with SMTP id b25so1226174qca.3
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 03:43:57 -0800 (PST)
MIME-Version: 1.0
From: Thomas Habets <thomas@habets.se>
Date: Thu, 31 Jan 2013 11:43:37 +0000
Message-ID: <CA+kHd+eRifnCVkri6TPKS9UcUpBSW9nPnCEz0a412vO_Aw8=Xw@mail.gmail.com>
Subject: 50% more blocks allocated than needed
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi.

I've had some files on an XFS filesystem that use way
more blocks than they need.

That is, st_size=50MB and st_blocks*512= about 68MB.

The files were downloaded with wget on a somewhat unreliable 3G
connection (50-500kBps) and sometimes defragging (xfs_fsr) fixes it,
but
sometimes not.

If st_blocks*512<st_size then it could be sparse files, but this is
the opposite. So... preallocation?

"df" before and after deleting a bunch of these files shows that the
st_blocks is what it cares about. Would the preallocation (if that's
what it is) be reclaimed if the fs started to run out of space?

If not preallocation, then what?

Note st_blocks is 134656 and xfs_bmap shows 97663 blocks.

$ ls -l foo
-rw-r--r-- 1 root root 50000000 Jan 29 01:32 foo
$ du -h foo
66M foo
$ stat foo
  File: `foo'
  Size: 50000000   Blocks: 134656     IO Block: 4096   regular file
Device: fe04h/65028d Inode: 68688483    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2013-01-30 18:56:18.603278346 +0000
Modify: 2013-01-29 01:32:51.000000000 +0000
Change: 2013-01-31 11:38:10.892330145 +0000
 Birth: -
$ xfs_bmap foo
foo:
0: [0..97663]: 44665840..44763503

--
typedef struct me_s {
 char name[]      = { "Thomas Habets" };
 char email[]     = { "thomas@habets.pp.se" };
 char kernel[]    = { "Linux" };
 char *pgpKey[]   = { "http://www.habets.pp.se/pubkey.txt" };
 char pgp[] = { "A8A3 D1DD 4AE0 8467 7FDE  0945 286A E90A AD48 E854" };
 char coolcmd[]   = { "echo '. ./_&. ./_'>_;. ./_" };
} me_t;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
