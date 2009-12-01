Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1NvmkT180634 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 17:57:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7681C14EEC63
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 15:58:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Ax5myaZhRpOciGXm for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 15:58:16 -0800 (PST)
Date: Wed, 2 Dec 2009 10:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31.6: XFS DEBUG: Assertions cause kernel OOPS.
Message-ID: <20091201235803.GK30608@discord.disaster>
References: <alpine.DEB.2.00.0911300819010.20343@p34.internal.lan>
	<20091130233818.GE30608@discord.disaster>
	<alpine.DEB.2.00.0912011338000.1185@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912011338000.1185@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 01, 2009 at 01:39:06PM -0500, Justin Piszcz wrote:
>
>
> On Tue, 1 Dec 2009, Dave Chinner wrote:
>
>> On Mon, Nov 30, 2009 at 08:22:03AM -0500, Justin Piszcz wrote:
>>> Hi,
>>>
>>> I wanted to compile my kernel with DEBUG for XFS and also kernel frame pointers
>>> to catch any issues.
>>>
>>> However, DEBUG for XFS does more harm than good?
>>
>> DEBUG is there for developers, not end users. Often the debug code
>> will assert fail or panic where the situation is not fatal but
>> indicative of some problem that should be looked into further.
> Dave,
>
> Recall that issue that I was having with asterisk installed?

Yes, it appeared to be caused by log IO not completing, right?

> How should  
> one get more information on a filesystem lockup if we cannot have debug  
> enabled for the filesystem?

The debug code in XFS won't tell you anything extra about a lock-up
unless it trips an ASSERT before the lockup that is related to the
lock-up. My experience with hangs like the above are that they
generally are not related to the filesystem at all; most of the time
it is IO not being completed by the lower layers for some reason,
and no amount of filesystem level debug will help solve that
problem.

> Should there be a user-debug option which it 
> will include more verbosity if/when the xfs kernel processes lockup?

See /proc/sys/fs/xfs/error_level. That can turn up the verbosity of
error reporting without needing DEBUG compiled in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
