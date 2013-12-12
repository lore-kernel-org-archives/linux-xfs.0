Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2424C7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:05:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 137998F8064
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:05:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2lbBOQuVvphf2IbM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 13:05:38 -0800 (PST)
Date: Thu, 12 Dec 2013 13:05:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/18] gfs2: use generic posix ACL infrastructure
Message-ID: <20131212210531.GC27686@infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104529.142731540@bombadil.infradead.org>
	<966512490.69128.1386875318581.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <966512490.69128.1386875318581.JavaMail.zimbra@linbit.com>
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

On Thu, Dec 12, 2013 at 08:08:38PM +0100, Andreas Gruenbacher wrote:
> Christoph,
> 
> gfs2 has a left-over get_acl callback in gfs2_symlink_iops in
> fs/gfs2/inode.c, from a long time ago, which should be removed
> as well.

Ok, will fix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
