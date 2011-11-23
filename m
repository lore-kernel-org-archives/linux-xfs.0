Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANDFBaX215877
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 07:15:15 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 914774F8CF0
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 05:15:09 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id wtFCr92acK21YxJS for <linux-xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 05:15:09 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RTCfJ-0007wn-79
	for linux-xfs@oss.sgi.com; Wed, 23 Nov 2011 14:15:05 +0100
Received: from 202.96.96.18 ([202.96.96.18])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 14:15:05 +0100
Received: from ygq51 by 202.96.96.18 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 23 Nov 2011 14:15:05 +0100
From: Guoquan Yang <ygq51@hotmail.com>
Subject: Re: xfs: validate inode numbers in file handles correctly
Date: Wed, 23 Nov 2011 13:04:58 +0000 (UTC)
Message-ID: <loom.20111123T134243-580@post.gmane.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@oss.sgi.com

Dave Chinner <david <at> fromorbit.com> writes:

> 
> This series closes a recently discovered problem in XFS filehandle 
conversion.
> On systems where inodes are dynamically deleted, XFS does not adequately 
verify
> the inode numbers in the filehandles, which results in reading stale inodes
> from disk and potentially returning them as valid files. Because these 
unlinked
> inodes were never zeroed out when the chunk was deallocated, some inodes in 
the
> chunk can still appear to have to data extents attached to them. This can 
lead
> to stale data exposure, exposure of active data and potentially overwriting 
of
> active data if the stale extents referenced in the unlinked inodes have been
> re-allocated.
> 
> Both NFS filehandles and local filehandles provided through libhandle have 
this
> same problem. libhandle requires root permissions to use the interface, so it
> is not exposing information that you can't get more easily with other means
> (e.g. xfs_db or reading directly form the block device), so there isn't 
really
> an issue here.
> 
> For NFS, we may incorrectly accept stale file handles for unlinked inodes 
after
> a server reboot if the unlinked inodes have not been overwritten leading to 
the
> above issues being triggered if multiple NFS clients are accessing the some
> files.
> 
> Christoph's make-bulkstat-coherent patch is the basis for this series as
> bulkstat can also expose unlinked inodes and information about them back to
> userspace because it makes the same assumptions about inode lookups as the 
file
> handle interfaces.
> 
> As a result, the first two patches of the series make up the real bug fix. 
The
> last two patches make it clear we are looking up untrusted inode numbers and
> remove a shortcut that these interfaces used that we do not want used any
> more. Hence for backports to other kernels, only the first two patches are
> necessary.
> 
> More information and the test program that demonstrates the issue via the
> open_by_handle interface can be found here:
> 
> http://oss.sgi.com/archives/xfs/2010-06/msg00191.html
> 
> _______________________________________________
> xfs mailing list
> xfs <at> oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

I meet with a problem when using 64bit XFS and NFS,

When I access a directory from the NFS client,I get Stale NFS file Handle 
error.But it is ok when accessing on the server without NFS.

And I have checked that the inode num in the NFS file handle is the same as 
inode num on the server, Using ls -il.

I found that XFS_IGET_UNTRUSTED in xfs_imap() filtered the function 
xfs_imap_lookup(),It fails in xfs_imap_lookup() when access from NFS 
client.local access does not go into xfs_imap_lookup().

My kernel is Linux2.6.35.6 from kernel.org. please help me to find out this 
problem!

Thanks!



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
