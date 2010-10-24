Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9O2CgEp083673 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 21:12:43 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 174A511F520
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 19:13:58 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oe0LAG3FgtGEEu7z
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 19:13:58 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5F6A16C102
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 21:13:58 -0500 (CDT)
Message-ID: <4CC39666.3050900@hardwarefreak.com>
Date: Sat, 23 Oct 2010 21:13:58 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS use within multi-threaded apps
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>	<87eibm4xon.fsf@willster.local.flamingspork.com>	<AANLkTikqHvSmr=WSZ3t8m3wKOGcUmQQ1v9Qx9MqGArS+@mail.gmail.com>	<19651.15840.54770.942761@tree.ty.sabi.co.uk>	<AANLkTikcgqA_cPLyMOXkgbu_PLkZRQ7qmch+LZdp_L6H@mail.gmail.com>
	<AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>
In-Reply-To: <AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>
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
To: xfs@oss.sgi.com

Angelo McComis put forth on 10/23/2010 4:01 PM:
> Correction:
> 
> 
>> They quoted as having 10+TB databases running OLTP transactions on XFS,
>> with 4-5GB/sec sustained throughput to the disk system.  And 20-30TB for
>> data warehouse type
>>
> 
> They quoted having 10+TB databases running OLTP on EXT3 with 4-5GB/sec
> sustained throughput (not XFS).

Given the data rate above, this sounds like they're quoting a shared
nothing data model on a cluster, not a single host setup.  You are
interested in a single host setup, correct?

Did you ask for a contact at their customer's organization so you could
at least attempt to verify these performance claims?  Or did they state
these numbers are from an internal test system?  With no way for you to
verify these claims, they are, literally, worthless, as this vendor is
asking you to take their claims on faith.  Faith is for religion, not a
business transaction.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
