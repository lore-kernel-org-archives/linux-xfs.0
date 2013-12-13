Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E7207F6F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:59:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EC86304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:58:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id oFHN0y7n7jWafqVt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:58:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VrRMK-0008W2-TO
	for xfs@oss.sgi.com; Fri, 13 Dec 2013 11:56:44 +0000
Date: Fri, 13 Dec 2013 03:56:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: xattr atomicy
Message-ID: <20131213115644.GA28551@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

On the nfsv4 list it was recently discussed how atomic / transaction
xattr updates are.  It turns out none of that seems documented on the
syscall level, but for XFS we have an odd inconsistancy in that attr
updates generally are atomic and logged, except when we go out to
remote attributes in xfs_attr_rmtval_set, in which case attr updates
are no logged, and we do synchronous writes instead.

Besides the weird semantic difference that is impossible to explain to
users performance will also generally be bad with a synchronous buffer
write.  Is there any good reason to not log the buffer for the remote
attributes? Given that attribute are limited to 64kB it's not like
the value is larger than large directory blocks that we already
support.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
