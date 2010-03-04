Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24DDmNx168979 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 07:13:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF9881D12C45
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 05:15:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	t1XHJluAHsrsDXxp for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 05:15:14 -0800 (PST)
Date: Fri, 5 Mar 2010 00:15:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100304131511.GH14317@discord.disaster>
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B8FA2CD.6010904@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 01:08:45PM +0100, Michael Weissenbacher wrote:
> Hi Dave!
>> Can you run the trace through ksymoops so that we get function names
>> rather than numbers that don't mean anything?
> I've never done that before. Could you point me to an howto about this?

I've never needed to use it myself, so all I'd be doing is reading
the man page and doing a google search to answer your question. It's
way past my bed time here, so I'll leave that to you for the
moment - try searching for "ksymoops howto"....

>> Also, can you tell us what kernel version and distro you are
>> running, as well as the version of xfs_fsr? These will help tell us
>> if it is a new or known problem.
> The Kernel version is 2.6.33 vanilla (self-compiled), Distro is Gentoo  
> Linux, xfs_fsr Version is 3.1.1 (also self-compiled).

Ok, so it's all pretty recent then.

> Please let me know if you need anything else.

Was there anything else in the logs prior to the oops messages
that might indicate errors were occurring?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
