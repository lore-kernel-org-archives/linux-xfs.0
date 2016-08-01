Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78F387CED
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:39:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49101304048
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:39:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zp7oQzQhguJFhMqQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:39:05 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:39:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/47] xfs: add function pointers for get/update keys to
	the btree
Message-ID: <20160801063902.GI15590@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:46PM -0700, Darrick J. Wong wrote:
> Add some function pointers to bc_ops to get the btree keys for
> leaf and node blocks, and to update parent keys of a block.
> Convert the _btree_updkey calls to use our new pointer, and
> modify the tree shape changing code to call the appropriate
> get_*_keys pointer instead of _btree_copy_keys because the
> overlapping btree has to calculate high key values.

I don't really like to add ops for something that isn't really
per-btree type.  Can you just add an overlapping flag and act based on
that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
