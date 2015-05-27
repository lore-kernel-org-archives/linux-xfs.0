Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D192A7F47
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 19:46:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BDCB18F8070
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 17:46:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eocyNJDsp5a9SCXK for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 17:46:10 -0700 (PDT)
Date: Wed, 27 May 2015 10:46:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: saner xfs_trans_commit interface
Message-ID: <20150527004608.GY15721@dastard>
References: <1431285519-7768-1-git-send-email-hch@lst.de>
	<1431285519-7768-4-git-send-email-hch@lst.de>
	<20150511203237.GA59885@bfoster.bfoster>
	<20150512063632.GA25562@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150512063632.GA25562@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, May 12, 2015 at 08:36:32AM +0200, Christoph Hellwig wrote:
> On Mon, May 11, 2015 at 04:32:37PM -0400, Brian Foster wrote:
> > >  	xfs_trans_unreserve_and_mod_dquots(tp);
> > >  	if (tp->t_ticket) {
> > > +		int			log_flags = 0;
> > > +
> > > +		if (regrant) {
> > > +			ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > +			log_flags = XFS_LOG_REL_PERM_RESERV;
> > > +		}
> > 
> > Is the regrant logic here and in xfs_log_commit_cil() backwards or am I
> > misreading?
> 
> Yes, it's actually wrong, but fixed up by the next patch.
> 
> I'll wait for more review feedback and will resend a fixed version.

Apart from this I can't see anything obviously wrong with this
cleanup, so if you coul dpost a fixed up version that would be
great!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
