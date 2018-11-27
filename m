Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44022 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730663AbeK1DXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 22:23:50 -0500
Date: Tue, 27 Nov 2018 08:25:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: libxfs: move xfs_perag_put late
Message-ID: <20181127162516.GG6792@magnolia>
References: <1543278818-117362-1-git-send-email-bianpan2016@163.com>
 <20181127091602.eaeczahefobpx544@hades.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127091602.eaeczahefobpx544@hades.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pan Bian <bianpan2016@163.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 27, 2018 at 10:16:02AM +0100, Carlos Maiolino wrote:
> On Tue, Nov 27, 2018 at 08:33:38AM +0800, Pan Bian wrote:
> > The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
> > reference. However, pag->pagf_btreeblks is read and write after the 
> > put operation. This patch moves the put operation late.
> 
> I'm not a native English speaker too, but I believe it should be "is read and
> written after..."
> 
> But, for the code itself, you can add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Cheers
> 
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>

Looks ok, will amend the changelog on the way in.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> > ---
> > V2: correct the commit log
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index e1c0c0d..4be387d 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2435,7 +2435,6 @@ xfs_alloc_get_freelist(
> >  	be32_add_cpu(&agf->agf_flcount, -1);
> >  	xfs_trans_agflist_delta(tp, -1);
> >  	pag->pagf_flcount--;
> > -	xfs_perag_put(pag);
> >  
> >  	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
> >  	if (btreeblk) {
> > @@ -2443,6 +2442,7 @@ xfs_alloc_get_freelist(
> >  		pag->pagf_btreeblks++;
> >  		logflags |= XFS_AGF_BTREEBLKS;
> >  	}
> > +	xfs_perag_put(pag);
> >  
> >  	xfs_alloc_log_agf(tp, agbp, logflags);
> >  	*bnop = bno;
> > -- 
> > 2.7.4
> > 
> > 
> 
> -- 
> Carlos
