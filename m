Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82D3A7CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 15:49:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44E1F8F8035
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:49:44 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id tozR46kGDenJogY1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:49:41 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 021C8208F7
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 22:49:38 +0200 (CEST)
Date: Wed, 24 Aug 2016 22:47:46 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160824204746.GA25162@nyan>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<20160824011911.GA19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160824011911.GA19025@dastard>
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
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Sat, Aug 13, 2016 at 07:04:18PM +0200, Felix Janda wrote:
> > This patch series does several things related to large file support.
> > 
> > Patches 1-3 enable transparent LFS in the build system and make it
> > mandatory.
> > 
> > Patches 4-9 and 12 replace *64 function and structure aliases.
> > 
> > Patches 10 and 11 disable fsr on Mac OS X and do cleanup to enable
> > Patch 12. Further cleanup of the portability code is possible later.
> > 
> > Patch 13 makes tranparent LFS also mandatory for all users of libxfs.
> > 
> > Patch 14 finally replaces off64_t by off_t.
> > 
> > 
> > In comparison to v1:
> > 
> > Patches 1, 3 and 14 are identical to previous patches. Patches 4-8 are
> > identical to previous patches, except that some of them are merged.
> > Patch 9 was previously send separately from the patch series. Patch
> > 13 is identical to a previous patch except for the commit message. The
> > other patches are new, grown out of review by Christoph Hellwig.
> > 
> > Felix Janda (14):
> >   configure: use AC_SYS_LARGEFILE
> >   configure: error out when LFS does not work
> >   remove unecessary definitions of _FILE_OFFSET_BITS
> >   replace [fl]stat64 by equivalent [fl]stat
> >   replace ftruncate64 by equivalent ftruncate
> >   replace lseek64 by equivalent lseek
> >   replace pread64/pwrite64 by equivalent pread/pwrite
> >   replace sendfile64 by equivalent sendfile
> >   fadvise.c: replace posix_fadvise64 by equivalent posix_fadvise
> >   Makefile: disable fsr for Mac OS X
> >   fsr: remove workaround for statvfs on Mac OS X
> >   replace statvfs64 by equivalent statvfs
> >   xfs.h: require transparent LFS for all users
> >   platform: remove use of off64_t
> 
> So, the patches are fine, and everything works. Problem is, it
> screws up xfstests because it changes all the error messages
> that are output to stderr and captured by the test harness.
> There are quite a few tests that this causes failures for,
> and because it's stderr, it's not as simple as just adding a new
> filter to do 'sed -e "s/^\(.*\)64\(: .*$\)/\1\2/"' on stderr.

Thanks for testing!

I can rework the patches to leave stderr unchanged. I guess that this
is preferable as opposed to updating the output expected by xfstests
since xfstests should be usable with both old and new xfsprogs.

> Further, errors returned change, which further screws up xfstests.
> e.g. old code gives EFBIG when we try to use offsets beyond the
> supported range, this patchset returns EINVAL.  That further
> complicates any sort of error filtering we'll need to do.

I am very surprised that something apart from the error messages has
changed. I would be interested to know on what architecture and for
which test(s) (where) this happened, if you still remember.

> I don't have the time or patience to fix up xfstests for every
> change that people want to make and this series is a non-critical
> cleanup, so I'm dropping this until the fixups for xfstests are
> worked out. I'm not going to get to this for weeks at the current
> rate patches are being thrown at me for inclusion, so I'm not
> breaking xfstests for everyone while I'm bottlenecked on other,
> higher priority changes.

That make sense.

--Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
