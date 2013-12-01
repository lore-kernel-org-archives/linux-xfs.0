Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D4397F5D
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B227AC006
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id oWAyXNZj98MOluDk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:07 -0800 (PST)
Message-Id: <20131201115903.910559036@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/18] Consolidate Posix ACL implementation
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org


This series consolidates the various cut'n'pasted Posix ACL implementations
into a single common one based on the ->get_acl method Linus added a while
ago and a new ->set_acl counterpart.

This 1600 lines of code and provides a single place to implement various
nasty little gems of the semantics.

Unfortunately the 9p code is still left out - it implements the ACLs
in two very weird ways, one using the common code but on the client only,
and one pasing things straight through to the server.  We could easily
convert it to the new code on the write side if ->set_acl took a dentry,
but there's no cance to do that on the ->get_acl side.  Ideas how to
handle it welcome.

After that we'd be ready to never go into the fs for the ACL attributes
and branch straight to the ACL code below the syscall, repairing the
old API braindamage of overloading ACLs onto the xattrs.

Btw, I'd be almost tempted to do that for all system.* attrs.  Besides
Posix ACLs we only have CIFS and NFSv4 ACL variants, weird advice crap
in f2fs, and the magic mushroom proto name on sockets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
