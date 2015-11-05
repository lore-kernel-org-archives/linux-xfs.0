Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E92E17F69
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 14:54:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87CBFAC001
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 12:54:23 -0800 (PST)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	1XbSe6GxNEZRJLNk (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 12:54:21 -0800 (PST)
Received: by iodd200 with SMTP id d200so103536260iod.0
	for <xfs@oss.sgi.com>; Thu, 05 Nov 2015 12:54:21 -0800 (PST)
Subject: Re: [RFC 00/11] DAX fsynx/msync support
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
	<20151105083309.GJ19199@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <563BC1FB.60004@kernel.dk>
Date: Thu, 5 Nov 2015 13:54:19 -0700
MIME-Version: 1.0
In-Reply-To: <20151105083309.GJ19199@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On 11/05/2015 01:33 AM, Dave Chinner wrote:
>> Des xfs rely on this model for correctness?  If so, I'd say we've got a
>> problem
>
> No, it doesn't. The XFS integrity model doesn't trust the IO layers
> to tell the truth about IO ordering and completion or for it's
> developers to fully understand how IO layer ordering works. :P

That's good, because the storage developers simplified the model so that 
fs developers would be able to get and use it.

> i.e. we wait for full completions of all dependent IO before issuing
> flushes or log writes that use REQ_FLUSH|REQ_FUA semantics to ensure
> the dependent IOs are fully caught by the cache flushes...

... which is what you are supposed to do, that's how it works.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
