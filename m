Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CBkbk7183835 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 05:46:38 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89BCD1D27E43
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 03:48:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	3JcTFsD2H82gTd7k for <xfs@oss.sgi.com>;
	Wed, 12 Jan 2011 03:48:49 -0800 (PST)
Date: Wed, 12 Jan 2011 22:48:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20110112114823.GO28803@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org>
	<20101109044242.GH2715@dastard> <20101109214147.GK3099@thunk.org>
	<20101109234049.GQ2715@dastard>
	<AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
	<20110111213007.GF2917@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110111213007.GF2917@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>, Lawrence Greenfield <leg@google.com>, Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com

On Tue, Jan 11, 2011 at 04:30:07PM -0500, Ted Ts'o wrote:
> On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
> > > IOWs, all they want to do is avoid the unwritten extent conversion
> > > overhead. Time has shown that a bad security/performance tradeoff
> > > decision was made 13 years ago in XFS, so I see little reason to
> > > repeat it for ext4 today....
> 
> I suspect things may have changed somewhat; both in terms of
> requirements and nature of cluter file systems, and the performance of
> various storage systems (including PCIe-attached flash devices).  

We can throw 1000x more CPU power and memory at the problem than
we could 13 years ago. IOW the system balance hasn't changed (even
considering pci-e SSDs) compared to 13 years. Hence if it was a bad
tradeoff 13 years ago, it's still a bad tradeoff today.

> > I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
> > of extent conversion. It's that extent conversion causes more metadata
> > operations than what you'd have otherwise, which means systems that
> > want to use O_DIRECT and make sure the data doesn't go away either
> > have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> > cluster file system implementor,
> 
> One possibility might be to make it an optional feature which is only
> enabled via a mount option.  That way someone would have to explicit
> ask for this feature two ways (via a new flag to fallocate) and a
> mount option.

Proliferation of mount options just to enable feature X of API Y for
filesystem Z is not a good idea. Either you enable it via the
fallocate API or you don't allow it at all.

> It might not make sense for XFS, but for people who are using ext4
> as the local storage file system back-end,

How does this differ from a local filesystem? Are you talking about
storage nodes for clustered/cloudy storage?

If so, I know of quite a few places that use XFS for this purpose
and they all seem to measure storage in petabytes made up of small
boxes containing anywhere between 30-100TB each. The only request
for additional preallocation functionality I've got from people
running such applications recently is for XFS_IOC_ZERO_RANGE. This
is quite relevant, because that specifically converts allocated
extents to unwritten extents. i.e. they like to be able to
efficiently re-initialise allocated space to zeros rather than
have it contain stale data.

> and are doing all sorts of things to get the best performance,
> including disabling the journal, I suspect it really would make
> sense.

That's not really a convincing argument for a new interface that
needs to be maintained forever.

> So it could always be an
> optional-to-implement flag, that not all file systems should feel
> obliged to implement.

It could, but it still needs better justification.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
