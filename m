Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E52C7F6A
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 11:44:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A8BD304051
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 09:44:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ei0xRzXqEiVYHm0C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 09:44:00 -0700 (PDT)
Date: Thu, 23 Jul 2015 12:43:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150723164358.GA24562@redhat.com>
References: <20150720223610.GV7943@dastard> <55AE6670.40903@redhat.com>
	<20150721174753.GA8563@redhat.com> <20150722000923.GB7943@dastard>
	<20150722010056.GC7943@dastard> <20150722014029.GA10628@redhat.com>
	<20150722023711.GD7943@dastard> <20150722133451.GB16842@redhat.com>
	<55AFC496.4000009@redhat.com> <20150723051043.GB3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150723051043.GB3902@dastard>
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
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Thu, Jul 23, 2015 at 03:10:43PM +1000, Dave Chinner wrote:

[..]
> I don't think knowing the bdev timeout is necessary because the
> default is most likely to be "fail fast" in this case. i.e. no
> retries, just shut down.  IOWs, if we describe the configs and
> actions in neutral terms, then the default configurations easy for
> users to understand. i.e:
> 
> bdev enospc		XFS default
> -----------		-----------
> Fail slow		Fail fast
> Fail fast		Fail slow
> Fail never		Fail never, Record in log
> EOPNOTSUPP		Fail never
> 
> With that in mind, I'm thinking I should drop the
> "permanent/transient" error classifications, and change it "failure
> behaviour" with the options "fast slow [never]" and only the slow
> option has retry/timeout configuration options.  I think the "never"
> option still needs to "fail at unmount" config variable, but we
> enable it by default rather than hanging unmount and requiring a
> manual shutdown like we do now....

I am wondering instead of 4 knobs (fast,slow,never,retry-timeout) can
we just do with one knob per error type and that is retry-timout.

retry-timeout=0 (Fail fast)
retry-timeout=X (Fail slow)
retry-timeout=-1 (Never Give up).

Also do we really need this timeout per error type.

Also would be nice if this timeout was configurable using a mount
option. Then we can just specify it during mount time and be done
with it.

Idea of auto tuning based on what block device is doing sounds reasonable
but that should not be a requirement for this patch and can go in even
later. It is one of those nice to have features.

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
