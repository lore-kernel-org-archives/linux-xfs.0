Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q713tpmw244689 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 22:55:51 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oyhtvTzBLVxHiz81
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 20:55:50 -0700 (PDT)
Message-ID: <5018A8C7.8050406@hardwarefreak.com>
Date: Tue, 31 Jul 2012 22:55:51 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: realtime section bugs still around
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
	<CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
	<50186E51.1020107@hardwarefreak.com>
	<CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
In-Reply-To: <CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
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
To: Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

On 7/31/2012 6:55 PM, Jason Newton wrote:
> On Tue, Jul 31, 2012 at 4:46 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:
> 
>> On 7/31/2012 6:01 PM, Jason Newton wrote:
>>
>>> I'm still interested in finding out why streaming a few hundred MB to
>> disk
>>> has so much over head in comparison to the calculations I do in
>> userspace,
>>
>> 1.  md eats a lot of cycles at high data rates
>>
> 
> md with intel's raid0?  I stopped using linux/softraid, but  I've read
> intel's is a mix between hardware and software raid...

Intel Matrix RAID is fakeraid.  Designed for consumer workloads.  You're
shoving a decidedly non consumer, high b/w IO stream through it.  Don't
expect much.  In fact I'm surprised you're using consumer grade gear for
this application.  You are designing this software/system for a
commercial use case, correct?  If so I'd get some better hardware.

CPU overhead for fakeraid will be similar to md/RAID, depending on the
vendor and implementation.  In some cases it may be much higher than md.

> 2.  ATA overhead
>> 3.  IRQ/MSI overhead
>> 4.  Etc.
>>
>> All these small bits add up to more than negligible CPU overhead at high
>> data rates.
>>
> 
> Regarding the others, how would I go about measuring their overhead...

To what end?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
