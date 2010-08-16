Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G0TtCj208381 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 19:29:55 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34CA0170E91C
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 17:30:22 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id 49PvjgMZqyEMEekO for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 17:30:22 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7G0M6cT019547
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:22:06 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o7G0UFAW206828 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:30:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id o7G0UDhZ014023
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:30:15 -0600
Message-ID: <4C688691.2020100@austin.ibm.com>
Date: Sun, 15 Aug 2010 19:30:09 -0500
From: Steven Pratt <slpratt@austin.ibm.com>
MIME-Version: 1.0
Subject: Re: observed significant performance improvement using "delaylog" in
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<20100813141344.GE10429@dastard> <4C65AE4D.6070502@sandeen.net>
	(sfid-20100814_092305_493513_AC7C6900)
	<201008141328.18436.Martin@lichtvoll.de>
In-Reply-To: <201008141328.18436.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Keith Mannthey <kmannth@us.ibm.com>, Stan Hoeppner <stan@hardwarefreak.com>

Martin Steigerwald wrote:
> Hi!
>
> Cc'd Steve as I think he is running the benchmarks.
>
> Am Freitag 13 August 2010 schrieb Eric Sandeen:
>   
>> Dave Chinner wrote:
>>     
>>> On Fri, Aug 13, 2010 at 08:29:07AM -0400, Christoph Hellwig wrote:
>>>       
>> ...
>>
>>     
>>>> And asking
>>>> him/her to add -o delaylog would also be good.
>>>>         
>>> Yes, that would be an interesting comparison...
>>>       
>> I was thinking the same thing; I'll do that.
>>     
>
> I think its Steven Pratt from IBM.
>
> Steve, could you add a case for mount option "-o delaylog" to your 
> benchmark runs?
>   
Which filesystem is this for?  Keith has been helping me with some of 
these runs. We'll see if we can add this.

Steve

> ----------  Weitergeleitete Nachricht  ----------
>
> Subject: New performance results
> Date: Samstag 24 April 2010
> From: Steven Pratt <slpratt@austin.ibm.com>
> To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
>
> Well, it's been a while but been very busy on other things. Thanks to 
> Keith Mannthey for helping get some of these runs done.
>
> New raid performance on 2.6.34-rc3:
>
> http://btrfs.boxacle.net/repository/raid/2010-04-14_2004/2.6.34-
> rc3/2.6.34-rc3.html
>
> Also, the long running history graphs are here:
>
> http://btrfs.boxacle.net/repository/raid/history/History.html
>
>
> Steve
>
>
> --
> [...]
> -------------------------------------------------------
>
> Ciao,
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
