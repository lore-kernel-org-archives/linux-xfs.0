Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CE7A7F55
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 15:38:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CD988F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 13:38:50 -0700 (PDT)
Received: from chaos.caltech.edu (chaos.caltech.edu [131.215.34.119]) by
	cuda.sgi.com with ESMTP id Agh7fqjjhQpllpv1 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 13:38:49 -0700 (PDT)
From: Diane Trout <diane@caltech.edu>
Subject: Re: Corrupted file system
Date: Wed, 24 Sep 2014 13:38:27 -0700
Message-ID: <705802842.F0QjhfVGQR@myrada>
In-Reply-To: <20140924120840.1be78240@harpe.intellique.com>
References: <5839367.DyqsVHbRuQ@myrada>
	<20140924120840.1be78240@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Wednesday, September 24, 2014 12:08:40 Emmanuel Florac wrote:
> Le Tue, 23 Sep 2014 15:02:57 -0700
> =

> Diane Trout <diane@caltech.edu> =E9crivait:
> > I had a raid failure at work that ended up corrupting an xfs
> > filesystem the tail of the xfs_repair command looks like the below. I
> > was able to generate a metadata dump but is there a point to making
> > it available?
> > =

> > It does crash repeatedly at the same place
> =

> Did you try the very latest xfs_repair?


I grabbed the one out of debian unstable (3.2.1), verified that it was your =

latest release and used that. I didn't try building the version in git.

It did get much further than version 3.1.7+b1 (debian stable)

Diane

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "lymphoblastoid" in dir ino 256 doesn't have a .. entry, will set it =
in =

ino 2051.
bad hash table for directory inode 256 (no data entry): rebuilding
rebuilding directory inode 256
7f70c79c8700: Badness in key lookup (length)
bp=3D(bno 0x3480, len 4096 bytes) key=3D(bno 0x3480, len 8192 bytes)
Metadata corruption detected at block 0x4000070/0x1000
xfs_da_do_buf(2): XFS_CORRUPTION_ERROR

fatal error -- can't read block 8388608 for directory inode 259, error 117


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
