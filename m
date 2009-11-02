Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2Ljwt1095854 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 15:45:58 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FCF41D8BF43
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 13:46:10 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id WEj9GQz1DvfjSksc for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 13:46:10 -0800 (PST)
Date: Mon, 2 Nov 2009 16:46:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910281915400.29166@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
	<20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
	<alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
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



On Mon, 26 Oct 2009, Justin Piszcz wrote:

>
>
> On Thu, 22 Oct 2009, Justin Piszcz wrote:
>
>> 
>> Any other ideas?
>> 
>> Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has no 
>> load at all either.. Has anyone else reported similar problems?
>> 
>> Justin.
>> 
>
> --
>
> Currently running 2.6.31-rc1 for 2 days now, no crashes, will go to -rc2 
> later today and wait another 48 hours.
>
> Justin.
>
>

Kernel report:

2.6.31-rc1: no crash - uptime 2+ days
2.6.31-rc2: no crash - uptime 2+ days
2.6.31-rc3: no crash - uptime 2+ days
2.6.31-rc4: no crash but network kept dropping out
2.6.31-rc5: cannot test, service owner needs host available
2.6.31-rc6: cannot test, service owner needs host available
2.6.31-rc7: cannot test, service owner needs host available
2.6.31-rc8: cannot test, service owner needs host available
2.6.31-rc9: cannot test, service owner needs host available
   2.6.31.x: locks up D-state

It would be somewhere between -rc4 and 2.6.31.x.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
