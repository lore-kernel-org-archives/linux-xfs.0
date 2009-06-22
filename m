Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5MI1BOR248518 for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 13:01:11 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 303B1AC02D
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2009 11:01:36 -0700 (PDT)
Message-Id: <4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090616214844.GA12310@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH, RFC] xfs: event tracing support
Date: Mon, 22 Jun 2009 13:01:35 -0500
References: <20090616214844.GA12310@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com


On Jun 16, 2009, at 4:48 PM, Christoph Hellwig wrote:

> Convert the old xfs tracing support that could only be used with the  
> out
> of tree kdb and xfsidbg patches to use the generic event tracer.
>
> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable  
> all
> xfs trace channels by:
>
>   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

Does event tracing work on ia64 platform?
I spent some time on it over weekend, but was not able even
to force "CONFIG_EVENT_TRACING=y" setting in the .config.
Seems to build ok on x86_64, which does have CONFIG_TRACING
in defconfig, and allows to set CONFIG_EVENT_TRACING.

If tracing is not available on all platforms, especially
on ia64, which is one of preferred platforms at SGI, we need
to preserve the original XFS tracing facilities. I know, it'll
be PIA to keep both tracing methods, but we can't drop
the working feature without good replacement.

Hope, though, that I missed something on ia64, and it's
fixable.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
