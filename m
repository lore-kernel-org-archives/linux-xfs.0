Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GGHSqK095354 for <xfs@OSS.SGI.com>; Fri, 16 Mar 2012 11:17:28 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id QwjrG0SntawYfyv6 for
	<xfs@OSS.SGI.com>; Fri, 16 Mar 2012 09:17:26 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20323.12382.695317.414302@tree.ty.sabi.co.UK>
Date: Fri, 16 Mar 2012 12:21:50 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
In-Reply-To: <3633779.GerkmFcqtU@saturn>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
	<3633779.GerkmFcqtU@saturn>
From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>

[ ... ]

>> If you were in my place with the resource constraints, you'd
>> go with: xfs with barriers on top of mdraid10 with device
>> cache ON and setting vm/dirty_bytes, vm/dirty_background_bytes,
>> vm/dirty_expire_centisecs, vm/dirty_writeback_centisecs to
>> safe values

> If you ever experienced a crash where lots of sensible and
> important data were lost, you would not even think about
> "device cache ON".

It is not as simple as that... *If* hw barriers are implemented
*and* applications do the right things, that is not a concern.
Disabling the device cache is just a way to turn barriers on for
everything. Indeed the whole rationale for having the 'barrier'
option is to let the device caches on, and the OP did ask how to
test that barriers actually work.

Since even most consumers level drives currently implement
barriers correctly, the biggest problem today, as per the
O_PONIES discussions, is applications that don't do the right
thing, and therefore the biggest risk is large amounts of dirty
pages in system memory (either NFS client or server), not in the
drive caches.

Since the Linux flusher parameters are/have been demented, I
have seen one or more GiB of dirty pages in system memory (on
hosts I didn't configure...), which also causes performance
problems.

Again, as a crassly expedient thing, working around the lack of
"do the right thing" in applications by letting only a few
seconds of dirty pages accumulate in system memory seems to fool
enough users (and many system administrators and application
developers) into thinking that stuff is "safe". It worked well
enough for 'ext3' for many years, quite regrettably.

  Note: 'ext3' has also had the "helpful" issue of excessive
  impact of flushing, which made 'fsync' performance terrible,
  but improved the apparent safety for "optimistic" applications.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
