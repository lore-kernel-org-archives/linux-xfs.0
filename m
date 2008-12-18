Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBINcpWQ031442 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 17:38:52 -0600
Received: from partygirl.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8E3133D22
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 15:38:49 -0800 (PST)
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246]) by
	cuda.sgi.com with ESMTP id uwufA5eSLkyekVZ9 for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 15:38:49 -0800 (PST)
Message-ID: <494AD950.3030802@tmr.com>
Date: Thu, 18 Dec 2008 18:14:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	<49405A94.8080601@tmr.com> <1229225303.16555.149.camel@localhost>
	<4949645F.4030407@tmr.com>
	<alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net, Redeeman <redeeman@metanurb.dk>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
>>
>> Calls itself "WDC WD10EACS-00D" in /sys if that helps. I could dig 
>> out the packing slip if it matters. Runs nicely so far, and if the 
>> SMART temperature probe is correct, very cool:
>>
>> /dev/sda: ST3750640AS: 43 C
>> /dev/sdb: WDC WD10EACS-00D6B1: 31 C
>> /dev/sdc: ST3750640AS: 44 C
>> /dev/sdd: ST3750640AS: 46 C
>>
>> I don't totally trust the temps, there is a LOT of 18C air going into 
>> that box, because it has a lot coming out the back and side.
>
> Hmm do you have a picture of those seagates? Seems like a lack of 
> airflow there
> or do they just run really hot?  Also, how many head unload/loads has the
> 1.0TB GP drive performed, that was one of my concerns when I was 
> looking at
> disks.

How about a diagram:

__________________________________________________
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                 --empty--        |
                                 (seagate)        |
                                 (WD)             |
                                 (seagate)        | <--- case
                                 (seagate)        |
                                 --empty--        |
__________________________________________________|


That's about how the drives sit in the case, air vents are in the front 
of the case, fans in back pulling air out.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
