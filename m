Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B05F7F73
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 06:38:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B451AC004
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:38:09 -0700 (PDT)
Received: from mail-pb0-f41.google.com (mail-pb0-f41.google.com
	[209.85.160.41]) by cuda.sgi.com with ESMTP id 50CuC0dYO2bOpMqq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:38:07 -0700 (PDT)
Received: by mail-pb0-f41.google.com with SMTP id um15so4914545pbc.0
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
	<5134BBA4.3060305@sandeen.net>
	<CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
From: Ole Tange <tange@binf.ku.dk>
Date: Tue, 12 Mar 2013 12:37:46 +0100
Message-ID: <CANU9nTkG_XrNhDjGfRBofJkz=KryDmLGGJnYsBXyH5Ng=uiRWg@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

(Forgot CC-to list)

On Fri, Mar 8, 2013 at 11:21 AM, Ole Tange <tange@binf.ku.dk> wrote:
> On Mon, Mar 4, 2013 at 4:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> 2) so you could run a "real" non-"n" xfs_repair on a metadata image as a more realistic dry run

So I made a new metadata image using xfs_metadump.sh from git:

    ./xfs_metadump.sh -o /dev/md123p1 franklin.xfs.metadump
    pbzip2 franklin.xfs.metadump

Then I restored it:

    pbzip2 -dc < franklin.xfs.noobfuscate.metadump.bz2 |
      time ~/work/xfsprogs/mdrestore/xfs_mdrestore - franklin.img

Then I ran git version of xfs_repair (first with -n, then no option,
then with -L):

$ ~/work/xfsprogs/repair/xfs_repair -n franklin.img
# Load of output. Completes OK.

$ ~/work/xfsprogs/repair/xfs_repair  franklin.img
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

$ ~/work/xfsprogs/repair/xfs_repair -L franklin.img
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
xfs_repair: scan.c:1080: scan_freelist: Assertion `0' failed.
Aborted (core dumped)

Then I restored the metadata:

    pbzip2 -dc < franklin.xfs.noobfuscate.metadump.bz2 |
      time ~/work/xfsprogs/mdrestore/xfs_mdrestore - franklin.img

Then I ran xfs_repair version 3.1.7. This gave a lot of output but
completed without core dumping.

The resulting filesystem was mountable and contained at least some of
the filenames I expected.

I believe either there is a new bug in the git version, or it simply
discovers a bug that 3.1.7 does not.

metadata, xfs_repair binary, core:
http://dna.ku.dk/~tange/xfs/


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
