Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BACA7F4E
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 14:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6283AC00C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 12:53:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VETHBaFLcZ8EcZRO for <xfs@oss.sgi.com>;
	Tue, 07 Oct 2014 12:53:21 -0700 (PDT)
Date: Wed, 8 Oct 2014 06:53:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted filesystem: thoughts?
Message-ID: <20141007195318.GQ2301@dastard>
References: <20141007093533.66ba8c7b@galadriel.home>
	<20141007105657.GO2301@dastard>
	<20141007132210.55b2183a@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141007132210.55b2183a@harpe.intellique.com>
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

On Tue, Oct 07, 2014 at 01:22:10PM +0200, Emmanuel Florac wrote:
> Le Tue, 7 Oct 2014 21:56:57 +1100
> Dave Chinner <david@fromorbit.com> =E9crivait:
> =

> > Is the log clean? (use xfs_logprint -t <dev> to determine that)
> > =

> =

> No, it wasn't, that was probably the source of most of the ominous
> messages. The many files in lost+found were probably deleted files

You really, really want to recover the log before running repair if
possible.

> In case this may help someone, before running xfs_repair I've mounted
> the volume in "ro,nonrecovery" mode, then ran this command to make a
> listing of files with their inodes: =

> =

>  find /mnt/raid/ -print0 | xargs --null ls -di | gzip - > FILELIST.gz

Generating the list before recovery is run will result in a
partial list because there will be parts of the directory heirarchy
that can't be traversed due to corruption. So there's no guarantee
that this list will be in any way complete.

Besides, we already have amore robust offline tool for generating
such a list:

$ man xfs_ncheck
....
xfs_ncheck with no -i arguments generates an inode number and
pathname list of all files on the given filesystem.
...

It will also tell you when it fails to resolve a pathname or inode
number due to corruption, so you have direct indication of what
inodes and/or paths are broken.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
