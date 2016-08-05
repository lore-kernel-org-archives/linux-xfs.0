Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDAF17CA1
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 03:03:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FE53AC004
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 01:03:27 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id XEU784HUNF0YeQOF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 01:03:19 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 2E1CB20453
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 10:03:14 +0200 (CEST)
Date: Fri, 5 Aug 2016 10:02:41 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160805080241.GA749@nyan>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
	<20160801065410.GA341@nyan> <20160804004747.GZ16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804004747.GZ16044@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Mon, Aug 01, 2016 at 08:54:10AM +0200, Felix Janda wrote:
> > Christoph Hellwig wrote:
> > > On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> > > > int64_t is guaranteed to have the correct size and signedness and is
> > > > always avaible because linux.h has a <inttypes.h> include.
> > > > 
> > > > Fixes compilation error "unkown type name 'off64_t'" on linux when the
> > > > public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> > > > _GNU_SOURCE defined. This bug was introduced in commit
> > > > cb898f157f8410a03cf5f3400baa1df9e5eecd33.
> > > 
> > > I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..
> > 
> > Thanks for the suggestion, but that does not work if the system header
> > defining (or not) off64_t is included before the xfs headers.
> 
> Which, to me, is a build bug in whatever code is including the xfs
> headers.  Isn't it the responsibility of the build environment to
> ensure the dependencies of the libraries being used are correctly
> met?

Every program using the xfs header is supposed to know that (only on
linux) since commit cb898f157f8410a03cf5f3400baa1df9e5eecd33 it is
necessary to define _LARGEFILE64_SOURCE or _GNU_SOURCE?

In commit

f96aff0c250ae8c70f50d5becb592723eb064f5d

something very similar was done.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
