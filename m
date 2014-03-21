Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B4237F83
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 18:13:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D4B4AC001
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 16:13:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TBFoEYn9FZAcTzEY for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 16:13:31 -0700 (PDT)
Message-ID: <532CC79A.8050908@sandeen.net>
Date: Fri, 21 Mar 2014 18:13:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [FAQ] XFS speculative preallocation
References: <20140321162920.GA3087@laptop.bfoster>	<87eh1vuxam.fsf@mid.deneb.enyo.de>
	<20140321231032.GC1389@dastard>
In-Reply-To: <20140321231032.GC1389@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Florian Weimer <fw@deneb.enyo.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 3/21/14, 6:10 PM, Dave Chinner wrote:
> On Fri, Mar 21, 2014 at 09:11:29PM +0100, Florian Weimer wrote:
>> * Brian Foster:
>>
>>> Although speculative preallocation can lead to reports of excess space
>>> usage, the preallocated space is not permanent unless explicitly made so
>>> via fallocate or a similar interface.
>>
>> How does an explicit allocation with posix_fallocate interact with
>> speculative preallocation?  Does it disable it?
> 
> fallocate is permanent preallocation using unwritten extents.
> Speculative preallocation is an extension of delayed allocation that
> is done when extending the file and the EOF falls into a hole. If
> there is unwritten extents beyond EOF, speulative preallocation is
> not performed.
> 
>> I see rather dramatic fragmentation of the systemd journal when it is
>> stored on XFS, and it calls posix_fallocate before writing data to the
>> file.
> 
> There's your problem - systemd is preventing delayed allocation, and
> so it fragmenting the file itself with it's write pattern.
> Basically, that's a bug in systemd, and not something the filesystem
> can avoid because userspace is directly controlling block
> allocation.

hohum, I guess we should look into this.

OTOH: nothing wrong with calling posix_fallocate() if you need the space
guarantees it provides for proper operation...

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
