Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8ADFA7CE5
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 18:15:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13B10AC056
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 16:14:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MQ828B7jDsSBHqtn for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2016 16:14:57 -0700 (PDT)
Date: Fri, 8 Jul 2016 09:14:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 028/119] xfs: define the on-disk rmap btree format
Message-ID: <20160707231455.GJ12670@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612645206.12839.17008642336898856662.stgit@birch.djwong.org>
	<20160707184156.GB33740@bfoster.bfoster>
	<20160707191813.GB12567@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160707191813.GB12567@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jul 07, 2016 at 12:18:13PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2016 at 02:41:56PM -0400, Brian Foster wrote:
> > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > +		return false;
> > > +	if (!xfs_btree_sblock_v5hdr_verify(bp))
> > > +		return false;
> > > +
> > > +	level = be16_to_cpu(block->bb_level);
> > > +	if (pag && pag->pagf_init) {
> > > +		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
> > > +			return false;
> > > +	} else if (level >= mp->m_rmap_maxlevels)
> > > +		return false;
> > 
> > It looks like the above (level >= mp->m_rmap_maxlevels) check could be
> > independent (rather than an 'else). Otherwise looks good:
> 
> Hmmm.... at first I wondered, "Shouldn't we have already checked that
> pag->pagf_levels[XFS_BTNUM_RMAPi] <= mp->m_rmap_maxlevels?"  But then I
> realized that no, we don't do that anywhere.  Nor does the bnobt/cntbt
> verifier.  Am I missing something?

It should have been ranged checked when the AGF is first read in
(i.e. in the verifier), in ASSERTS every time xfs_alloc_read_agf()
is called after initialisation, and then every time the verifier is
run on write of the AGF.

> I did see that we at least check the AGF/AGI levels to make sure they don't
> overflow XFS_BTREE_MAXLEVELS, so we're probably fine here.

Precisely - if the AGF verifier doesn't have a max level check in it
for the rmapbt, then we need to add one there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
