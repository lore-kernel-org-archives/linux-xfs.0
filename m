Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0996A7F5D
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 04:49:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8B4B8F804C
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 02:49:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id OEyyFww7oTK966zD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 02:49:11 -0800 (PST)
Date: Tue, 3 Dec 2013 02:48:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/18] ocfs2: use generic posix ACL infrastructure
Message-ID: <20131203104854.GA3223@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120655.852590677@bombadil.infradead.org>
	<20131202230007.GK12253@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202230007.GK12253@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Tue, Dec 03, 2013 at 12:00:07AM +0100, Jan Kara wrote:
>   Hum, this changes the cluster locking. Previously ocfs2_acl_get() used
> from ocfs2_acl_chmod() grabbed cluster wide inode lock. Now getting of ACL
> isn't protected by the inode lock. That being said the cluster locking
> around setattr looks fishy anyway - if two processes on different
> nodes are changing attributes of the same file, changing ACLs post fact
> after dropping inode lock could cause interesting effects. Also I'm
> wondering how inode_change_ok() can ever be safe without holding inode
> lock... Until we grab that other node is free to change e.g. owner of the
> inode thus leading even to security implications. But maybe I'm missing
> something. Mark, Joel?

Hmm, indeed.  How does ocfs2_iop_get_acl get away without that lock?

Btw, ocfs2 changes will need careful testing as I couldn't find any easy
way to run xfstests on ocfs2 out of the box.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
