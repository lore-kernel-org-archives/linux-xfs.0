Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D51C27CBF
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 00:28:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B40938F8033
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 22:28:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qFq4vRCSHHSTrux0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 22:28:23 -0800 (PST)
Date: Mon, 9 Nov 2015 22:27:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 03/51] xfs_io: support reflink and dedupe of file ranges
Message-ID: <20151110062758.GG3255@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050533.1504.66249.stgit@birch.djwong.org>
	<20151014053656.GJ10397@birch.djwong.org>
	<20151109075438.GA17974@infradead.org>
	<20151109183311.GA3255@birch.djwong.org>
	<20151109185724.GB2224@birch.djwong.org>
	<20151109213520.GB14311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151109213520.GB14311@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 10, 2015 at 08:35:20AM +1100, Dave Chinner wrote:
> On Mon, Nov 09, 2015 at 10:57:24AM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 09, 2015 at 10:33:12AM -0800, Darrick J. Wong wrote:
> > > On Sun, Nov 08, 2015 at 11:54:38PM -0800, Christoph Hellwig wrote:
> > > > Any reason why the dedup command is called 'dedupe'?  Is this a revenge
> > > > for the missing 'e' in the creat syscall? :)
> > > 
> > > Heh, sure! :)
> > > 
> > > I stuck on the 'e' because the btrfs tool is 'duperemove', not 'dupremove'.
> > > 
> > > (I have no preference either way.)
> > > 
> > > > Either way it would be good to get this support in ASAP so we can have
> > > > the command ready for xfstests and we can merge the test.  They are
> > > > useful for btrfs and NFS already, so I'd love to fast track them.
> > 
> > Oh. Heh.  I forgot that Dave merged the v1 patch into for-next after I'd posted
> > the v2 patch.  So ... I thought I'd convinced him to revert the v1 patch and
> > stuff in the v2 patch, but that hasn't shown up on kernel.org.
> > 
> > -ETOOMANYPATCHES :(
> 
> Need to push it out - I have an updated branch here, just been
> delayed in testing and pushing out progs-4.3-rc2.

Ok, thanks, I'll rebase and give the tests a spin in the morning.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
