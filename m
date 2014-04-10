Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E269E7F9A
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:24:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9D49304043
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 03:24:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wonmCe7pYtNkd9Bv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 03:24:21 -0700 (PDT)
Date: Thu, 10 Apr 2014 03:24:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140410102421.GA17641@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397071311-28371-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 09, 2014 at 03:21:50PM -0400, Brian Foster wrote:
> xfs_vn_tmpfile() also fails to initialize security or default acls on
> the newly created inode.

Which it doesn't have to, as it is never available in the filesystem
namespace.

> The d_tmpfile() call is removed from xfs_create_tmpfile() and pulled up
> into the new handler to address the deadlock. E.g., xfs_create_tmpfile()
> has committed the create transaction and unlocked the inode prior to
> mapping the inode to the dentry.

This part of the patch looks sane, although the window where the XFS
inode and VFS inode i_nlink are out of sync worries me a little.

I don't think the other refactoring belongs into the same patch.

If we decide that we want it please avoid the useless ACL inheritance
for tmpfiles.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
