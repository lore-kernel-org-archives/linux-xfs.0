Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8UKevM2047982 for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 15:40:57 -0500
Received: from sj-iport-5.cisco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC586171D260
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 13:42:19 -0700 (PDT)
Received: from sj-iport-5.cisco.com (sj-iport-5.cisco.com [171.68.10.87]) by
	cuda.sgi.com with ESMTP id TCkKsxIW2skD0RUu for
	<xfs@oss.sgi.com>; Wed, 30 Sep 2009 13:42:19 -0700 (PDT)
Received: from sj-core-2.cisco.com (sj-core-2.cisco.com [171.71.177.254])
	by sj-dkim-4.cisco.com (8.12.11/8.12.11) with ESMTP id n8UKgI38001764
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 13:42:18 -0700
Received: from xbh-sjc-221.amer.cisco.com (xbh-sjc-221.cisco.com
	[128.107.191.63])
	by sj-core-2.cisco.com (8.13.8/8.14.3) with ESMTP id n8UKgIw7027429
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2009 20:42:18 GMT
Subject: Extended attribute caching questions
From: Richard <rtroxell@cisco.com>
Date: Wed, 30 Sep 2009 13:42:03 -0700
Message-Id: <1254343323.4670.3749.camel@rtroxell-laptop>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Hello All,

Terribly sorry for the long message. I have been digging for attribute
caching details everywhere, but cant seem to find any complete answers.

I am reading up on extended attributes, and see a great potential for
reducing the complexity of managing metadata associated with a file. The
approach I would be replacing uses a scheme where by meta files are
stored in the same directory as the data file with fixed tags appended
to the original file's name.

foo/bar
foo/bar.XXX
foo/bar.YYY

The idea, as expected, is to place the meta information beneath foo/bar,
with large attributes XXX and YYY. 

In my case, I have 2 - 3 meta file containing roughly 3k of packed data.
For simplicity / syscall overhead sakes it will be most conveinient for
me to simply stuff the existing formats within the attributes, treating
them like forks. I also need to account for potentially large volumes of
files (ex: 1 Million or greater) spread across the filesystem.

In this scenario (small attribute count, large attribute size), the
ideal solution would be to have a special short-form attribute type that
directly references a standalone extent(s); again, much like a file
fork. The benefit here, is that the single inode would be able to map
the data of 3 different files, resulting in a 3:1 reduction in I/O
lookup overhead and a 3:1 reduction of inode/dentry cache entries.

While this would be ideal for my particular case, my understanding is
that, in this scenario, XFS will create 'leaf attributes.' This is
understandable given the N/V interface of attributes, however, I get the
impression that the overall performance could be worse than the 3 file
approach, as the leaf block will place an additional I/O between the
inode and meta data.

Though the I/O seems to be higher in this scenario, the simplcity of the
attribute design might still outweigh the performance impact. Once more,
given a mostly-read scenario, the effective I/O overhead could be
greatly reduced depending on how the leaf block / attribute data are
cached.

In the typical 'file' scenario, dentries and inodes will be cached in
their respective VFS caches, and file data will be cached in association
with the inode's address space via the page cache. To my knowledge, none
of these caches gel with the concept of extended attributes, and thus,
if caching is happening, it would be up to the filesystem to implement
it.

That said, here are my basic questions...

1) How are leaf blocks cached? What are the cached entries lifetimes,
and when will the cache shrink?

2) How will attribute data be cached, and what is its lifetime? Is there
a XFS-maintained equivalent of a page cache?

3) Does an extended attribute modification update the inode? This would
imply 3 updates for adding an attribute: inode, leaf block, data
block(s)... or more if the temporary state of leaf attribute while
allocating external blocks?


Also, I am happy to trace through the code, if someone can point me to
the respective functions / files.

Thanks,
Richard


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
