Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 243107CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:09:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16E4C304043
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 09:09:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id puEIagBe0MiZ3Onu for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 09:09:23 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 29CA263C3D46
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:09:23 -0600 (CST)
Subject: Re: [PATCH 6/9] xfs: add "fail at unmount" error handling
	configuration
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
	<1454635407-22276-7-git-send-email-david@fromorbit.com>
	<20160216164451.GC39655@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C357C2.9020506@sandeen.net>
Date: Tue, 16 Feb 2016 11:09:22 -0600
MIME-Version: 1.0
In-Reply-To: <20160216164451.GC39655@bfoster.bfoster>
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
To: xfs@oss.sgi.com



On 2/16/16 10:44 AM, Brian Foster wrote:
> On Fri, Feb 05, 2016 at 12:23:24PM +1100, Dave Chinner wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> > 
>> > If we take "retry forever" literally on metadata IO errors, we can
>> > hang an unmount retries those writes forever. This is the default
>> > behaviour, unfortunately. Add a error configuration option for this
>> > behaviour and default it to "fail" so that an unmount will trigger
>> > actual errors, a shutdown and allow the unmount to succeed. It will
>> > be noisy, though, as it will log the errors and shutdown that
>> > occurs.
>> > 
>> > To do this, we need to mark the filesystem as being in the process
>> > of unmounting. Do this with a mount flag that is added at the
>> > appropriate time (i.e. before the blocking AIL sync). We also need
>> > to add this flag if mount fails after the initial phase of log
>> > recovery has been run.
>> > 
>> > The config is done by a separate boolean sysfs option rather than a
>> > new fail_speed enum, as fail_at_unmount is relevant to both
>> > XFS_ERR_FAIL_NEVER and XFS_ERR_FAIL_SLOW options.
>> > 
>> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> > ---
> Similar question of scope/granularity here... why would one want to set
> this option for a particular error and not any others? In other words,
> it seems more useful as a global (or per-mount) option.

I guess my question here is higher-level than that.  Why make this
(fail_at_unmount) configurable at all.  When would one *want* unmount
blocked by pending failure retries?

I guess I could imagine it as sort of a safety net, "I told it to retry
for a day, and the day's not up yet, so we shouldn't stop trying
just because I said unmount!" - but that seems a bit contrived to me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
