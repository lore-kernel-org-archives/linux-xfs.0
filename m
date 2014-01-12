Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFF1B7F3F
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 12:47:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B6C58F8054
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 10:47:51 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 0gAMRPS4biUscZ3m
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 10:47:50 -0800 (PST)
Message-ID: <52D2E358.6070106@hardwarefreak.com>
Date: Sun, 12 Jan 2014 12:47:52 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
In-Reply-To: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zachary Kotlarek <zach@kotlarek.com>, xfs@oss.sgi.com

On 1/12/2014 7:28 AM, Zachary Kotlarek wrote:
> My XFS filesystem dismounted while copying a ~3 GB file. I won=92t
> claim to know why; I=92m fairly confident only that 1 file was being
> modified at the time. The log replayed cleanly when remounting, but
> attempting to remove the file in question caused the same dismount.
> =

> So I ran xfs_repair. It put one file in lost+found (which appears to
> be written when if failed initially) and reported a number or
> warnings to the effect of: bad hash table for directory inode 2054
> (hash value mismatch): rebuilding rebuilding directory inode 2054 =

> which I didn=92t take to be serious, though I suspect now that=92s where
> things went wrong.
> =

> I now have 23 directories (matching the 23 =93rebuilding" messages)
> where a file or directory with non-ASCII characters in the name
> exists in the directory list but cannot be read or deleted:
> =

> ls -la ls: cannot access 07 - Se=F1or Macho Solo.m4v: No such file or
> directory -rw-rw----+  1 profplump media 332M Sep 11  2010 06 -
> Christmas Special.m4v ???????????  ? ?         ?        ?
> ? 07 - Se??or Macho Solo.m4v -rw-rw----+  1 profplump media 304M Sep
> 11  2010 08 - Flu Shot.m4v
> =

> So the file exists in the directory listing (`ls` and `find` can both
> see it) but I cannot delete or stat or open it. If I touch the
> affected filename I get a second entry in the directory listing, both
> apparently pointing to the same, new, empty file. If I then delete
> the same filename I get back to the original state =97 a single,
> unusable directory entry.
> =

> I=92d like to (if possible) re-link those directory listings to the
> related files, or at least delete them so the files can be restored
> and folders can be used normally. I=92m also worried that running
> xfs_repair in the future might re-create this problem.
> =

> But I don=92t even know where to start in trying to fix this. And I
> still cannot delete the file that started this whole sequence of
> events. So if anyone has suggestions I=92d be happy to hear them.

Start here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

If this is due to a bug it may have already been fixed.  Note the first
two things asked for.


-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
