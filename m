Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1NlnqW030400 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 17:47:49 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA9778F8047
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 15:47:48 -0800 (PST)
Date: Mon, 1 Dec 2008 17:53:18 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 0/9] CRC support for superblock, ag headers, log and
	btree blocks
Message-ID: <20081201235318.GC5094@sgi.com>
References: <20080925225613.GA9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225613.GA9822@lst.de>
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

On Fri, Sep 26, 2008 at 12:56:13AM +0200, Christoph Hellwig wrote:
| Here's an updated crc series for various metadata structures.  We're still
| looking at the magic number in the log recovery case because getting down
| a buffer type for the other structures wasn't quite as easy as for the
| btree block.  I'll probably look into that again once we're done with all
| data structures.

I've carried out cursory build and test of this series.  I'm concerned that
my testing (and anyone else's testing) has not addressed performance hits 
being introduced with crc on metadata.  What level of testing have you done,
and can you recommend some testing that goes beyond the QA suite that we
have in place.  I did run the btree test harness on that earlier series, but it
appeared to me that that was a go/no-go test and unless I'm missing something,
I've not seen tests that might help quantify performance hits.



Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
