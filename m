Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C2AB7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 19:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FF5A8F8033
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:47:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3XIaAqbX7aW1gfGS for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 17:47:49 -0700 (PDT)
Date: Thu, 4 Aug 2016 10:47:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160804004747.GZ16044@dastard>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
	<20160801065410.GA341@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801065410.GA341@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 08:54:10AM +0200, Felix Janda wrote:
> Christoph Hellwig wrote:
> > On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> > > int64_t is guaranteed to have the correct size and signedness and is
> > > always avaible because linux.h has a <inttypes.h> include.
> > > 
> > > Fixes compilation error "unkown type name 'off64_t'" on linux when the
> > > public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> > > _GNU_SOURCE defined. This bug was introduced in commit
> > > cb898f157f8410a03cf5f3400baa1df9e5eecd33.
> > 
> > I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..
> 
> Thanks for the suggestion, but that does not work if the system header
> defining (or not) off64_t is included before the xfs headers.

Which, to me, is a build bug in whatever code is including the xfs
headers.  Isn't it the responsibility of the build environment to
ensure the dependencies of the libraries being used are correctly
met?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
