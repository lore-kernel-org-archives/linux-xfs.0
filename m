Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 832F77F76
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 19:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FC67AC002
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 17:25:29 -0700 (PDT)
Received: from chaos.caltech.edu (chaos.caltech.edu [131.215.34.119]) by
	cuda.sgi.com with ESMTP id Ef7HBpce5xxBaFdS (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 17:25:28 -0700 (PDT)
From: Diane Trout <diane@caltech.edu>
Subject: Re: Corrupted file system
Date: Wed, 24 Sep 2014 17:25:12 -0700
Message-ID: <2047180.98c6Ryq0NE@myrada>
In-Reply-To: <54233051.4070709@sandeen.net>
References: <5839367.DyqsVHbRuQ@myrada> <705802842.F0QjhfVGQR@myrada>
	<54233051.4070709@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Huh.

I'd managed to make a metadump using the 3.1.7 version of the tools. Then I =

tried to run xfs_repair on the partition, and now xfs_metadump is segfaulti=
ng =

on the partition.

Would the older metadata dump be useful?

I'd need to rebuild xfsprogs before the stack trace would be useful... debi=
an =

likes to strip the symbols and they didn't make a -dbg package.

Diane

On Wednesday, September 24, 2014 15:57:53 Eric Sandeen wrote:
> If you want to make a metadata image, compress it, and send it my way I'd=
 be
> glad to look at it - I've been doing some repair work lately.
> =

> -Eric
> =

> On 9/24/14 3:38 PM, Diane Trout wrote:
> > On Wednesday, September 24, 2014 12:08:40 Emmanuel Florac wrote:
> >> Le Tue, 23 Sep 2014 15:02:57 -0700
> >> =

> >> Diane Trout <diane@caltech.edu> =E9crivait:
> >>> I had a raid failure at work that ended up corrupting an xfs
> >>> filesystem the tail of the xfs_repair command looks like the below. I
> >>> was able to generate a metadata dump but is there a point to making
> >>> it available?
> >>> =

> >>> It does crash repeatedly at the same place
> >> =

> >> Did you try the very latest xfs_repair?
> > =

> > I grabbed the one out of debian unstable (3.2.1), verified that it was
> > your
> > latest release and used that. I didn't try building the version in git.
> > =

> > It did get much further than version 3.1.7+b1 (debian stable)
> > =

> > Diane
> > =

> > Phase 6 - check inode connectivity...
> > =

> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> > =

> > entry "lymphoblastoid" in dir ino 256 doesn't have a .. entry, will set=
 it
> > in ino 2051.
> > bad hash table for directory inode 256 (no data entry): rebuilding
> > rebuilding directory inode 256
> > 7f70c79c8700: Badness in key lookup (length)
> > bp=3D(bno 0x3480, len 4096 bytes) key=3D(bno 0x3480, len 8192 bytes)
> > Metadata corruption detected at block 0x4000070/0x1000
> > xfs_da_do_buf(2): XFS_CORRUPTION_ERROR
> > =

> > fatal error -- can't read block 8388608 for directory inode 259, error =
117
> > =

> > =

> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
