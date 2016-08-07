Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9ED6D7CD8
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:10:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52C2E8F8040
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:10:40 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id lX2pVLd8uAFte0q6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:10:33 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 419A620A8E
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:10:30 +0200 (CEST)
Date: Sun, 7 Aug 2016 09:09:49 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160807070949.GA24018@nyan>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
	<20160801065410.GA341@nyan> <20160804004747.GZ16044@dastard>
	<20160805080241.GA749@nyan> <20160805115239.GH16044@dastard>
	<20160805130905.GA321@nyan> <20160805224439.GM16044@dastard>
	<20160806083852.GA26156@nyan> <20160806231802.GN16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160806231802.GN16044@dastard>
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
> On Sat, Aug 06, 2016 at 10:38:52AM +0200, Felix Janda wrote:
> > Dave Chinner wrote:
[snip]
> > > If you want to clean this up, then remove the dependence on
> > > _LARGEFILE64_SOURCE in the entire xfsprogs code base (e.g. it uses
> > > lseek64 everywhere which requires off64_t to be defined) and instead
> > > make it dependent on _FILEOFFSET_BITS=64. Then you can get rid of
> > > all the uses of off64_t completely, and we can break the build if
> > > _FILEOFFSET_BITS != 64 on inclusion of xfs.h.
> > 
> > Yes, I'd like to clean this up.
> > 
> > But first note that you can have both _FILE_OFFSET_BITS=64 and
> > _LARGEFILE64_SOURCE. Then everything (off64_t, lseek64, ...) is
> > defined and everything (off_t, lseek, ...) is 64bit.
> > 
> > So to clean up I would first get _FILE_OFFSET_BITS=64 defined and then
> > start "removing 64" from functions/types in any order. *Before
> > modifying the public headers* the sizeof(off_t)=8 check needs to
> > be put into xfs.h.
> > 
> > Also note that there are 3 different (but equivalent) off_t types
> > currently used in the code base: off64_t, loff_t and xfs_off_t.
> > Should these be converted to xfs_off_t or off_t?
> 
> Not that simple. loff_t has to remain for the copy_file_range()
> syscall in xfs_io. That syscall requires _GNU_SOURCE  and loff_t to
> be defined from the system headers, so it can't really go away.

loff_t is the kernel name for the 64 bit offset type. (The kernel
needs to distinguish between off_t and loff_t because it needs to
export both 32bit and 64bit syscalls.) Since we are in userspace, we
can use the user space off_t, which coincides with kernel loff_t.

> xfs_off_t is an internal XFS file offset definition, used by the
> code in libxfs/ and shared with the kernel code, so it can't go
> away, either.
> 
> So, essentially, the only code that should change is all
> the code that uses off64_t - that can use off_t as that's what
> all the systems that use those variables require...

ok.

> > Still, doing these type conversions is going to be pretty invasive
> > and is not unlikely to conflict with outstanding patches. Is now
> > a good time for this? (How about the __uint -> uint, __int -> int
> > conversion?)
> 
> off64_t -> off_t affects very little of the new code we have
> outstanding. It mostly affects xfs_io, so there's little to worry
> about in terms of merge conflicts here.

will send a patch series soon.

> The __*int conversions are a different matter. They affect the
> entire code base - they are widespread through the libxfs code so we
> need to do a kernel code conversion first. Then we can propagate
> that back into the libxfs code in xfsprogs, and then the rest of
> xfsprogs can be done.

ok, I looked into the kernel. The only user of __uint*_t and __int*_t
are inside fs/xfs. I can prepare a patch for that.

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
