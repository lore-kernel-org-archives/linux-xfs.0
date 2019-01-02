Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbfABNaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 08:30:01 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id x02DSerf091612
        for <linux-xfs@vger.kernel.org>; Wed, 2 Jan 2019 08:30:00 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2prwwvgphq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Jan 2019 08:30:00 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 2 Jan 2019 13:29:58 -0000
From: Chandan Rajendra <chandan@linux.ibm.com>
Subject: Re: [PATCH 1/8] xfs: never try to scrub more than 64 inodes per inobt record
Date: Wed, 02 Jan 2019 19:00:14 +0530
In-Reply-To: <20190102123929.n3errbeyyc2mctgu@hades.usersys.redhat.com>
References: <154630850739.14372.14000129432637481206.stgit@magnolia> <154630851366.14372.14057534574140159776.stgit@magnolia> <20190102123929.n3errbeyyc2mctgu@hades.usersys.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1924814.p1nb3C9jSa@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wednesday, January 2, 2019 6:09:29 PM IST Carlos Maiolino wrote:
> On Mon, Dec 31, 2018 at 06:08:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure we never check more than XFS_INODES_PER_CHUNK inodes for any
> > given inobt record since there can be more than one inobt record mapped
> > to an inode cluster.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/ialloc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 882dc56c5c21..fd431682db0b 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -203,7 +203,8 @@ xchk_iallocbt_check_freemask(
> >  	int				error = 0;
> >  
> >  	/* Make sure the freemask matches the inode records. */
> > -	nr_inodes = mp->m_inodes_per_cluster;
> > +	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
> > +			mp->m_inodes_per_cluster);
> 
> Pardon me if this doesn't make sense, but, this looks like a good time to catch
> a possible corruption?! If mp->m_inodes_per_cluster is > XFS_INODES_PER_CHUNK
> something is terribly wrong and we could report it here instead of max it out to
> XFS_INODES_PER_CHUNK, but I haven't studied the scrub code that deep yet to see
> if my suggestion makes sense or not :)

With 64k block size, we would have 128 inodes per cluster i.e. more than one
chunk can be accommodated within a cluster.

-- 
chandan
