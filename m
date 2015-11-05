Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80B967F8D
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 13:49:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD9B0AC001
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 11:49:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3QyEVUC55SHGagLy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 11:49:28 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
	<20151105083309.GJ19199@dastard>
Date: Thu, 05 Nov 2015 14:49:21 -0500
In-Reply-To: <20151105083309.GJ19199@dastard> (Dave Chinner's message of "Thu,
	5 Nov 2015 19:33:09 +1100")
Message-ID: <x498u6crzum.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nvdimm@ml01.01.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Dave Chinner <david@fromorbit.com> writes:

>> But this part is not.  It is up to the I/O scheduler to decide when to
>> dispatch requests.  It can hold on to them for a variety of reasons.
>> Flush requests, however, do not go through the I/O scheduler.  At the
>
> That's pure REQ_FLUSH bios, right? Aren't data IOs with
> REQ_FLUSH|REQ_FUA sorted like any other IO?

No, they also go through the flush machinery, and so short-circuit the
I/O scheduler.

>> Des xfs rely on this model for correctness?  If so, I'd say we've got a
>> problem
>
> No, it doesn't. The XFS integrity model doesn't trust the IO layers
> to tell the truth about IO ordering and completion or for it's
> developers to fully understand how IO layer ordering works. :P
>
> i.e. we wait for full completions of all dependent IO before issuing
> flushes or log writes that use REQ_FLUSH|REQ_FUA semantics to ensure
> the dependent IOs are fully caught by the cache flushes...

OK, phew!  ;-)

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
