Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UIUL5B228331 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 12:30:21 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 482901C922FA
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:31:27 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id W4rJ2KoseDwBsHv9 for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:31:27 -0800 (PST)
Message-ID: <4B647AFE.5000507@sandeen.net>
Date: Sat, 30 Jan 2010 12:31:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
References: <4B633F9A.8000404@sandeen.net>
	<20100130105501.GA22909@infradead.org>
	<4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org>
In-Reply-To: <20100130172502.GA788@thunk.org>
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
To: tytso@mit.edu
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, Giel de Nijs <giel@vectorwise.com>, xfs-oss <xfs@oss.sgi.com>

tytso@mit.edu wrote:
> On Sat, Jan 30, 2010 at 10:15:09AM -0600, Eric Sandeen wrote:
>>> me on a 32-bit machine.  The patch below fixes it up, but it seems like
>>> we should rather add a variant of that code as aio_read/write commands
>>> to xfs_io instead of adding a new test program.
>> ok, that's probably better - again, though, it takes at least a release
>> cycle before most folks can test it.  But I guess that's not the end of
>> the world.
> 
> Stupid question --- who uses xfs_io besides xfstests?  Any chance we
> could consider dropping in some version of xfs_io into xfstests, or
> actually moving it into xfstests from xfsprogs if xfstests is the
> exclusive user of that program?  I've been trying to get more people
> to use xfstests, since it would be good if more companies and more
> projects were using it --- and one of the things that makes it hard is
> all of the dependencies that it has.  If there was some way we could
> gradually make xfstests more self-contained, it would certainly be
> nice.
> 
> 						- Ted

These are the deps that I know xfstests has, to build and to run:

BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
BuildRequires:  libacl-devel, libattr-devel, libaio-devel

Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
Requires:       bc, indent, quota

which isn't so bad...
(and tests are just skipped if xfsdump isn't there)

I'm not sure an xfsprogs dependency is so onerous; plenty has depended
on e2fsprogs through the years and we've lived with that ;)  But
the lag time for xfsprogs to use released xfs_io functionality is a
bit of a bummer.

But I guess I don't have a great answer for who else uses xfs_io:

xfs_io(8)                                            xfs_io(8)

NAME
       xfs_io - debug the I/O path of an XFS filesystem

SYNOPSIS
       xfs_io [ -adFfmrRstx ] [ -c cmd ] ... [ -p prog ] file

DESCRIPTION
       xfs_io  is a debugging tool like xfs_db(8), but is aimed
       at examining the regular file I/O paths rather than  the
       raw  XFS  volume  itself. 

I guess it's not really advertised as a generic tool, and it's
in the sbin path...

I guess I could live with it either way - I suppose my main concern
is that xfstests is a mess to package for a distro, and I really like
easy access to xfs_io for my own use outside of xfstests.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
