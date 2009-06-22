Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5MLamPr256863 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 16:36:48 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6AD0F304075
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 14:37:13 -0700 (PDT)
Message-Id: <0DCF2AFE-0839-40DE-98B6-1EF854D21EAF@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090622205904.GA1855@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH, RFC] xfs: event tracing support
Date: Mon, 22 Jun 2009 16:37:12 -0500
References: <20090616214844.GA12310@infradead.org>
	<4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
	<20090622205904.GA1855@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ia64@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com


On Jun 22, 2009, at 3:59 PM, Christoph Hellwig wrote:

> On Mon, Jun 22, 2009 at 01:01:35PM -0500, Felix Blyakher wrote:
>>> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable
>>> all
>>> xfs trace channels by:
>>>
>>>  echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
>>
>> Does event tracing work on ia64 platform?
>> I spent some time on it over weekend, but was not able even
>> to force "CONFIG_EVENT_TRACING=y" setting in the .config.
>> Seems to build ok on x86_64, which does have CONFIG_TRACING
>> in defconfig, and allows to set CONFIG_EVENT_TRACING.
>
> IA64 ftrace support was added earlier this year, but it seems it can't
> be enabled anymore since the big config option reshuffle.  Now tracing
> support requires the architecture to define the TRACE_IRQFLAGS_SUPPORT
> and STACKTRACE_SUPPORT symbols, which seems to be missing on ia64.

That's what I found.
What would it take to add ftrace support on IA64?

>> If tracing is not available on all platforms, especially
>> on ia64, which is one of preferred platforms at SGI, we need
>> to preserve the original XFS tracing facilities. I know, it'll
>> be PIA to keep both tracing methods, but we can't drop
>> the working feature without good replacement.
>
> It's not working at all in mainline and never had.  And for about
> a year thaere hasn't been any tree around that actuall supports it..

True. But with simple patch (basically restoring xfsidbg.c) and
adding kdb support I was using xfs trace successfully. I know,
it doesn't help much if it's not in the mainline, but it's
real working code. Btw, that helped me recently identify the
deadlock in xfs_growfs (xfs qa test 104). I'll post those to
the xfs list or bugzilla shortly.

I hope tracing support for ia64 could be added, and this
issue won't be a showstopper.

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
