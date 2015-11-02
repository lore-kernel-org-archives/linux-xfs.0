Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F47829DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 08:22:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D28F8F8033
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 06:22:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nDSXQs6lHv8cxaUK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 06:22:22 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
Date: Mon, 02 Nov 2015 09:22:15 -0500
In-Reply-To: <20151101232948.GF10656@dastard> (Dave Chinner's message of "Mon,
	2 Nov 2015 10:29:48 +1100")
Message-ID: <x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Dave Chinner <david@fromorbit.com> writes:

> Further, REQ_FLUSH/REQ_FUA are more than just "put the data on stable
> storage" commands. They are also IO barriers that affect scheduling
> of IOs in progress and in the request queues.  A REQ_FLUSH/REQ_FUA
> IO cannot be dispatched before all prior IO has been dispatched and
> drained from the request queue, and IO submitted after a queued
> REQ_FLUSH/REQ_FUA cannot be scheduled ahead of the queued
> REQ_FLUSH/REQ_FUA operation.
>
> IOWs, REQ_FUA/REQ_FLUSH not only guarantee data is on stable
> storage, they also guarantee the order of IO dispatch and
> completion when concurrent IO is in progress.

This hasn't been the case for several years, now.  It used to work that
way, and that was deemed a big performance problem.  Since file systems
already issued and waited for all I/O before sending down a barrier, we
decided to get rid of the I/O ordering pieces of barriers (and stop
calling them barriers).

See commit 28e7d184521 (block: drop barrier ordering by queue draining).

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
