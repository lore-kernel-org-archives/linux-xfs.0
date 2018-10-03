Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34976 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeJCU1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 16:27:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id w5-v6so6206046wrt.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Oct 2018 06:39:18 -0700 (PDT)
Date: Wed, 3 Oct 2018 15:39:14 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Message-ID: <20181003133914.gikxezpadsyil7hp@odin.usersys.redhat.com>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-2-cmaiolino@redhat.com>
 <46ff8aca-5053-541d-6d74-fbc7e12a9898@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ff8aca-5053-541d-6d74-fbc7e12a9898@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 07:47:46AM -0500, Eric Sandeen wrote:
> On 10/3/18 7:35 AM, Carlos Maiolino wrote:
> > The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> > __xfssats structure.
> > 
> > Although this didn't cause any direct issue,  xqmstat_proc_show() relied
> > on the old offsets to display the xqm statistics.
> 
> Well, it caused /proc/fs/xfs/xqmstat to display garbage data, right?
> That seems worth highlighting in the changelog, and not glossing over.

Well, I wouldn't say 'garbage' data. I'd say data from other fields in the
structure (at this point, specifically fino btree data) :P, but sure, I can add
it to the changelog.

> 
> Could maybe use Fixes: tags for:
> 
> 00f4e4f9 xfs: add rmap btree stats infrastructure
> aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
> 46eeb521 xfs: introduce refcount btree definitions
> 

No objection.

> and a stable tag as well?  Though stable is tricky because different patches
> would be required for different points along the stats structure evolution...
> maybe best to ignore it, chances of auto-applying it correctly are slim to
> none.

Indeed, this may not apply to stable trees, unless the tree itself contains all
three data structures (rmap finobtree and refcount).

> 
> As for the change itself,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> 
> 
> > Fix it.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_stats.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> > index 4e4423153071..740ac9674848 100644
> > --- a/fs/xfs/xfs_stats.c
> > +++ b/fs/xfs/xfs_stats.c
> > @@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
> >  	int j;
> >  
> >  	seq_printf(m, "qm");
> > -	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
> > +	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
> >  		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
> >  	seq_putc(m, '\n');
> >  	return 0;
> > 

-- 
Carlos
