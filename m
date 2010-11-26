Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQMep3V206814 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 16:40:51 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C55281C78D55
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 14:42:29 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id BVzDIW2HZaNF9OCr for
	<xfs@oss.sgi.com>; Fri, 26 Nov 2010 14:42:29 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUQAYJSFOWLKPH5Z@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Fri, 26 Nov 2010 23:41:28 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUQAYINZGGLS534R@mx.isti.cnr.it> for xfs@oss.sgi.com; Fri,
	26 Nov 2010 23:41:19 +0100 (MET)
Received: from [164.132.138.155] by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUQAYFWGGYLOFEQZ@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Fri, 26 Nov 2010 23:41:18 +0100 (MET)
Date: Fri, 26 Nov 2010 23:43:26 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <4CED973B.60102@shiftmail.org>
Message-id: <4CF0380E.5000706@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <4CED973B.60102@shiftmail.org>
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
To: xfs@oss.sgi.com

On 11/24/2010 11:52 PM, Spelic wrote:
> On 11/22/2010 08:27 PM, Spelic wrote:
>> ....
>> I was doing a parallel-kernel-unpack benchmark:
>> ....
>
> I tried to reproduce it today but unfortunately I wasn't able to, not 
> even on the same hardware.
>
> The first time it happened so soon after starting such 
> parallel-kernel-unpack benchmark (at the second run!) that I was 
> confident it was possible to reproduce it easily, but today in many 
> hours it never happened again. Sorry. Unfortunately the machine is 
> going back to production soon so I'm not sure I can do further testing.


I had another smaller hangup, and unfortunately I wasn't paying 
attention. I just noticed that between a zillion runs of the "benchmark" 
taking 1 minute (for the part before the sync) I just had one that took 
2m30s for the same part. The system was absolutely idle except that test 
so I can't really see an explanation other than being another smaller 
hangup...

The good news is that it definitely came out of the hangup by itself: 
this time I didn't press Ctrl-C. So even if it was an xfs bug it doesn't 
seem fatal.

The dmesg this time showed nothing; probably because the hangup this 
time was shorter than 120 seconds so the watchdog didn't notice anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
