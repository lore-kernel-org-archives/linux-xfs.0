Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 244CD7F56
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 11:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4764AC005
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:57:19 -0800 (PST)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id AycaErpqsOf4CNpT for
	<xfs@oss.sgi.com>; Thu, 05 Dec 2013 09:57:18 -0800 (PST)
Date: Thu, 5 Dec 2013 18:57:14 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131201115903.910559036@bombadil.infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
Subject: Re: [PATCH 00/18] Consolidate Posix ACL implementation
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

Christoph,

nice work, and a pretty diffstat.

I see that get_acl and set_acl are being defined in some but not all symlink inode operations (for example, btrfs them while ext4 does not), and that posix_acl_xattr_set() doesn't check if set_acl is defined.  Symlinks cannot have ACLs, so set_acl should either never be defined for symlinks (and a NULL check is then needed in posix_acl_xattr_set()), or it is defined in all inode operations, and S_ISNLNK() check is needed in posix_acl_xattr_set().  That latter check should probably be added in any case to be on the safe side.

  Test case:

  setfattr -h -n system.posix_acl_access \
           -v 0sAgAAAAEABgD/////AgAGABMEAAAEAAYA/////xAABgD/////IAAEAP////8= \
           symlink

Patch 6 also declares posix_acl_prepare() but this function is never introduced; this must be a leftover from a previous version.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
