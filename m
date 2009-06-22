Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5MKwdbD255725 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 15:58:41 -0500
Date: Mon, 22 Jun 2009 16:59:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: event tracing support
Message-ID: <20090622205904.GA1855@infradead.org>
References: <20090616214844.GA12310@infradead.org>
	<4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ia64@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com

On Mon, Jun 22, 2009 at 01:01:35PM -0500, Felix Blyakher wrote:
>> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable  
>> all
>> xfs trace channels by:
>>
>>   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
>
> Does event tracing work on ia64 platform?
> I spent some time on it over weekend, but was not able even
> to force "CONFIG_EVENT_TRACING=y" setting in the .config.
> Seems to build ok on x86_64, which does have CONFIG_TRACING
> in defconfig, and allows to set CONFIG_EVENT_TRACING.

IA64 ftrace support was added earlier this year, but it seems it can't
be enabled anymore since the big config option reshuffle.  Now tracing
support requires the architecture to define the TRACE_IRQFLAGS_SUPPORT
and STACKTRACE_SUPPORT symbols, which seems to be missing on ia64.

> If tracing is not available on all platforms, especially
> on ia64, which is one of preferred platforms at SGI, we need
> to preserve the original XFS tracing facilities. I know, it'll
> be PIA to keep both tracing methods, but we can't drop
> the working feature without good replacement.

It's not working at all in mainline and never had.  And for about
a year thaere hasn't been any tree around that actuall supports it..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
