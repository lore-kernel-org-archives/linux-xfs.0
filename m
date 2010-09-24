Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O0afiK155764 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 19:36:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CCF898B9A
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 17:37:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	as02QJB1kXl0G4Ku for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 17:37:35 -0700 (PDT)
Date: Fri, 24 Sep 2010 10:37:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH VER 4] Extend project quotas to support 32bit project
	identificators.
Message-ID: <20100924003732.GP2614@dastard>
References: <1285177343-11108-1-git-send-email-arekm@maven.pl>
	<20100922184242.GA9911@infradead.org>
	<201009222101.13985.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009222101.13985.arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 09:01:13PM +0200, Arkadiusz Miskiewicz wrote:
> On Wednesday 22 of September 2010, Christoph Hellwig wrote:
> > On Wed, Sep 22, 2010 at 07:42:23PM +0200, Arkadiusz Mi??kiewicz wrote:
> > >  	if (mask & FSX_PROJID) {
> > > 
> > > +		/*
> > > +		 * Switch on the PROJID32BIT superblock bit when needed
> > > +		 * (implies also FEATURES2)
> > > +		 */
> > > +		if (!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb) &&
> > > +				fa->fsx_projid > (__uint16_t)-1)
> > > +			xfs_addprojid32bit(tp, ip);
> > 
> > Didn't we agree that we want to enable this feature explicitly via
> > xfs_admin (or mkfs.xfs)?
> 
> Actually there was no agreement on this. Some think that it's good to do that 
> automaticly (so user doesn't have to do anything and has everything working) 
> and others think that it should be turned on explictly by xfs_admin/mkfs.xfs.
> 
> For me both methods are fine, both have some advantages and disadvantages.
> 
> (There was an agreement that separate projid (from group) quota should be 
> turned on manually but was no such agreement on projid32bit)

I think I eventually agreed with Christoph that xfs_admin/mkfs was
the way to go, simply from the principle of least surprise. i.e.
upgrading the kernel shouldn't make a projid set that previously
failed now succeed and prevent a kernel downgrade that is only
discovered during downgrade...


> > > -	__u16		bs_projid;	/* project id			*/
> > > +	__u16		bs_projid_lo;	/* lower part of project id	*/
> > > 
> > >  	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
> > > 
> > > -	unsigned char	bs_pad[12];	/* pad space, unused		*/
> > > +	__u16		bs_projid_hi;	/* higher part of project id	*/
> > > +	unsigned char	bs_pad[10];	/* pad space, unused		*/
> > 
> > Unlike in the inode we can't just rename the lo field here - that would
> > break the compilation of existing applications.
> 
> Ok but maybe breaking these is good?

No, there is never a good reason for breaking applications like
this.

> So these can be extended to support 32bit 
> projid. Otherwise these will get crap if 32bit projid is enabled (actually 
> already built binaries will still get crap for > 16bit values with projid32bit 
> patch).

At which point a userspace upgrade is required to match the kernel
upgrade. Another reason so only allowing the feature to be switched
on via xfs-admin/mkfs - it means that userspace XFS utilities have
already been upgraded to support 32 bit projids before it can be
switched on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
