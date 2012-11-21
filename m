Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALIavP1082809 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 12:36:57 -0600
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074123.24645.41965.stgit@blackbox.djwong.org>
	<20121121100809.GE23339@infradead.org>
	<x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
	<20121121182901.GA4519@infradead.org>
Date: Wed, 21 Nov 2012 13:38:55 -0500
In-Reply-To: <20121121182901.GA4519@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 13:29:01 -0500")
Message-ID: <x49y5huu7gg.fsf@segfault.boston.devel.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
>> > I'd like to use this as a vehicle to revisit how dio completions work.
>> 
>> I don't like the sound of that.  ;-)  It sounds like this bugfix may get
>> further delayed by the desire for unrelated code cleanup.
>
> I've got a prototype that isn't much more invasive than the current
> series.  I'll finish it up and run it through QA and will post it
> tomorrow.

Works for me.  Thanks!

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
