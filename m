Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C3257F87
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:31:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E551304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:31:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fn6ib3aBgmt8HN5m for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:31:04 -0700 (PDT)
Date: Thu, 10 Apr 2014 08:19:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140410121947.GA14124@bfoster.bfoster>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410102421.GA17641@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 03:24:21AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 09, 2014 at 03:21:50PM -0400, Brian Foster wrote:
> > xfs_vn_tmpfile() also fails to initialize security or default acls on
> > the newly created inode.
> 
> Which it doesn't have to, as it is never available in the filesystem
> namespace.
> 

Are you saying it doesn't have to initialize security or the default
acl, or both?

The intent here was to have the case covered where the inode happens to
be linked back into the namespace since we don't do this work in the
link path.

> > The d_tmpfile() call is removed from xfs_create_tmpfile() and pulled up
> > into the new handler to address the deadlock. E.g., xfs_create_tmpfile()
> > has committed the create transaction and unlocked the inode prior to
> > mapping the inode to the dentry.
> 
> This part of the patch looks sane, although the window where the XFS
> inode and VFS inode i_nlink are out of sync worries me a little.
> 
> I don't think the other refactoring belongs into the same patch.
> 
> If we decide that we want it please avoid the useless ACL inheritance
> for tmpfiles.

The bulk of the refactoring was with the idea that the inode setup for
the tmpfile case is generally equivalent for the traditional create
case. The original version was posted here:

http://oss.sgi.com/archives/xfs/2014-04/msg00149.html

... and it just fixes the deadlock and adds the security initialization.
I suppose I could still break that out into multiple patches, but that
aside, is that behavior preferred?

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
