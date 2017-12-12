Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752710AbdLLXfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 18:35:41 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBCNXlrn062693
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 18:35:41 -0500
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2etrs909ru-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 18:35:41 -0500
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 12 Dec 2017 23:35:39 -0000
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 12 Dec 2017 18:35:34 -0500
In-Reply-To: <20171212211302.GW5858@dastard>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
         <20171212211302.GW5858@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1513121734.3476.79.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Hi Dave,

On Wed, 2017-12-13 at 08:13 +1100, Dave Chinner wrote:
> On Tue, Dec 12, 2017 at 09:21:09AM -0500, Mimi Zohar wrote:
> > Move the XFS_SB_MAGIC definition to magic.h.
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h | 3 ++-
> >  include/uapi/linux/magic.h | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 1acb584fc5f7..05f7d83e5f88 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -18,6 +18,8 @@
> >  #ifndef __XFS_FORMAT_H__
> >  #define __XFS_FORMAT_H__
> >  
> > +#include <linux/magic.h>
> > +
> >  /*
> >   * XFS On Disk Format Definitions
> >   *
> > @@ -38,7 +40,6 @@ struct xfs_ifork;
> >   * Fits into a sector-sized buffer at address 0 of each allocation group.
> >   * Only the first of these is ever updated except during growfs.
> >   */
> > -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> >  #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
> >  #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
> >  #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
> 
> NAK.
> 
> The XFS superblock magic number is part of the on-disk format
> definition of XFS. It belongs with all the other on-disk format
> definitions in this file.
> 
> Besides, there is almost never a good reason to be doing stuff based
> on filesystem magic numbers. What, exactly, do you need to know
> filesystem magic numbers for in the kernel?

IMA measures, appraises, and audits files based on policy.  The
builtin in measurement and appraisal policies can be defined on the
boot command line (eg. ima_policy=tcb|appraise_tcb|secure_boot).
 These initial builtin policies are course grain. 

After the LSMs are enabled, the IMA policy can be defined in terms of
the LSM labels and other file metadata (eg. UUID, uid, euid, fsmagic,
...).  Normally the builtin policies are subsequently replaced with a
custom policy in the initramfs.

Mimi

