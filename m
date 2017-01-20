Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:32629 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752239AbdATWx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 17:53:28 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0KMr1J9030266
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 22:53:01 GMT
Date: Fri, 20 Jan 2017 14:51:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs_repair: zero shared_vn
Message-ID: <20170120225153.GG12985@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
 <933788b7-2156-357e-029d-03294bf8f5bf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933788b7-2156-357e-029d-03294bf8f5bf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jan 20, 2017 at 04:20:27PM -0600, Eric Sandeen wrote:
> On 1/20/17 2:25 PM, Darrick J. Wong wrote:
> > Since shared_vn always has to be zero, zero it at the end of repair.
> 
> If it's not, shouldn't it be properly warned, fixed, exit-code
> set, etc?

Yeah, you're right, that's what we have phase 1 for.

--D

> 
> -Eric
>  
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/xfs_repair.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 622d569..ecfa6b4 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -1050,6 +1050,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
> >  			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
> >  	}
> >  
> > +	/* shared_vn is always zero. */
> > +	dsb->sb_shared_vn = 0;
> > +
> >  	libxfs_writebuf(sbp, 0);
> >  
> >  	/*
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
