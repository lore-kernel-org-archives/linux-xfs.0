Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LHbtCV167471 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:37:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8799A16428CD
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:41:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5mGX1uHCLepOSXSf for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 10:41:23 -0700 (PDT)
Date: Thu, 21 Apr 2011 13:41:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Message-ID: <20110421174120.GA7267@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303407205-sup-6141@think>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
> Sorry, this doesn't do it.  I think that given what a strange special
> case this is, we're best off waiting for the IO-less throttling, and
> maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
> maybe not, it has to get written eventually either way.

I'm not sure what you mean with seek aware.  XFS only clusters
additional pages that are in the same extent, and in fact only does
so for asynchrononous writeback.  Not sure how this should be more
seek aware.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
