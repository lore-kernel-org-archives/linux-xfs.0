Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ENAeDB130086 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 17:10:41 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AUAb6dQEifoJ14vs
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 15:10:39 -0800 (PST)
Message-ID: <4F3AE9EA.1050609@hardwarefreak.com>
Date: Tue, 14 Feb 2012 17:10:34 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F3A5B49.6020803@cape-horn-eng.com>
In-Reply-To: <4F3A5B49.6020803@cape-horn-eng.com>
Reply-To: stan@hardwarefreak.com
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On 2/14/2012 7:02 AM, Richard Ems wrote:
> Hi Stan,
> 
> I was not subscribed to the list so I did not get your mail. I

Ahh, my bad.  I should have done a reply-all.  I sometimes forget XFS is
an open list.

> subscribed now, but apparently and admin has to aprove the subscription
> since I am not getting any confirmation email. so this will take some time.
> 
>> On 2/13/2012 10:57 AM, Richard Ems wrote:
>>> The case is connected through SCSI.
>>
>> Do you mean iSCSI?  Does the host on which you're running your "find
>> dir" command have a 1GbE or 10GbE connection to the InforTrend unit?
>> More than one connection using bonding or multipath?  Direct connected
>> or through a switch(es)?  What brand is the switch(es)?  Switch(es)
>> under heavy load?
> 
> NO. SCSI. Not iSCSI. No switches, it's direct attached through a LSI
> SCSI Controller:

Ok so it's obviously not a host bandwidth or latency issue then.  I was
just trying to cover the all the bases with my hardware questions.

Also I didn't realize anyone was (still?) offering parallel SCSI host
connections on their SATA arrays.

> lspci shows:
> 
> LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI

PCI-X?  So this host and array have a few years on them I assume.

>> Also check the performance data in the management interface on the
>> InforTrend unit to see if you're hitting any limits there (if it has
>> such a feature).  RAID6 is numerically intensive and that particular
>> controller may not have the ASIC horsepower to keep up with the IOPS
>> workload you're throwing at it.
> 
> There is no performance data in the management interface to check.

Ok, so this is a relatively basic, entry level array?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
