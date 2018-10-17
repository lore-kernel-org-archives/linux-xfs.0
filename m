Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:7747 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbeJQJJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 05:09:36 -0400
Date: Wed, 17 Oct 2018 12:16:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Message-ID: <20181017011624.GB6311@dastard>
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Romain Le Disez <romain.le-disez@corp.ovh.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Oct 16, 2018 at 10:22:18AM +0000, Romain Le Disez wrote:
> Hi all,
> 
> In this pseudo-code (extracted from OpenStack Swift [1]):
>     fd=open("/tmp/tempfile", O_CREAT | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     fsync(fd);
>     rename("/tmp/tempfile", "/data/foobar");
>     dirfd = open("/data", O_DIRECTORY | O_RDONLY);
>     fsync(dirfd);
> 
> OR (the same without temporary file):
>     fd=open("/data", O_TMPFILE | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     fsync(fd);
>     linkat(AT_FDCWD, "/proc/self/fd/" + fd, AT_FDCWD, "/data/foobar", AT_SYMLINK_FOLLOW);

	linkat(fd, "",  AT_FDCWD, "/data/foobar", AT_EMPTY_PATH);

>     dirfd = open("/data", O_DIRECTORY | O_RDONLY);
>     fsync(dirfd);

> I’m guaranteed that, what ever happen, I’ll have a
> complete file (data+xattr) or no file at all in the directory
> /data.

Yes.

> Second question, if I replace the two fsync() by one sync(), do I
> get the same guarantee?
>     fd=open("/data", O_TMPFILE | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     linkat(AT_FDCWD, « /proc/self/fd/" + fd, AT_FDCWD, "/data/foobar", AT_SYMLINK_FOLLOW);
>     sync();
> 
> From what I understand of the FAQ [1], write_barrier guarantee
> that journal (aka log) will be written before the inode (aka
> metadata). Did I miss something?

"write barriers" don't exist anymore. What we have these days are
cache flushes to correctly order data/metadata IO vs journal IO.

The syncfs() operation (and sync(), which is just syncfs() across
all filesystems) writes oustanding data first, then asks the
filesystem to force metadata to stable storage. XFS does that with
a log flush, which issues a cache flush (data now on stable storage)
followed by FUA log writes (metadata now on stable storage in the
journal).

So, effectively, you get the same thing in both cases. The only
difference is that sync() does a lot more work than a couple of
fsync() operations, and does work system wide on filesystems and
files you don't care about. fsync() will always perform better on a
busy system than a sync call.

Let the filesystem worry about optimising fsync calls necessary for
consistency and integrity purposes. If there was a faster way than
issuing fsync on only the objects that need it when required, then
everyone would be using it all the time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
