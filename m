Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965870AbdADD1P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 22:27:15 -0500
Date: Wed, 4 Jan 2017 11:27:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/158,304: filter dedupe error message
Message-ID: <20170104032714.GM1859@eguan.usersys.redhat.com>
References: <20161230040854.17512-1-eguan@redhat.com>
 <20170103200149.GB14031@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103200149.GB14031@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jan 03, 2017 at 12:01:49PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 30, 2016 at 12:08:54PM +0800, Eryu Guan wrote:
> > Kernel commit 22725ce4e4a0 ("vfs: fix isize/pos/len checks for reflink &
> > dedupe") added more checks on reflink and dedupe, rejected dedupe past
> > EOF early and explicitly, and causes generic/158 and generic/304 to fail.
> > 
> >   Try dedupe from past EOF
> >  -dedupe: Invalid argument
> >  +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> >   Try dedupe to past EOF, destination offset beyond EOF
> > 
> > Fix it by replacing fs-specific ioctl in error message to "dedupe".
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  common/reflink        | 7 +++++++
> >  tests/generic/158     | 7 +++++--
> >  tests/generic/158.out | 4 ++--
> >  tests/generic/304     | 9 ++++++---
> >  tests/generic/304.out | 2 +-
> >  5 files changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/common/reflink b/common/reflink
> > index 64ee04f..7306efd 100644
> > --- a/common/reflink
> > +++ b/common/reflink
> > @@ -241,6 +241,13 @@ _dedupe_range() {
> >  	$XFS_IO_PROG $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
> >  }
> >  
> > +# Filter fs-specific ioctl in error message to "dedupe"
> > +# e.g. replace XFS_IOC_FILE_EXTENT_SAME with dedupe
> > +_filter_dedupe()
> > +{
> > +	sed -e 's/XFS_IOC_FILE_EXTENT_SAME/dedupe/g'
> > +}
> 
> I sent a patch to the xfs list last month ("xfs_io: prefix dedupe
> command error messages consistently") changing all the error message
> prefixes to "XFS_IOC_FILE_EXTENT_SAME".  Was going to send a patch to
> fix up xfstests too... but evidently didn't.

Ah, didn't notict that patch.. Or I did saw the patch but failed to link
it with this test failure :)

> 
> If you change the sed command to 's/dedupe:/XFS_IOC_FILE_EXTENT_SAME:/g'
> that'll suffice, I think.

Will do. Thanks!

Eryu
