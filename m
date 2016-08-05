Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E994D7CBE
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 17:44:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A92378F804B
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 15:44:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kBZLfvwbM6mXpSfZ for <xfs@oss.sgi.com>;
	Fri, 05 Aug 2016 15:44:40 -0700 (PDT)
Date: Sat, 6 Aug 2016 08:44:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160805224439.GM16044@dastard>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
	<20160801065410.GA341@nyan> <20160804004747.GZ16044@dastard>
	<20160805080241.GA749@nyan> <20160805115239.GH16044@dastard>
	<20160805130905.GA321@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805130905.GA321@nyan>
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

On Fri, Aug 05, 2016 at 03:09:05PM +0200, Felix Janda wrote:
> Dave Chinner wrote:
> > On Fri, Aug 05, 2016 at 10:02:41AM +0200, Felix Janda wrote:
> > > Dave Chinner wrote:
> > > > On Mon, Aug 01, 2016 at 08:54:10AM +0200, Felix Janda wrote:
> > > > > Christoph Hellwig wrote:
> > > > > > On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> > > > > > > int64_t is guaranteed to have the correct size and signedness and is
> > > > > > > always avaible because linux.h has a <inttypes.h> include.
> > > > > > > 
> > > > > > > Fixes compilation error "unkown type name 'off64_t'" on linux when the
> > > > > > > public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> > > > > > > _GNU_SOURCE defined. This bug was introduced in commit
> > > > > > > cb898f157f8410a03cf5f3400baa1df9e5eecd33.
> > > > > > 
> > > > > > I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..
> > > > > 
> > > > > Thanks for the suggestion, but that does not work if the system header
> > > > > defining (or not) off64_t is included before the xfs headers.
> > > > 
> > > > Which, to me, is a build bug in whatever code is including the xfs
> > > > headers.  Isn't it the responsibility of the build environment to
> > > > ensure the dependencies of the libraries being used are correctly
> > > > met?
> > > 
> > > Every program using the xfs header is supposed to know that (only on
> > > linux) since commit cb898f157f8410a03cf5f3400baa1df9e5eecd33 it is
> > > necessary to define _LARGEFILE64_SOURCE or _GNU_SOURCE?
> > 
> > Which, I'd say, most already do, because anything trying to use XFS
> > ioctls needs to be 64 bit offset clean, even on 32 bit systems.  I
> > don't see any problem with requiring it when including a header
> > that exposes ioctl interfaces with 64 bit file size/offset fields
> > in them....
> 
> The easiest way to be 64bit clean is to use _FILEOFFSET_BITS=64. Then
> off_t is 64bit on all architectures and it is impossible to use 32bit
> interfaces. However the type off64_t will still not be defined...
> 
> (On the other hand, when just using _LARGEFILE64_SOURCE it is still
> easy to mix 32 and 64bit interfaces.)

Which, with library code, we are likely to see applications using.

If you want to clean this up, then remove the dependence on
_LARGEFILE64_SOURCE in the entire xfsprogs code base (e.g. it uses
lseek64 everywhere which requires off64_t to be defined) and instead
make it dependent on _FILEOFFSET_BITS=64. Then you can get rid of
all the uses of off64_t completely, and we can break the build if
_FILEOFFSET_BITS != 64 on inclusion of xfs.h.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
