Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JKia85161806 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 15:44:37 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OAHvvZVNxWcOBZL8 for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 13:44:36 -0700 (PDT)
Date: Tue, 19 Jun 2012 16:44:28 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619204428.GA9485@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
	<20120619144316.GD14208@agk-dp.fab.redhat.com>
	<20120619152856.GB7225@redhat.com>
	<20120619195834.GC22805@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619195834.GC22805@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

On Tue, Jun 19 2012 at  3:58pm -0400,
Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Jun 19, 2012 at 11:28:56AM -0400, Mike Snitzer wrote:
> > 
> > That is an lvm2 BZ but there is further kernel work needed.
> > 
> > It should be noted that the "external origin" feature was added to the
> > thinp target with this commit: 
> > http://git.kernel.org/linus/2dd9c257fbc243aa76ee6d
> > 
> > It is start, but external origin is kept read-only and any writes
> > trigger allocation of new blocks within the thin-pool.
> 
> Hmm... maybe this is what I had been told.  I thought there was some
> feature where you could take a read-only thinp snapshot of an external
> volume (i.e., a pre-existing LVM2 volume, or a block device), and then
> after that, make read-write snapshots using the read-only snapshot as
> a base?  Is that something that works today, or is planned?  Or am I
> totally confused?

The commit I referenced basically provides that capability.

> And if it is something that works today, is there a web site or
> documentation file that gives a recipe for how to use it if we want to
> do some performance experiments (i.e., it doesn't have to be a user
> friendly interface if that's not ready yet).

Documentation/device-mapper/thin-provisioning.txt has details on how to
use dmsetup to create a thin device that uses a read-only external
origin volume (so all reads to unprovisioned areas of the thin device
will be remapped to the external origin -- "external" meaning the volume
outside of the thin-pool).

The creation of a thin device w/ a read-only external origin gets you
started with a thin device that is effectively a snapshot of the origin
volume.  That thin device is read-write -- all writes are provisioned
from the thin-pool that is backing the thin device.  And you can take
snapshots (or recursive snapshots) of that thin device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
