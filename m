Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84EBD7F87
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 03:12:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DB67AC002
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 01:12:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gQTxls91ncv4r6CV for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 01:12:22 -0800 (PST)
Date: Sat, 9 Mar 2013 20:11:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130309091152.GH23616@dastard>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513A350A.508@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On Fri, Mar 08, 2013 at 12:59:22PM -0600, Stan Hoeppner wrote:
> On 3/8/2013 6:20 AM, Ric Wheeler wrote:
> > On 03/08/2013 03:39 AM, Stan Hoeppner wrote:
> >> On 3/6/2013 5:12 PM, Ric Wheeler wrote:
> >>
> >>> We actually test brutal "Power off" for xfs, ext4 and other file
> >>> systems. If your storage is configured properly and you have barriers
> >>> enabled, they all pass without corruption.
> 
> I think you missed the context.  Please reread this:
> 
> >> Something that none of us mentioned WRT write barriers is that while the
> >> filesystem structure may avoid corruption when the power is cut, files
> >> may still be corrupted, in conditions such as any/all of these:
> 
> I made it very clear I was discussing file corruption here, not
> filesystem corruption.  You already covered that base.  I was
> specifically addressing the fact that XFS performs barriers on metadata
> writes but not file data writes.

Actually, you're not correct there, either, Stan. ;)

XFS only issues cache flushes/FUA writes for log IO. Metadata IO is
done exactly the same way that data IO is done - without barriers.
It's because metadata lost in drive caches at the time of a crash is
rewritten by journal replay that filesystem corruption does not
occur.

As it is, if the application uses direct IO (likely, as it
sounds like video capture/editing/playout here) then log IO
will also ensure that the data written by the app is on disk (i.e.
that's ithe mechanism by which fsync works).

Hence even assumptions that there will be data loss are dependent on
how the application is doing it's IO....

> > Also, if there are active writers, this is inherently racy. A better
> > script would unmount the file systems :)
> 
> Yes, a umount would be even better.

Change the bios so that the power button does not cause a power down
so the OS can capture the button event and trigger an orderly
shutdown. Laptops use power button events for all sorts of different
things (e.g. suspend rather than shutdown) and you can do exactly
the same sort of event triggered shutdown for any server or
desktop...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
