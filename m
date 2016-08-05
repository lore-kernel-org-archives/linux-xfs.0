Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D86C7CB2
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 08:09:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40001304039
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 06:09:48 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id ssGQOSa4IFefCfRB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 06:09:45 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 76F4C20852
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 15:09:43 +0200 (CEST)
Date: Fri, 5 Aug 2016 15:09:05 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160805130905.GA321@nyan>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
	<20160801065410.GA341@nyan> <20160804004747.GZ16044@dastard>
	<20160805080241.GA749@nyan> <20160805115239.GH16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805115239.GH16044@dastard>
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
> On Fri, Aug 05, 2016 at 10:02:41AM +0200, Felix Janda wrote:
> > Dave Chinner wrote:
> > > On Mon, Aug 01, 2016 at 08:54:10AM +0200, Felix Janda wrote:
> > > > Christoph Hellwig wrote:
> > > > > On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> > > > > > int64_t is guaranteed to have the correct size and signedness and is
> > > > > > always avaible because linux.h has a <inttypes.h> include.
> > > > > > 
> > > > > > Fixes compilation error "unkown type name 'off64_t'" on linux when the
> > > > > > public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> > > > > > _GNU_SOURCE defined. This bug was introduced in commit
> > > > > > cb898f157f8410a03cf5f3400baa1df9e5eecd33.
> > > > > 
> > > > > I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..
> > > > 
> > > > Thanks for the suggestion, but that does not work if the system header
> > > > defining (or not) off64_t is included before the xfs headers.
> > > 
> > > Which, to me, is a build bug in whatever code is including the xfs
> > > headers.  Isn't it the responsibility of the build environment to
> > > ensure the dependencies of the libraries being used are correctly
> > > met?
> > 
> > Every program using the xfs header is supposed to know that (only on
> > linux) since commit cb898f157f8410a03cf5f3400baa1df9e5eecd33 it is
> > necessary to define _LARGEFILE64_SOURCE or _GNU_SOURCE?
> 
> Which, I'd say, most already do, because anything trying to use XFS
> ioctls needs to be 64 bit offset clean, even on 32 bit systems.  I
> don't see any problem with requiring it when including a header
> that exposes ioctl interfaces with 64 bit file size/offset fields
> in them....

The easiest way to be 64bit clean is to use _FILEOFFSET_BITS=64. Then
off_t is 64bit on all architectures and it is impossible to use 32bit
interfaces. However the type off64_t will still not be defined...

(On the other hand, when just using _LARGEFILE64_SOURCE it is still
easy to mix 32 and 64bit interfaces.)

Please refer to the "Using LFS Section" of:

http://users.suse.com/~aj/linux_lfs.html

Cheers,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
