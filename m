Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 515427F89
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:14:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FC4B304048
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:14:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yxtqtlRngdonScu6 for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:14:31 -0700 (PDT)
Date: Thu, 30 Jul 2015 08:13:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression 4.2-rc3] loop: xfstests xfs/073 deadlocked in low
	memory conditions
Message-ID: <20150729221356.GC16638@dastard>
References: <20150721015934.GY7943@dastard>
	<20150721085859.GG11967@dhcp22.suse.cz>
	<20150729115411.GF15801@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729115411.GF15801@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Wed, Jul 29, 2015 at 01:54:12PM +0200, Michal Hocko wrote:
> On Tue 21-07-15 10:58:59, Michal Hocko wrote:
> > [CCing more people from a potentially affected fs - the reference to the 
> >  email thread is: http://marc.info/?l=linux-mm&m=143744398020147&w=2]
...
> > > The didn't used to happen, because the loop device used to issue
> > > reads through the splice path and that does:
> > > 
> > > 	error = add_to_page_cache_lru(page, mapping, index,
> > > 			GFP_KERNEL & mapping_gfp_mask(mapping));
> > > 
> > > i.e. it pays attention to the allocation context placed on the
> > > inode and so is doing GFP_NOFS allocations here and avoiding the
> > > recursion problem.
> > > 
> > > [ CC'd Michal Hocko and the mm list because it's a clear exaple of
> > > why ignoring the mapping gfp mask on any page cache allocation is
> > > a landmine waiting to be tripped over. ]
> > 
> > Thank you for CCing me. I haven't noticed this one when checking for
> > other similar hardcoded GFP_KERNEL users (6afdb859b710 ("mm: do not
> > ignore mapping_gfp_mask in page cache allocation paths")). And there
> > seem to be more of them now that I am looking closer.
> > 
> > I am not sure what to do about fs/nfs/dir.c:nfs_symlink which doesn't
> > require GFP_NOFS or mapping gfp mask for other allocations in the same
> > context.
> > 
> > What do you think about this preliminary (and untested) patch?
> 
> Dave, did you have chance to test the patch in your environment? Is the
> patch good to go or we want a larger refactoring?

No, I haven't had a chance to test it yet. I'll try to get somethign
done by the end of the week, but I'm not able to reliably
reproduce the hang I saw (i.e. the analysis I did was from the first
deadlock and I've only seen it once since) so testing is likely to
be inconclusive, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
