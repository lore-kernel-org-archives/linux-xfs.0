Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85B6E7CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:00:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AE7F304051
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 13:00:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UT4ccxZoYNhh2Ril for <xfs@oss.sgi.com>;
	Wed, 16 Mar 2016 13:00:48 -0700 (PDT)
Date: Thu, 17 Mar 2016 07:00:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/073: filter out finobt warning from mkfs.xfs
Message-ID: <20160316200043.GG11812@dastard>
References: <1458129204-31882-1-git-send-email-eguan@redhat.com>
	<20160316120416.GA18030@infradead.org>
	<20160316145418.GT11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160316145418.GT11419@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 16, 2016 at 10:54:18PM +0800, Eryu Guan wrote:
> On Wed, Mar 16, 2016 at 05:04:16AM -0700, Christoph Hellwig wrote:
> > On Wed, Mar 16, 2016 at 07:53:24PM +0800, Eryu Guan wrote:
> > > When testing xfs/073 with MKFS_OPTIONS="-m crc=1,finobt=1" set, it fails
> > > due to extra warning about disabling finobt feature:
> > > 
> > >  +warning: finobt not supported without CRC support, disabled.
> > > 
> > > Because xfs/073 disables crc unconditionally and finobt can not be
> > > enabled either.
> > 
> > How about explicitly disabling finobt as well?
> 
> I think that's a cleaner way to fix it. Just that some extra work is
> needed to let the test pass with old mkfs.xfs without metadata suport.

This is a downhill slope. e.g. if I add "-i sparse=1" to the mkfs
line, it will warning differently and a new filter is needed. I
would suggest just ignoring the mkfs output altogether (maybe just
dumping it all to $seqres.full) as it's not necessary to determine
whether the test ran correctly or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
