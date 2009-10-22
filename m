Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MMwiPC144549 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 17:58:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED8B42EF99
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 16:00:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	7rKzspycaCoiKeKK for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2009 16:00:18 -0700 (PDT)
Date: Fri, 23 Oct 2009 10:00:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
Message-ID: <20091022230010.GE9464@discord.disaster>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
	<20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
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
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 22, 2009 at 06:49:46PM -0400, Justin Piszcz wrote:
> On Wed, 21 Oct 2009, Justin Piszcz wrote:
>> On Tue, 20 Oct 2009, Justin Piszcz wrote:
>>>> It appears that both the xfslogd and the xfsdatad on CPU 0 are in
>>>> the running state but don't appear to be consuming any significant
>>>> CPU time. If they remain like this then I think that means they are
>>>> stuck waiting on the run queue.  Do these XFS threads always appear
>>>> like this when the hang occurs? If so, is there something else that
>>>> is hogging CPU 0 preventing these threads from getting the CPU?
>>> Yes, the XFS threads show up like this on each time the kernel 
>>> crashed.  So far
>>> with 2.6.30.9 after ~48hrs+ it has not crashed.  So it appears to be 
>>> some issue
>>> between 2.6.30.9 and 2.6.31.x when this began happening.  Any  
>>> recommendations
>>> on how to catch this bug w/certain options enabled/etc?
>>
>> Uptime with 2.6.30.9:
>>
>> 06:18:41 up 2 days, 14:10, 14 users,  load average: 0.41, 0.21, 0.07
>>
>> No issues yet, so it first started happening in 2.6.(31).(x).

Ok.

>> Any further recommendations on how to debug this issue?  BTW: Do
>> you view this as an XFS bug or MD/VFS layer issue based on the
>> logs/output thus far?

Could be either. Nothing so far points at a cause.

> Any other ideas?

If it is relatively quick to reproduce, you could run a git bisect
to try to find the offending commit. Or when it has locked up, run
oprofile with callgraph sampling and so we can get an idea of what
is actually running when XFS appears to hang.

> Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has  
> no load at all either.. Has anyone else reported similar problems?

Not that I know of.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
