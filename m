Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A47E67F3F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:32:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82B47304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:32:27 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id Iov2NSt5H6K6oyyZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:32:25 -0800 (PST)
Date: Tue, 6 Jan 2015 12:32:22 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: a simple and scalable pNFS block layout server
Message-ID: <20150106173222.GF12067@fieldses.org>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:23PM +0100, Christoph Hellwig wrote:
> This series adds support for the pNFS operations in NFS v4.1, as well
> as a block layout driver that can export block based filesystems that
> implement a few additional export operations.  Support for XFS is
> provided in this series, but other filesystems could be added easily.
> 
> The core pNFS code of course owns its heritage to the existing Linux
> pNFS server prototype, but except for a few bits and pieces in the
> XDR path nothing is left from it.
> 
> The design of this new pNFS server is fairly different from the old
> one - while the old one implemented very little semantics in nfsd
> and left almost everything to filesystems my implementation implements
> as much as possible in common nfsd code, then dispatches to a layout
> driver that still is part of nfsd and only then calls into the
> filesystem, thus keeping it free from intimate pNFS knowledge.
> 
> More details are document in the individual patch descriptions and
> code comments.
> 
> This code is also available from:
> 
> 	git://git.infradead.org/users/hch/pnfs.git pnfsd-for-3.20

Neat, thanks!  I'll look at it.

Some naive questions:

	- do we have evidence that this is useful in its current form?

	- any advice on testing?  Is there was some simple virtual setup
	  that would allow any loser with no special hardware (e.g., me)
	  to check whether they've broken the block server?

	- any debugging advice?  E.g., have you checked if current
	  wireshark can handle the MDS traffic?

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
