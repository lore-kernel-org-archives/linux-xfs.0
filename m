Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DF027CA0
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 12:04:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6BCAAC001
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 10:04:33 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id kXsGWpD804TEdj1Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 10:04:31 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 233132008F
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 19:04:30 +0200 (CEST)
Date: Fri, 12 Aug 2016 19:03:36 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 11/14] replace statvfs64 by equivalent statvfs
Message-ID: <20160812170336.GB367@nyan>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
	<20160809074010.GM25647@infradead.org> <20160809174158.GA4476@nyan>
	<20160812025703.GC10701@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812025703.GC10701@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Aug 09, 2016 at 07:41:58PM +0200, Felix Janda wrote:
> > This patch removes the usage of statvfs64 and thus one of the problems
> > for Mac OS X. The other problem is solved by giving a suitable
> > definition of f_brsize. Note that this might collide with other uses
> > of f_brsize (if they exist). It might be cleaner to just check for Mac
> > OS X in xfs_fsr.c.
> 
> Yes, that's probably better.  Or simply not build fsr on MacOS given
> that there is no kernel XFS support anyway..

That second option sounds interesting. If fsr was not built on Mac OS X,
then commit 7141fc5b04905e (add *mntent abstraction) can basically be
reverted, simplifying the platform headers a bit.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
