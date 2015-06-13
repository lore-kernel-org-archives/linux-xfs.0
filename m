Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 912D47F5D
	for <xfs@oss.sgi.com>; Sat, 13 Jun 2015 08:55:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38075AC001
	for <xfs@oss.sgi.com>; Sat, 13 Jun 2015 06:55:09 -0700 (PDT)
Received: from zimbra.skylable.com (zimbra.skylable.com [5.35.252.9]) by
	cuda.sgi.com with ESMTP id id7wXlRSJTlcYdT0 for
	<xfs@oss.sgi.com>; Sat, 13 Jun 2015 06:55:07 -0700 (PDT)
Message-ID: <557C3638.1020903@skylable.com>
Date: Sat, 13 Jun 2015 16:55:04 +0300
From: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>
	<5579AE85.5080203@sandeen.net>	<5579B034.4070503@sandeen.net>
	<5579B804.9050707@skylable.com>	<20150612122108.GB60661@bfoster.bfoster>	<557AD4D4.3010901@skylable.com>
	<20150612135404.GC60661@bfoster.bfoster>,
	<557B3EDD.3030502@sandeen.net>
	<BLUPR04MB593340A765596780F266454F2BB0@BLUPR04MB593.namprd04.prod.outlook.com>
In-Reply-To: <BLUPR04MB593340A765596780F266454F2BB0@BLUPR04MB593.namprd04.prod.outlook.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Karanvir Singh <karanvir.singh@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 06/13/2015 01:52 AM, Dave Chinner wrote:
> Yup, that's looking like a toolchain bug. Thread about arm directory
> read corruption:
> 
> http://oss.sgi.com/archives/xfs/2013-02/msg00505.html
> 
> cross-gcc version results:
> 
> http://oss.sgi.com/archives/xfs/2013-02/msg00563.html
> 
> "A quick rundown:
>   -cross-gcc4.4:  OK
>   -cross-gcc4.5:  OK
>   -cross-gcc4.6:  BAD
>   -cross-gcc4.7:  BAD
>   -cross-gcc4.8:  OK"
> 

Just tested the new kernels, they're both good:

GOOD: 3.14.3-std-00094-g9035cb4, gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-12ubuntu1)
GOOD: 3.14.44-std-00095-g0425932, gcc version 4.9.2 (4.9.2-10)
BAD: 3.14.3-00088-g7651c68, gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)


On 06/12/2015 03:21 PM, Brian Foster wrote:
> I echo Dave's suggestion down thread with regard to toolchain. This
> kernel was compiled with the following cross-gcc (installed via Fedora
> package):
> 
> 	gcc version 4.9.2 20150212 (Red Hat Cross 4.9.2-5) (GCC) 
> 
> Are you using something different?
> 
> Brian

Indeed, it looks like a compiler bug, thanks a lot for helping me track it down.
I'll see if I can find out more about whats different between the two kernels compiled by 4.6 and 4.7.

On 06/13/2015 12:41 AM, Karanvir Singh wrote:
> 
> Hi Edwin,
> 
> 
> PFA the  newer uimages: 
> 
> uImage3.14.44.gcc.4.9.2:  its a 3.14.44 compiled with gcc 4.9.4 
> uImage.gcc.4.7.2-1: its 3.14.3 compiled with gcc 4.7.2

Thanks, both of these images work correctly: I was not able to reproduce the bug with them (rebooting to the original uImage 3.14.3 with gcc 4.6.3 reproduces bug immediately).

Best regards,
--Edwin


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
