Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MMmVio143749 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 17:49:09 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 337D72F409
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 15:49:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 6RymcLRB1Y8TBrCR for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 15:49:46 -0700 (PDT)
Date: Thu, 22 Oct 2009 18:49:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
	<20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Wed, 21 Oct 2009, Justin Piszcz wrote:

>
>
> On Tue, 20 Oct 2009, Justin Piszcz wrote:
>
>
>> 
>> 
>> On Tue, 20 Oct 2009, Dave Chinner wrote:
>> 
>>> On Mon, Oct 19, 2009 at 06:18:58AM -0400, Justin Piszcz wrote:
>>>> On Mon, 19 Oct 2009, Dave Chinner wrote:
>>>>> On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
>>>>>> It has happened again, all sysrq-X output was saved this time.
>>>>> .....
>>>>> 
>>>>> All pointing to log IO not completing.
>>>>> 
>>> ....
>>>> So far I do not have a reproducible test case,
>>> 
>>> Ok. What sort of load is being placed on the machine?
>> Hello, generally the load is low, it mainly serves out some samba shares.
>> 
>>> 
>>> It appears that both the xfslogd and the xfsdatad on CPU 0 are in
>>> the running state but don't appear to be consuming any significant
>>> CPU time. If they remain like this then I think that means they are
>>> stuck waiting on the run queue.  Do these XFS threads always appear
>>> like this when the hang occurs? If so, is there something else that
>>> is hogging CPU 0 preventing these threads from getting the CPU?
>> Yes, the XFS threads show up like this on each time the kernel crashed.  So 
>> far
>> with 2.6.30.9 after ~48hrs+ it has not crashed.  So it appears to be some 
>> issue
>> between 2.6.30.9 and 2.6.31.x when this began happening.  Any 
>> recommendations
>> on how to catch this bug w/certain options enabled/etc?
>> 
>> 
>>> 
>>> Cheers,
>>> 
>>> Dave.
>>> -- 
>>> Dave Chinner
>>> david@fromorbit.com
>>> 
>> 
>
> Uptime with 2.6.30.9:
>
> 06:18:41 up 2 days, 14:10, 14 users,  load average: 0.41, 0.21, 0.07
>
> No issues yet, so it first started happening in 2.6.(31).(x).
>
> Any further recommendations on how to debug this issue?  BTW: Do you view 
> this
> as an XFS bug or MD/VFS layer issue based on the logs/output thus far?
>
> Justin.
>
>

Any other ideas?

Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has 
no load at all either.. Has anyone else reported similar problems?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
