Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4C6A7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 05:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8949B8F8040
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 03:26:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6X3kE345FpSJzJ3Z for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 03:26:55 -0700 (PDT)
Date: Wed, 16 Oct 2013 21:26:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131016102651.GF4446@dastard>
References: <20131005005210.GA25773@redhat.com> <20131005031918.GL4446@dastard>
	<20131015201905.GA7509@infradead.org>
	<20131015213618.GU4446@dastard>
	<20131016070528.GB18721@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016070528.GB18721@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 12:05:28AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2013 at 08:36:18AM +1100, Dave Chinner wrote:
> > Sure, but file_remove_suid() doesn't actually modify any VFS inode
> > structures until we process the flags and the modifications within
> > ->setattr, which in XFS are all done under the XFS_ILOCK_EXCL via
> > xfs_setattr_mode(). i.e. both the VFS and XFS inodes S*ID bits are
> > removed only under XFS_ILOCK_EXCL....
> 
> It can set S_NOSEC after calling into ->setattr at least.
> 
> > Hence I see no point in adding extra serialisation via the i_mutex
> > to this path when we can just do something like:
> > 
> > 	killsuid = should_remove_suid(file->f_path.dentry);
> > 	if (killsuid) {
> > 		struct iattr	newattr;
> > 
> > 		newattr.ia_valid = ATTR_FORCE | killsuid;
> > 		error = xfs_setattr_nonsize(ip, &newattr, 0);
> > 		if (error)
> > 			return error;
> > 	}
> 
> We'd still need all the other magic in file_remove_suid, which I don't
> actually quite undersdtand fully yet.

The killpriv calls? I couldn't find anything that implemented those
security hooks nor any documentation about it, so I'm pretty much
clueless about it. FWIW, ocfs2 doesn't implement them, either....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
