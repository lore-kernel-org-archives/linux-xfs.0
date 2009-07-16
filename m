Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GJKLe1032821 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 14:20:21 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21A9A36A3A1
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 12:21:00 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id tuJzlIKqAUYhxg2I for <xfs@oss.sgi.com>;
	Thu, 16 Jul 2009 12:21:00 -0700 (PDT)
Message-ID: <4A5F7D99.4010503@sandeen.net>
Date: Thu, 16 Jul 2009 14:20:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: File system corruption
References: <4A5F6C8C.609@jquigley.com>
In-Reply-To: <4A5F6C8C.609@jquigley.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

John Quigley wrote:
> Hey Folks:
> 
> I'm periodically encountering an issue with XFS that you might perhaps be interested in.  The environment in which this manifests itself is on a CentOS Linux machine (custom 2.6.28.7 kernel), which is serving the XFS mount point in question with the standard Linux nfsd.  The XFS file system lives on an LVM device in a striping configuration (2 wide stripe), with two iSCSI volumes acting as the constituent physical volumes.  This configuration is somewhat baroque, I know.
> 
> I'm experiencing periodic file system corruption, which manifests in the XFS file system going offline, and refusing subsequent mounts.  The only way to recover from this has been to perform a xfs_repair -L, which has resulted in data loss on each occasion, as expected.

The log corruption might be related to data reordering somewhere along
your IO path, though I wouldn't swear to it.  But often when write
caches are on, barriers are off, and power is lost, this sort of thing
shows up.

> Now, here's what I witness in the system logs:
> 
> <snip>
> kernel: XFS: bad magic number
> kernel: XFS: SB validate failed

That's the first error?

> kernel: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> kernel: Filesystem "dm-0": XFS internal error xfs_ialloc_read_agi at line 1408 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8118711a

This means that after you read an agi, it failed a sanity test:

1403                 be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
1404                 XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));

bad magic number, etc.  The "00 00 00 00 ..." is the contents of the
buffer that it thought was the agi, containing all that wonderful magic
- but it's all 0s.

...

> The resultant stack trace coming from "XFS internal error xfs_ialloc_read_agi" repeats itself numerous times, at which point, the following is seen:
> 
> <snip>
> 
> kernel: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> kernel: Filesystem "dm-0": XFS internal error xfs_alloc_read_agf at line 2194 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8115cf09

Similar, but bad info on the AGF:
2184         agf_ok =
2185                 be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
2186
XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
2187                 be32_to_cpu(agf->agf_freeblks) <=
be32_to_cpu(agf->agf_length) &&
2188                 be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
2189                 be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
2190                 be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);

Again w/ the zeros ...

> 
> kernel: Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811a9411

...

and then the fs tried to back out of a dirty transaction, which it can't
do, but that's secondary.

> kernel: xfs_force_shutdown(dm-0,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811a348e
> kernel: Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down filesystem: dm-0
> kernel: Please umount the filesystem, and rectify the problem(s)
> kernel: nfsd: non-standard errno: -117

117 EFSCORRUPTED IIRC?

> kernel: Filesystem "dm-0": xfs_log_force: error 5 returned.

EIO

> </snip>
> 
> I'm somewhat at a loss with this one - it's been experienced on a customer's installation, so I don't have ready access to the machine.  All internal tests to attempt reproduction with identical hardware/software configurations has been unfruitful.  I'm concerned about the custom kernel, and may attempt to downgrade to the stock CentOS 5.3 kernel (2.6.18, if I remember correctly).
> 
> Any insight would be hugely appreciated, and of course tell me how I can help further.  Thanks so much.

I'm happy to blame the storage here, given the buffers full of 0s ...
you could modify the messages to print the block nrs in question and go
back directly to the storage, read it, and see what's there.

Were there no iscsi or other assorted messages before all this?

-Eric

> John Quigley
> jquigley.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
