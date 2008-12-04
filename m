Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB40EB7s002753 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 18:14:11 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EE45AC011
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 16:14:07 -0800 (PST)
Date: Wed, 3 Dec 2008 18:19:40 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 0/9] CRC support for superblock, ag headers, log and
	btree blocks
Message-ID: <20081204001940.GB2804@sgi.com>
References: <20080925225613.GA9822@lst.de> <20081201231005.GA17631@sgi.com>
	<20081203104409.GA15485@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203104409.GA15485@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@sgi.com

On Wed, Dec 03, 2008 at 05:44:09AM -0500, Christoph Hellwig wrote:
| On Mon, Dec 01, 2008 at 05:10:05PM -0600, Bill O'Donnell wrote:
| > On Fri, Sep 26, 2008 at 12:56:13AM +0200, Christoph Hellwig wrote:
| > | Here's an updated crc series for various metadata structures.  We're still
| > | looking at the magic number in the log recovery case because getting down
| > | a buffer type for the other structures wasn't quite as easy as for the
| > | btree block.  I'll probably look into that again once we're done with all
| > | data structures.
| > 
| > Just to be clear, crc only applies to the metadata structures listed in the
| > subject line, correct?  It wasn't clear to me where you were with the "other
| > structures".  Maybe it would be more clear if you could provide a simple
| > table listing the structures and whether or not crc applies (yet).
| 
| The patchset sent applies to
| 
| sb
| agi
| agf
| btree_block
| log buffer
| 
| next patchset later this week will add the inode

OK, thanks Christoph-
I'll look for it later in the week.
BTW, there seems to be some aliasing issue with xfs-oss list
at least with my mailer. I dunno, but its converting  
xfs@oss.sgi.com into xfs@sgi.com.  The upshot is that although you 
cc'd the list in your replies to my posts, those replies aren't
getting posted.
Cheers-
Bill


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
