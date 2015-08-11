Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C1CA7F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:49:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1E99AC003
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:49:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QdNUm8JOpejF2WpN for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMg-0005YD-VN
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMg-0004OM-Uh
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/8] xfs: get rid of xfs_cluster_write()
Date: Wed, 12 Aug 2015 08:49:40 +1000
Message-Id: <1439333388-16452-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This patchset is the first small step to removing bufferheads from
the ->writepage path. The first step to doing this is to simplify
the ->writepage path such that we only look up pages once in the
radix tree for writeback. This means we only operate on a single page at
a time, but a simple conversion loses the mapping efficiency that
xfs_cluster_write() gives us.

To do this without losing any efficiency we need to retain the
active bmbt mapping and ioend chains we build across multiple calls
to ->writepage. In general, those multiple sequential page calls
come from ->writepages, so we can create a context structure at
xfs_vm_writepages() and pass that all the way through to every
xfs_vm_writepage() call that occurs from a single writepages
context. This allows us to cache the current bmbt mapping as well as
keep the ioend chain connected and not have to continually remap the
same extent or submit page sized bios and rely on block layer
merging to build large IOs.

This patch series introduces the struct xfs_writepage_context to act
as the holding container for this state, converts the code to use it
and removes xfs_cluster_write() as it is no longer needed to
efficiently build large IOs. Indeed, the new code is more efficient
than the existing code as it does not have arbitrary write clustering
limits, and it only does one radix tree lookup per page instead of
two. Hence the new code has less CPU overhead, builds larger IOs
where appropriate and removes more code than it adds.

The last patch of the series (patch 8) is not really a patch - I've
included it as information/documentation for the next series of
changes that will follow this series that begin one the path of
removing bufferheads - mapping pages direct to bios and chaining
bios to ioends rather than using bufferheads for this purpose. Once
the writepage path is not dependent on bufferheads, we can move to
working on the VFS read/write paths that use bufferheads. This will
be based on the multipage-write pages that have been floating around
for years to - again - map pages directly and operate on them
according to the mapping state rather than bufferhead state.
This needs to be done to make the COW operations for reflink sane,
so that's what is driving this patchset even if it doesn't appear to
be connected yet.

Comments, flames, thoughts and testing appreciated!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
