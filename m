Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87E767FB9
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 05:27:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74D77304032
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 03:27:45 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id TbuvT8KO7XarAzkG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 03:27:42 -0700 (PDT)
Date: Thu, 2 Jul 2015 06:27:17 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1629704668.22787354.1435832837879.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150701225535.GT22807@dastard>
References: <1435766461-30961-1-git-send-email-jtulak@redhat.com>
	<20150701225535.GT22807@dastard>
Subject: Re: [PATCH] xfsprogs: blkid is now mandatory
MIME-Version: 1.0
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
Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com
> Sent: Thursday, July 2, 2015 12:55:36 AM
> Subject: Re: [PATCH] xfsprogs: blkid is now mandatory
> 
> On Wed, Jul 01, 2015 at 06:01:01PM +0200, Jan Tulak wrote:
> > Because blkid is here for a long time, I hereby propose a patch for
> > removing support
> > for NOT having blkid. The current support through set of #ifdef is prone to
> > errors like
> > making a patch just in one of the branches, and according to a recent talk
> > between
> > Christoph and Eric, it is not necessary to keep it supported.
> > 
> > Remove code for checking ENABLE_BLKID, and the code when ENABLE_BLKID is
> > not defined.
> > It makes blkid required for compilation.
> > 
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  Makefile             |  5 ----
> >  configure.ac         |  6 +----
> >  doc/INSTALL          | 44 ------------------------------------
> >  include/builddefs.in |  1 -
> >  libdisk/Makefile     |  4 ----
> >  m4/package_blkid.m4  |  7 +++---
> >  mkfs/Makefile        | 21 ++++-------------
> >  mkfs/xfs_mkfs.c      | 64
> >  ----------------------------------------------------
> >  8 files changed, 10 insertions(+), 142 deletions(-)
> 
> Given that only mkfs.xfs uses libdisk, which is now not linked to
> any binary, shouldn't libdisk/ be removed completely?
> 
> Cheers,
> 
> Dave.

True, I prepared a fixed patch with libdisk removed. Also, it looks to me like ft.sectoralign in xfs_mkfs.c is not used anymore:

	if (ft.sectoralign) {
		/*
		 * Older Linux software RAID versions want the sector size
		 * to match the block size to avoid switching I/O sizes.
		 * For the legacy libdisk case we thus set the sector size to
		 * match the block size.  For systems using libblkid we assume
		 * that the kernel is recent enough to not require this and
		 * ft.sectoralign will never be set.
		 */
		sectorsize = blocksize;
	} 

So I removed it too.
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
