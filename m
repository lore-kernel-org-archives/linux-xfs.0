Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D90F7CA4
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 17:36:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FD568F8037
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 15:36:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Fs0DvlnuFoqIJzOF for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 15:36:23 -0700 (PDT)
Date: Wed, 7 Sep 2016 08:35:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: undo block reservation correctly in
	xfs_trans_reserve()
Message-ID: <20160906223533.GL30056@dastard>
References: <1473149039-30487-1-git-send-email-guaneryu@gmail.com>
	<20160906084828.GK30056@dastard>
	<20160906115045.GG2462@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906115045.GG2462@eguan.usersys.redhat.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 07:50:45PM +0800, Eryu Guan wrote:
> On Tue, Sep 06, 2016 at 06:48:28PM +1000, Dave Chinner wrote:
> > On Tue, Sep 06, 2016 at 04:03:59PM +0800, Eryu Guan wrote:
> > > Fixes: 0d485ada404b ("xfs: use generic percpu counters for free block counter")
> > 
> > I really don't like this sort of "annotation". It wrongly implies
> > the commit was broken (it wasn't) and there's no scope for stating
> > the problem context. i.e.  that the problem is a minor regression in
> > a rarely travelled corner case that is unlikely to affect production
> > machines in any significant way. It's better to describe things with
> > all the relevant context:
> > 
> > "This is a regression introduced in commit ... and only occurs when
> > .... "
> 
> Makes sense, will do so.
> 
> > 
> > > Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> > 
> > Not @redhat?
> 
> I thought that I'm employed by Red Hat as a QE not a filesystem
> developer, all filesystem patches I send reflect my own opinions not my
> employer's, so all silly mistakes I made in the patches are under my
> personal email too :)

Copyright assignments rarely work like that. It's a big grey area,
though, so I think you should check with your legal department as to
what you should use here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
