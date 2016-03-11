Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 212797CA3
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:07:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96540AC001
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:07:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QWEgAQYaMc9LPZkR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:07:51 -0800 (PST)
Date: Fri, 11 Mar 2016 06:07:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 11/22] vfs: Cache base_acl objects in inodes
Message-ID: <20160311140746.GC14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-12-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456733847-17982-12-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, chao2.yu@samsung.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Feb 29, 2016 at 09:17:16AM +0100, Andreas Gruenbacher wrote:
> POSIX ACLs and richacls are both objects allocated by kmalloc() with a
> reference count which are freed by kfree_rcu().  An inode can either
> cache an access and a default POSIX ACL, or a richacl (richacls do not
> have default acls).  To allow an inode to cache either of the two kinds
> of acls, introduce a new base_acl type and convert i_acl and
> i_default_acl to that type. In most cases, the vfs then doesn't care which
> kind of acl an inode caches (if any).

This base_acl object is pointless.  I've asked in the past to have
a proper container for the ACLs in common code, but a union
of a refcount and a rcu head doesn't really fit that category.

But this points out that the f2fs folks really need a couple of
slaps on their hands.  Not if generic funtionality doesn't
fit your needs you are not going to blindly copy and paste it,
please talk to find a solution instead of duplicating it.

Folks, please come up with a suggestion to get rid of f2fs_acl_clone,
f2fs_acl_create_masq and f2fs_acl_create ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
