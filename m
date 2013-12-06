Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 822487F50
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 13:46:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BAF28F8064
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:46:54 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kpg0z5AB01C0eMVm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 11:46:53 -0800 (PST)
Date: Fri, 6 Dec 2013 11:46:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/18] Consolidate Posix ACL implementation
Message-ID: <20131206194637.GA32122@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
	<279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Thu, Dec 05, 2013 at 06:57:14PM +0100, Andreas Gruenbacher wrote:
> I see that get_acl and set_acl are being defined in some but not all symlink inode operations (for example, btrfs them while ext4 does not), and that posix_acl_xattr_set() doesn't check if set_acl is defined.  Symlinks cannot have ACLs, so set_acl should either never be defined for symlinks (and a NULL check is then needed in posix_acl_xattr_set()), or it is defined in all inode operations, and S_ISNLNK() check is needed in posix_acl_xattr_set().  That latter check should probably be added in any case to be on the safe side.

Yes, we should add the check.  We also in general should not have
set_acl/get_acl on links and I'll look over it.

> Patch 6 also declares posix_acl_prepare() but this function is never introduced; this must be a leftover from a previous version.

Indeed.

Thanks for the review!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
