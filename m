Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CG3upY082459 for <xfs@oss.sgi.com>; Tue, 12 May 2009 11:03:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB5791D296BF
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 09:04:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id u0VroArNUoC8pgJE for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 09:04:03 -0700 (PDT)
Date: Tue, 12 May 2009 12:04:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: migration to selinux + xfs_fsr oddity....
Message-ID: <20090512160403.GB28714@infradead.org>
References: <49FF9B8E.7040607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49FF9B8E.7040607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, May 04, 2009 at 08:51:10PM -0500, Eric Sandeen wrote:
> This came up in RH Bugzilla #498860, "xfs_fsr fails to complete"
>
> The reporter had an existing xfs filesystem from another Linux OS, and
> was using it under Fedora now.  He had some files for which xfs_fsr
> bails out with EINVAL:
> 
> XFS_IOC_SWAPEXT failed: fragfile: Invalid argument

As analyzed in the bugzilla this is a problem when selinux attributes
are created underneath due to selinux.

Either we relax the attribute fork check an allow the new inode to have
an attribute fork despite the old one not having one, or we need to
create a fake xattr on the file to be defragmented.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
