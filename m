Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCDEC7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:39:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5138EAC005
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:39:52 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FDxTcHpvPsq4TMmN for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 13:39:50 -0800 (PST)
Date: Wed, 2 Dec 2015 08:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201213936.GA19199@dastard>
References: <20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com> <20151201210417.GY19199@dastard>
	<CAD-J=zbZdWkJ8sfJHyKmQTZYVvLFbqbbEbWo2HV25jnZyrfTaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD-J=zbZdWkJ8sfJHyKmQTZYVvLFbqbbEbWo2HV25jnZyrfTaA@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 04:10:45PM -0500, Glauber Costa wrote:
> On Tue, Dec 1, 2015 at 4:04 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
> >> On 12/01/2015 04:56 PM, Brian Foster wrote:
> >> mount -o discard.  And yes, overwrites are supposedly more expensive
> >> than trim old data + allocate new data, but maybe if you compare it
> >> with the work XFS has to do, perhaps the tradeoff is bad.
> >
> > Oh, you do realise that using "-o discard" causes significant delays
> > in journal commit processing? i.e. the journal commit completion
> > blocks until all the discards have been submitted and waited on
> > *synchronously*. This is a problem with the linux block layer in
> > that blkdev_issue_discard() is a synchronous operation.....
> >
> > Hence if you are seeing delays in transactions (e.g. timestamp updates)
> > it's entirely possible that things will get much better if you
> > remove the discard mount option. It's much better from a performance
> > perspective to use the fstrim command every so often - fstrim issues
> > discard operations in the context of the fstrim process - it does
> > not interact with the transaction subsystem at all.
> 
> Hi Dave,
> 
> This is news to me.
> 
> However, in the disk that we have used during the acquisition of this
> trace, discard doesn't seem to be supported:
> $ sudo fstrim /data/
> fstrim: /data/: the discard operation is not supported
> 
> In that case, if I understand correctly the discard mount option
> should be a noop, no?

XFS still makes the blkdev_issue_discard() calls, though, because
the block device can turn discard support on and off dynamically.
e.g. raid devices where a faulty drive is replaced temporarily with
a drive that doesn't have discard support. The block device suddenly
starts returning -EOPNOTSUPP to the filesystem from
blkdev_issue_discard() calls. However, the admin then replaces that
drive with a new one that des have discard support, and now
blkdev_issue_discard() works as exepected.

IOWs, if you set the mount option, XFS will always attempt to issue
discards...

> That recommendation is great for our general case, though.

For the moment. Given lots of time, reworking this code could
greatly reduce the impact/overhead of it and so make it practical to
enable. There's a lot of work to get to that point, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
