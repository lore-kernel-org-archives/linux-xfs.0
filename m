Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03C467F67
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 11:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9333CAC007
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 09:29:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id utCRvWzKxP0ugqRD for
	<xfs@oss.sgi.com>; Fri, 21 Mar 2014 09:29:24 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2LGTNTF019534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 12:29:23 -0400
Received: from laptop.bfoster (vpn-60-19.rdu2.redhat.com [10.10.60.19])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s2LGTMRk027370
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 12:29:23 -0400
Received: from laptop.bfoster (localhost.localdomain [127.0.0.1])
	by laptop.bfoster (Postfix) with ESMTP id 55825120AF8
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 12:29:22 -0400 (EDT)
Received: (from bfoster@localhost)
	by laptop.bfoster (8.14.7/8.14.7/Submit) id s2LGTLpB007876
	for xfs@oss.sgi.com; Fri, 21 Mar 2014 12:29:21 -0400
Date: Fri, 21 Mar 2014 12:29:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [FAQ] XFS speculative preallocation
Message-ID: <20140321162920.GA3087@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi all,

Eric had suggested we add an FAQ entry for speculative preallocation
since it seems to be a common question, so I offered to write something
up. I started with a single entry but split it into a couple Q's when it
turned into TL;DR fodder. ;)

The text is embedded below for review. Thoughts on the questions or
content is appreciated. Also, once folks are Ok with this... how does
one gain edit access to the wiki?

Brian

---

Q: Why do files on XFS use more data blocks than expected?

A:

The XFS speculative preallocation algorithm allocates extra blocks
beyond end of file (EOF) to combat fragmentation under parallel
sequential write workloads. This post-EOF block allocation is included
in 'st_blocks' counts via stat() system calls and is accounted as
globally allocated space by the filesystem. This is reported by various
userspace utilities (stat, du, df, ls) and thus provides a common source
of confusion for administrators. Post-EOF blocks are temporary in most
situations and are usually reclaimed via several possible mechanisms in
XFS.

See the FAQ entry on speculative preallocation for details.

Q: What is speculative preallocation? How can I manage it?

A:

XFS speculatively preallocates post-EOF blocks on file extending writes
in anticipation of future extending writes. The size of a preallocation
is dynamic and depends on the size of the previous extent in the file
(starting from 0 again if the write extends past a hole). As files grow
larger, so do the size of preallocations. Speculative preallocation is
not enabled for files smaller than a minimum size (64k by default, but
can vary depending on filesystem geometry and/or mount options).
Preallocations are capped at a maximum of 8GB on 4k block filesystems.
Preallocation is throttled automatically as the filesystem approaches
low free space conditions or other allocation limits on a file (such as
a quota).
 
In most cases, speculative preallocation is automatically reclaimed when
a file is closed. The preallocation may persist after file close if an
open, write, close pattern is repeated on a file. In this scenario,
post-EOF preallocation is trimmed once the inode is reclaimed from cache
or the filesystem unmounted.

Linux 3.8 (and later) includes a scanner to perform background trimming
of files with lingering post-EOF preallocations. The scanner bypasses
files that have been recently modified to not interfere with ongoing
writes. A 5 minute scan interval is used by default and can be adjusted
via the following file (value in seconds):

	/proc/sys/fs/xfs/speculative_prealloc_lifetime

Although speculative preallocation can lead to reports of excess space
usage, the preallocated space is not permanent unless explicitly made so
via fallocate or a similar interface. Preallocated space can also be
encoded permanently in situations where file size is extended beyond a
range of post-EOF blocks (i.e., via truncate). Otherwise, preallocated
blocks are reclaimed on file close, inode reclaim, unmount or in the
background once file write activity subsides.

Finally, the XFS block allocation algorithm can be configured to use a
fixed allocation size with the 'allocsize=' mount option. Note that
speculative preallocation does not occur when a fixed allocation size is
set and thus increases the potential for fragmentation via parallel
writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
