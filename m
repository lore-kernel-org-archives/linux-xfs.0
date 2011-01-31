Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0V4iwvR070967 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 22:44:59 -0600
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83D98E7237
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 20:47:25 -0800 (PST)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id IaDo5HdWvgOHd5qU
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 20:47:25 -0800 (PST)
Received: by fxm11 with SMTP id 11so5886615fxm.26
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 20:47:24 -0800 (PST)
MIME-Version: 1.0
From: Phil Karn <karn@philkarn.net>
Date: Sun, 30 Jan 2011 20:47:03 -0800
Message-ID: <AANLkTim0h1Ez8f8YprUqUv=4OvAfDPStS8yM8Kdq5bCc@mail.gmail.com>
Subject: reordering file operations for performance
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6617646324251332238=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6617646324251332238==
Content-Type: multipart/alternative; boundary=20cf30433e3eaef9f2049b1d1ca8

--20cf30433e3eaef9f2049b1d1ca8
Content-Type: text/plain; charset=UTF-8

I have written a file deduplicator, dupmerge, that walks through a file
system (or reads a list of files from stdin), sorts them by size, and
compares each pair of the same size looking for duplicates. When it finds
two distinct files with identical contents on the same file system, it
deletes the newer copy and recreates its path name as a hard link to the
older version.

For performance it actually compares SHA1 hashes, not the actual file
contents. To avoid unnecessary full-file reads, it first compares the hashes
of the first pages (4kiB) of each file. Only if they match will I compute
and compare the full file hashes. Each file is fully read at most once and
sequentially, so if the file occupies a single extent it can be read in a
single large contiguous transfer. This is noticeably faster than doing a
direct compare, seeking between two files at opposite ends of the disk.

I am looking for additional performance enhancements, and I don't mind using
fs-specific features. E.g., I am now stashing the file hashes into xfs
extended file attributes.

I regularly run xfs_fsr and have added fallocate() calls to the major file
copy utilities, so all of my files are in single extents. Is there an easy
way to ask xfs where those extents are located so that I could sort a set of
files by location and then access them in a more efficient order?

I know that there's more to reading a file than accessing its data extents.
But by the time I'm comparing files I have already lstat()'ed them all so
their inodes and directory paths are probably all still in the cache.

Thanks,
Phil

--20cf30433e3eaef9f2049b1d1ca8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have written a file deduplicator, dupmerge, that walks through a file sys=
tem (or reads a list of files from stdin), sorts them by size, and compares=
 each pair of the same size looking for duplicates. When it finds two disti=
nct files with identical contents on the same file system, it deletes the n=
ewer copy and recreates its path name as a hard link to the older version.<=
br>

<br>For performance it actually compares SHA1 hashes, not the actual file c=
ontents. To avoid unnecessary full-file reads, it first compares the hashes=
 of the first pages (4kiB) of each file. Only if they match will I compute =
and compare the full file hashes. Each file is fully read at most once and =
sequentially, so if the file occupies a single extent it can be read in a s=
ingle large contiguous transfer. This is noticeably faster than doing a dir=
ect compare, seeking between two files at opposite ends of the disk.<br>

<br>I am looking for additional performance enhancements, and I don&#39;t m=
ind using fs-specific features. E.g., I am now stashing the file hashes int=
o xfs extended file attributes.<br><br>I regularly run xfs_fsr and have add=
ed fallocate() calls to the major file copy utilities, so all of my files a=
re in single extents. Is there an easy way to ask xfs where those extents a=
re located so that I could sort a set of files by location and then access =
them in a more efficient order?<br>

<br>I know that there&#39;s more to reading a file than accessing its data =
extents. But by the time I&#39;m comparing files I have already lstat()&#39=
;ed them all so their inodes and directory paths are probably all still in =
the cache.<br>

<br>Thanks,<br>Phil<br><br><br><br>

--20cf30433e3eaef9f2049b1d1ca8--


--===============6617646324251332238==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6617646324251332238==--
