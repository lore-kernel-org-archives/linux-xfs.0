Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E78C7F6C
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 03:08:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD2BDAC002
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 01:08:43 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nGPingDevKKW3Jzz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 01:08:41 -0800 (PST)
Date: Fri, 13 Nov 2015 01:08:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: create helper for bmap finish & trans join in
	attr code
Message-ID: <20151113090840.GA16423@infradead.org>
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
	<20151112165801.GA14854@infradead.org>
	<20151112201231.GS19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151112201231.GS19199@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Nov 13, 2015 at 07:12:31AM +1100, Dave Chinner wrote:
> On Thu, Nov 12, 2015 at 08:58:01AM -0800, Christoph Hellwig wrote:
> > I think the problem here is simply that our interfaces suck.
> > xfs_trans_roll really needs to rejoin any inode to the new transaction
> > to that was joined to the previous one.  Once we've fixed that we can
> > get rid of the silly committed arguments and everyone will be happy.
> 
> xfs_trans_roll is not specifically for rolling transactions with
> locked inodes in them. We could use it for any object that needs
> multiple transactions to modify. e.g. we could roll transactions
> across an AGF (using hold+join) so that it remains locked across
> multiple allocation/free transactions.

xfs_trans_roll already logs the inode core, which requires the
inode to be attached to the transaction.  While I could see the
point of moving this out of the core __xfs_trans_roll into an
xfs_trans_roll_inode helper we might as well follow the current
interface for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
