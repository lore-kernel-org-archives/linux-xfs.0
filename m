Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E8947F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 17:21:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D80230405F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 15:21:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GKjmTVaSS5oygPfv for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 15:21:23 -0800 (PST)
Date: Wed, 21 Jan 2015 10:14:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Remove useless test
Message-ID: <20150120231438.GH16552@dastard>
References: <1421317085-14350-1-git-send-email-jack@suse.cz>
	<1421317085-14350-2-git-send-email-jack@suse.cz>
	<20150115132754.GA23696@bfoster.bfoster>
	<20150120164400.GB3648@quack.suse.cz>
	<20150120221453.GE16552@dastard>
	<20150120223515.GB6521@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150120223515.GB6521@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 20, 2015 at 11:35:15PM +0100, Jan Kara wrote:
>   Hello,
> 
> On Wed 21-01-15 09:14:53, Dave Chinner wrote:
> > On Tue, Jan 20, 2015 at 05:44:00PM +0100, Jan Kara wrote:
> > > On Thu 15-01-15 08:27:54, Brian Foster wrote:
> > > > On Thu, Jan 15, 2015 at 11:18:03AM +0100, Jan Kara wrote:
> > > > > Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.
> > > > > 
> > > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > > ---
> > > > 
> > > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > >   Thanks for reviews! I've pulled the XFS cleanups from this series into my
> > > tree.
> > 
> > I've been at LCA last week and sick all this week as a result, so I
> > haven't yet got to pulling these into the XFS tree. Do you still
> > want me to give you a stable branch with these changes in it to base
> > your series off?
>   If you don't mind, I would just carry those three XFS cleanups together
> with the rest of the quota interface series in my tree. Currently there
> don't seem to be any conflicts with what's in XFS tree so it's easy. And
> the series touches XFS in those areas later anyway...

Fine by me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
