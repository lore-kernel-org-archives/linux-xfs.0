Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A936E7CA4
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 02:39:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29138AC002
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 00:39:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ESJFapNZq7vE6Klc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 00:39:23 -0700 (PDT)
Date: Wed, 3 Aug 2016 15:39:18 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] generic/095: update warning whitelist
Message-ID: <20160803073918.GE16413@zlang.usersys.redhat.com>
References: <1470042176-31447-1-git-send-email-hch@lst.de>
	<20160802232305.GQ12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802232305.GQ12670@dastard>
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
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 09:23:05AM +1000, Dave Chinner wrote:
> On Mon, Aug 01, 2016 at 11:02:56AM +0200, Christoph Hellwig wrote:
> > The recent direct I/O path refactor changed the function name in the
> > racing read case.  Update the test case to handle the new name in
> > addition to the old one.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/generic/095 | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/generic/095 b/tests/generic/095
> > index c656ef1..4754992 100755
> > --- a/tests/generic/095
> > +++ b/tests/generic/095
> > @@ -125,9 +125,11 @@ $FIO_PROG $fio_config >>$seqres.full 2>&1
> >  filter_xfs_dmesg()
> >  {
> >  	local warn1="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_write.*"
> > -	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
> > +	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
> > +	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
> >  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
> > -	    -e "s#$warn2#Intentional warnings in xfs_file_read_iter#"
> > +	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> > +	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#"

Hi,

1) xfs_file_dio_aio_read() was splited from xfs_file_read_iter() by
below commit:

  bbc5a74 xfs: split xfs_file_read_iter into buffered and direct I/O helpers

2) xfs_file_read_iter() came from xfs_file_aio_read() as below commit:

  b4f5d2c xfs: switch to ->read_iter()

Some Linux distro (e.g: RHEL-7) still use the old kernel with old function
xfs_file_aio_read(), generic/095 always fails on it. So how about filter
xfs_file_aio_read too?

Thanks,
Zorro

> >  }
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
