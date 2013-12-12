Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 544A429E1D
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:08:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3EC5130406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:08:40 -0800 (PST)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id rDbi27fQMsh1aohQ for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:08:39 -0800 (PST)
Date: Thu, 12 Dec 2013 20:08:38 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <966512490.69128.1386875318581.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131211104529.142731540@bombadil.infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104529.142731540@bombadil.infradead.org>
Subject: Re: [PATCH 16/18] gfs2: use generic posix ACL infrastructure
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

gfs2 has a left-over get_acl callback in gfs2_symlink_iops in
fs/gfs2/inode.c, from a long time ago, which should be removed
as well.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
