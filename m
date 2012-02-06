Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16AeX0Z122812 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 04:40:33 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id lmTvRoj7gyBNXZY2 for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 02:40:31 -0800 (PST)
Date: Mon, 6 Feb 2012 10:40:24 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120206104024.GA4975@nsrc.org>
References: <20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org> <20120203115434.GA649@nsrc.org>
	<4F2C38BE.2010002@hardwarefreak.com> <20120203221015.GA2675@nsrc.org>
	<4F2D016C.9020406@hardwarefreak.com> <20120204112436.GA3167@nsrc.org>
	<4F2D2953.2020906@hardwarefreak.com> <20120204200417.GA3362@nsrc.org>
	<4F2D98A9.4090709@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2D98A9.4090709@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 04, 2012 at 03:44:25PM -0500, Joe Landman wrote:
> >Sure it can. A gluster volume consists of "bricks". Each brick is served by
> >a glusterd process listening on a different TCP port. Those bricks can be on
> >the same server or on different servers.
> 
> I seem to remember that the Gluster folks abandoned this model
> (using their code versus MD raid) on single servers due to
> performance issues.  We did play with this a few times, and the
> performance wasn't that good.  Basically limited by single disk
> seek/write speed.

I did raise the same question on the gluster-users list recently and there
seemed to be no clear-cut answer; some people were using Gluster to
aggregate RAID nodes, and some were using it to mirror individual disks
between nodes.

I do like the idea of having individual filesystems per disk, making data
recovery much more straightforward and allowing for efficient
parallelisation.

However I also like the idea of low-level RAID which lets you pop out and
replace a disk invisibly to the higher levels, and is perhaps better
battle-tested than gluster file-level replication.

> RAID in this case can protect you from some of these issues (single
> disk failure issues, being replaced by RAID issues), but unless you
> are building mirror pairs of bricks on separate units, this magical
> "automatic" isn't quite so.

That was the idea: having mirror bricks on different nodes.

server1:/brick1 <-> server2:/brick1
server2:/brick2 <-> server2:/brick2 etc

> Moreover, last I checked, Gluster made no guarantees as to the
> ordering of the layout for mirrors.  So if you have more than one
> brick per node, and build mirror pairs with the "replicate" option,
> you have to check the actual hashing to make sure it did what you
> expect.  Or build up the mirror pairs more carefully.

AFAICS it does guarantee the ordering:
http://download.gluster.com/pub/gluster/glusterfs/3.2/Documentation/AG/html/sect-Administration_Guide--Setting_Volumes-Distributed_Replicated.html

"Note: The number of bricks should be a multiple of the replica count for a
distributed replicated volume. Also, the order in which bricks are specified
has a great effect on data protection. Each replica_count consecutive bricks
in the list you give will form a replica set, with all replica sets combined
into a volume-wide distribute set. To make sure that replica-set members are
not placed on the same node, list the first brick on every server, then the
second brick on every server in the same order, and so on."

> At this point, it sounds like there is a gluster side of this
> discussion that I'd recommend you take to the gluster list.  There
> is an xfs portion as well which is fine here.

Understood. Whatever the final solution looks like, I'm totally sold on XFS.

> Disclosure:  we build/sell/support gluster (and other) based systems
> atop xfs based RAID units (both hardware and software RAID;
> 1,10,6,60,...) so we have inherent biases.

You have also inherent experience, and that is extremely valuable as I try
to pick the best storage model which will work for us going forward.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
