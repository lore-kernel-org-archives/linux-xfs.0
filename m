Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 165C129DFB
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 12:45:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8185AC003
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 10:45:19 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id G4Re66k5VeYhC8v4
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 10:45:18 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 533A96C169
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 12:45:18 -0500 (CDT)
Message-ID: <521A42AA.6050704@hardwarefreak.com>
Date: Sun, 25 Aug 2013 12:45:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS recovery resumes...
References: <27780358.4956.1377444587004.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <27780358.4956.1377444587004.JavaMail.root@benjamin.baylink.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 8/25/2013 10:29 AM, Jay Ashworth wrote:
> ----- Original Message -----
>> From: "Stan Hoeppner" <stan@hardwarefreak.com>
> 
>> I don't see any other possibility than a hardware problem. And given
>> the age of that hardware, it's cheaper in dollars and time to start
>> over with new gear.
> 
> Only if you have it, Stan.  Only if you have it...

True, that.

>>> I'll try swapping it; this mobo has always gotten whacky if we went
>>> over 512M, which is why we haven't.
>>
>> The manual says up to 2GB DDR2. Board has two DIMM sockets, which means
>> 1GB DIMMs supported. If anything over 512MB (2x256MB DIMMs) causes
>> problems then the board had a flaw, or needed a BIOS update, etc. And
>> now it's physically damaged.
> 
> The BIOS was up to date when we installed it new.
> 
>> You'll be extremely hard pressed to find a current board with more
>> than 3 PCI unless you buy used. Hmmm...let's see....here we go:
> 
> I know.  :-}
> 
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16813135329
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16819113283
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16820148194
>>
>> -- $155
>>
>> For less than $50 more you not only get all the slots/ports you need,
>> but also a much faster dual core CPU and GPU, plus HDMI. And you'll no
>> longer have disks on the slow PCI bus. Looks like a winner.
> 
> It does.
> 
>>> I forget what's in 5, but I think it was the only VGA card I had
>>> with
>>> S-Video out.
>>
>> If you absolutely need Svideo/composite output then you'll need to use
>> an external converter or switch box, something like this:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=9SIA0U00JZ2490
> 
> I don't know if the set has HDMI in or not; it's an older Philips; 37"
> I think.  Probably.

The board has VGA, DVI, and HDMI, so you should be covered six ways to
Sunday with flat panel displays.  If this Philips is an older "fork lift
required" 37" CRT then it probably only has composite, Svideo, maybe
component.

>>> I'll try the RAM. It's really odd, though, that the badblocks workload
>>> and both memtests couldn't find a problem, if it is the memory plane...
>>
>> This isn't odd at all and actually quite common. The problem likely is
>> not in the DRAM modules or individual transistors in the DRAM chips.
>> The problem is likely unstable signalling to/from the DIMM sockets, or
>> unstable power to the CPU or Northbridge, caused by old and now
>> damaged power delivery circuits on the mainboard.
>>
>> Download and run burnp6 for 5-10 minutes. That'll tell you if the CPU
>> is getting sufficient power. Make sure the CPU fan is in working order
>> first. It's called BURNp6 for a reason. The Athlons didn't have
>> thermal shutdown capability, and this will literally destroy the CPU
>> with heat build up if the fans aren't working properly. If cooling is
>> good, and the system hard locks or exhibits other strange behavior,
>> then you know it's time to replace the board. But I think you know that
>> already. This will simply be the exclamation point.
> 
> Well, oddly, it's up to about 1.4TB moved now overnight, and not a whisper 
> of an error in any channel.  It does need to be replaced, but the question
> is can I make it limp along reliably until she gets another job...

Just keep fingers/toes crossed.  That mobo is nearly 10 years old, never
handled RAM correctly.  You suffered a PSU failure which apparently
damaged something to some degree.  But you now know there are relatively
inexpensive upgrade options available with the features you need, and
you can begin planning, while not in "emergency mode" with sis hounding
you every day to fix it. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
