Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B97F29E17
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:32:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6268AC001
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 10:32:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id qsH0FDLzLC5cCzWn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 10:32:24 -0800 (PST)
Date: Tue, 12 Nov 2013 10:32:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131112183224.GA12213@infradead.org>
References: <20131107204635.GA22954@infradead.org>
	<52827113.3080609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52827113.3080609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 12, 2013 at 12:18:59PM -0600, Eric Sandeen wrote:
> On 11/7/13, 2:46 PM, Christoph Hellwig wrote:
> > For historical reasons beyond my knowledge xfstests tries to abuse the
> > scratch device as test device for nfs and udf.  Because not all test
> > have inherited the right usage of the _setup_testdir and _cleanup_testdir
> > helpers this leads to lots of unessecary test failures.
> > 
> > Remove the special casing, which gets nfs down to a minimal number of
> > failures.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Oof, that was a lot of cruft.  Were you able to run UDF tests with
> these changes?  I wonder if Jan is using this for UDF?

I didn't bother testing udf, but it's just another block based
filesystem, so unlike NFS I didn't expect breakage.  Let me give it a
spin..

> (I don't have the UDF verifier that many(/all?) of the UDF tests
> require).

Last time I did run xfstests on UDF it wasn't required, just an
additional tool to verify the fs consistency.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
