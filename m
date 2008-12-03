Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB31NWIO001916 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 19:23:33 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D035CAC002
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 17:23:28 -0800 (PST)
Date: Tue, 2 Dec 2008 19:28:59 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 5/9] add support for large btree blocks with CRCs and
	additional RAS information
Message-ID: <20081203012859.GA16811@sgi.com>
References: <20080925225633.GF9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225633.GF9822@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

On Fri, Sep 26, 2008 at 12:56:33AM +0200, Christoph Hellwig wrote:
| Add support for larger btree blocks that contains a CRC32C checksum, a
| filesystem uuid and block number for detecting filesystem consistency
| and out of place writes.  The use of these blocks is triggered by the
| crc superblock patches just added.
| 
| Note that we currently do not log the crc of the block, but re-created
| it during log recovery.  With the pending patch to also checksum the log
| this should be safe against filesystem corruption but doesn't really
| follow the end to end argument.  Also poking into the buffer to find
| out whether this is a btree buffer during log recovery is not a very
| clean way to implement this.  I'll look into how well adding crcs
| to the buffer log items for every btree is going to work and hope
| I can switch to that variant for the next version.

looks good... will need to put this through the QA wringer.


-- 
Bill O'Donnell
SGI
billodo@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
