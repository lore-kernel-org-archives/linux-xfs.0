Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5ALJFbj011242 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:19:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6C66D9CF87
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:19:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zNbGHeS2GR9bpnnz for <xfs@oss.sgi.com>;
	Fri, 10 Jun 2011 14:19:12 -0700 (PDT)
Date: Fri, 10 Jun 2011 17:19:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Failure of xfstests test case 202
Message-ID: <20110610211911.GA11509@infradead.org>
References: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Jun 10, 2011 at 01:39:47PM -0700, Chandra Seetharaman wrote:
> Hi all,
> 
> Test case 202 tries to create a single AG filesystem and runs xfs_repair
> on it expecting it to fail.
> 
> But, when I run the test with a filesystem that is bigger than 1TB it
> fails (not pleasantly) since the max AG size is 1TB.
> 
> I am thinking of the following solution, please let me know if there is
> any other elegant fix.

What about:

#
# The AG size is limited to 1TB (or even less with historic xfsprogs),
# so chose a small enough filesystem to make sure we can actually create
# a single AG filesystem.
#
_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024`

instead?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
