Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E365A7FD7
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 12:35:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1C3F30404E
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 10:35:07 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dyPxwZo48v6dofSC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Nov 2015 10:35:04 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 04 Nov 2015 13:34:58 -0500
In-Reply-To: <x49twp4p11j.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 02 Nov 2015 16:02:48 -0500")
Message-ID: <x49a8qtpq99.fsf@segfault.boston.devel.redhat.com>
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
Cc: axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@ml01.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Jan Kara <jack@suse.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Jeff Moyer <jmoyer@redhat.com> writes:

>> Hence once the filesystem has waited on the REQ_WRITE|REQ_FLUSH IO
>> to complete, we know that all the earlier REQ_WRITE IOs are on
>> stable storage, too. Hence there's no need for the elevator to drain
>> the queue to guarantee completion ordering - the dispatch ordering
>> and flush/fua write semantics guarantee that when the flush/fua
>> completes, all the IOs dispatch prior to that flush/fua write are
>> also on stable storage...
>
> Des xfs rely on this model for correctness?  If so, I'd say we've got a
> problem.

Dave?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
