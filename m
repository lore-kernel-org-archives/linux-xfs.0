Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33164 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbeFQOjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jun 2018 10:39:07 -0400
Date: Sun, 17 Jun 2018 22:39:00 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic/223: port t_stripealign to FIEMAP
Message-ID: <20180617143900.GH2780@desktop>
References: <20180613225057.GB9432@magnolia>
 <20180615024901.GF2780@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615024901.GF2780@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Fri, Jun 15, 2018 at 10:49:01AM +0800, Eryu Guan wrote:
> On Wed, Jun 13, 2018 at 03:50:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since XFS has deprecated FIBMAP on FSDAX filesystems, we can't use
> > FIBMAP to verify stripe alignment anymore.  FIEMAP has existed for quite
> > some time now, so port it to use that instead, and only fall back to
> > FIBMAP if FIEMAP doesn't exist.
> > 
> > Tested-by: ross.zwisler@linux.intel.com
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  src/t_stripealign.c |   72 +++++++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 61 insertions(+), 11 deletions(-)
> > 
> > diff --git a/src/t_stripealign.c b/src/t_stripealign.c
> > index 05ed36b5..690f743a 100644
> > --- a/src/t_stripealign.c
> > +++ b/src/t_stripealign.c
> > @@ -17,8 +17,13 @@
> >  #include <fcntl.h>
> >  #include <stdio.h>
> >  #include <sys/ioctl.h>
> > +#include <linux/fiemap.h>
> > +#include <linux/fs.h>
> 
> As it requires <linux/fiemap.h> now, looks like we should update
> src/Makefile too to only compile it when "HAVE_FIEMAP" is true.
> 
> ifeq ($(HAVE_FIEMAP), true)
> LINUX_TARGETS += fiemap-tester t_stripealign
> endif

JFYI, I fixed it on commit (also remove t_stripealign from TARGETS).

Thanks,
Eryu
