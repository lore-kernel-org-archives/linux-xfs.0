Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F0567F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 16:08:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53BDA30405F
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 14:08:03 -0800 (PST)
Received: from app1b.xlhost.de (mailout173.xlhost.de [84.200.252.173]) by
	cuda.sgi.com with ESMTP id sDFdRGxMEFUd4FPP for
	<xfs@oss.sgi.com>; Mon, 23 Nov 2015 14:08:01 -0800 (PST)
Message-ID: <56538E6A.6030203@5t9.de>
Date: Mon, 23 Nov 2015 23:08:42 +0100
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
Subject: Re: Does XFS support cgroup writeback limiting?
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
In-Reply-To: <20151123202619.GE26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/23/2015 09:26 PM, Dave Chinner wrote:
> On Mon, Nov 23, 2015 at 12:05:53PM +0100, Lutz Vieweg wrote:
>> in June 2015 the article https://lwn.net/Articles/648292/ mentioned
>> upcoming support for limiting the quantity of buffered writes
>> using control groups.
>>
>> Back then, only ext4 was said to support that feature, with other
>> filesystems requiring some minor changes to do the same.
>
> Yes, changing the kernel code to support this functionality is about
> 3 lines of code.

Oh, I didn't expect it to be such a small change :-)

> .... I haven't added support to XFS because I have no way of
> verifying the functionality works and that it continues to work as
> it is intended. i.e. we have no regression test coverage for cgroup
> aware writeback and until someone writes a set of regression tests
> that validate it's functionality works correctly it will remain this
> way.
>
> Writing code is trivial. Validating the code actually works as
> intended and doesn't silently get broken in the future is the
> hard part....

Understood, would you anyway be willing to publish such a
three-line-patch (outside of official releases) for those
daredevils (like me :-)) who'd be willing to give it a try?

After all, this functionality is the last piece of the
"isolation"-puzzle that is missing from Linux to actually
allow fencing off virtual machines or containers from DOSing
each other by using up all I/O bandwidth...

Regards,

Lutz Vieweg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
