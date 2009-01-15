Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0FIxS0r017951 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 12:59:28 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2B64304064
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 10:59:24 -0800 (PST)
Message-ID: <496F878C.80905@sgi.com>
Date: Thu, 15 Jan 2009 12:59:24 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump support for 64K page size
References: <4964C5EF.3060308@sgi.com> <4965629C.2000703@sgi.com>
	<20090108222800.GG9448@disturbed> <4967A73E.9020907@sgi.com>
	<20090114224857.GA8071@disturbed>
In-Reply-To: <20090114224857.GA8071@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On 01/14/2009 04:48 PM, Dave Chinner wrote:
> On Fri, Jan 09, 2009 at 01:36:30PM -0600, Bill Kendall wrote:
>> Dave Chinner wrote:
>>> BTW, these changes are the *exact* patches I sent back in March.
>>> I note that the change logs from those patches have been dropped
>>> on the floor. i.e.:
>> Right, only difference is that I removed the asserts rather than
>> just having them commented out. In my determination the asserts
>> are totally bogus -- there isn't a dependency on the system's
>> page size in the inomap code.
> 
> .....
> 
>> The inomap code uses xfsdump's PGSZ variable, which is fixed at 4K.
>> There's no dependency here on the system's actual page size. I was
>> able to dump and then restore on a system with a different page size.
> 
> Ok, that looks fine. however, there is a dependency that HNKSZ >=
> PGSZ, right? And that is currently hardwired to (4 * PGSZ)?

I don't think so, or at least I'm not making the connection. HNKSZ
need only be large enough to contain at least one seg_t plus the
bookkeeping info in a hnk_t. Lookups are more efficient with a few
large hunks compared to many small ones though, and since the list
of hunks will be memory mapped it made sense to make HNKSZ at least
as large as a page (the granularity of a mmap operation, IIRC).

Now with 64K pages, inomap lookups could be made more efficient by
increasing HNKSZ, but at the expense of breaking the dump format.
If/when it is okay to do that, I think it would be simpler to do
away with the list of hnk_t's, and just have a single array (or
other container) with all the seg_t's.

> 
> And given that the intent of the PGSZ was to be made variable at
> some point, isn't this really trying to ensure that HNKSZ is always
> greater than the PGSZ the program was built with?

Good point about PGSZ being variable. Since HNKSZ must remain constant
to keep the dump format unchanged, that implies it should not be based
on PGSZ. At a quick glance I see that other structures in the dump format
are based on PGSZ as well, so really the whole use of PGSZ needs to be
reviewed.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
