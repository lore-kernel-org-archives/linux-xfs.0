Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BA677F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 00:03:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CEF230404E
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 22:03:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2c4FAxMbFc1fD73E for <xfs@oss.sgi.com>;
	Mon, 07 Dec 2015 22:03:46 -0800 (PST)
Date: Tue, 8 Dec 2015 17:03:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151208060343.GC19802@dastard>
References: <20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com>
	<20151202001329.GA9633@bfoster.bfoster>
	<565EAD06.5060403@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565EAD06.5060403@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 10:34:14AM +0200, Avi Kivity wrote:
> On 12/02/2015 02:13 AM, Brian Foster wrote:
> >Metadata is modified in-core and handed off to the logging
> >infrastructure via a transaction. The log is flushed to disk some time
> >later and metadata writeback occurs asynchronously via the xfsaild
> >thread.
> 
> Unless, I expect, if the log is full.  Since we're hammering on the
> disk quite heavily, the log would be fighting with user I/O and
> possibly losing.
> 
> Does XFS throttle user I/O in order to get the log buffers recycled faster?

No. XFS tags the metadata IO with REQ_META that the IO schedulers
can tell the difference between metadata and data IO, and schedule
them appropriately. Further. log buffers are also tagged with
REQ_SYNC to indicate they are latency sensitive IOs, whcih the IO
schedulers again treat differently to minimise latency in the face
of bulk async IO which is not latency sensitive.

IOWs, IO prioritisation and dispatch scheduling is the job of the IO
scheduler, not the filesystem. The filesystem just tells the
scheduler how to treat the different types of IO...

> Is there any way for us to keep track of it, and reduce disk
> pressure when it gets full?

Only if you want to make more problems for yourself - second
guessing what the filesystem is going to do will only lead you to
dancing the Charlie Foxtrot on a regular basis. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
