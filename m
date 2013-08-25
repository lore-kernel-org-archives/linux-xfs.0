Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33E777F50
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 10:29:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2227E304032
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 08:29:53 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	G3ovs5LNZiaI1qmC for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 08:29:51 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 09EC11F00837
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 11:29:51 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id XGqB6CPObYEt for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 11:29:47 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 2BBA51F00670
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 11:29:47 -0400 (EDT)
Date: Sun, 25 Aug 2013 11:29:47 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <27780358.4956.1377444587004.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52197DAC.3030906@hardwarefreak.com>
Subject: Re: XFS recovery resumes...
MIME-Version: 1.0
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

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>

> I don't see any other possibility than a hardware problem. And given
> the age of that hardware, it's cheaper in dollars and time to start
> over with new gear.

Only if you have it, Stan.  Only if you have it...

> > I'll try swapping it; this mobo has always gotten whacky if we went
> > over 512M, which is why we haven't.
> 
> The manual says up to 2GB DDR2. Board has two DIMM sockets, which means
> 1GB DIMMs supported. If anything over 512MB (2x256MB DIMMs) causes
> problems then the board had a flaw, or needed a BIOS update, etc. And
> now it's physically damaged.

The BIOS was up to date when we installed it new.

> You'll be extremely hard pressed to find a current board with more
> than 3 PCI unless you buy used. Hmmm...let's see....here we go:

I know.  :-}

> http://www.newegg.com/Product/Product.aspx?Item=N82E16813135329
> http://www.newegg.com/Product/Product.aspx?Item=N82E16819113283
> http://www.newegg.com/Product/Product.aspx?Item=N82E16820148194
> 
> -- $155
> 
> For less than $50 more you not only get all the slots/ports you need,
> but also a much faster dual core CPU and GPU, plus HDMI. And you'll no
> longer have disks on the slow PCI bus. Looks like a winner.

It does.

> > I forget what's in 5, but I think it was the only VGA card I had
> > with
> > S-Video out.
> 
> If you absolutely need Svideo/composite output then you'll need to use
> an external converter or switch box, something like this:
> 
> http://www.newegg.com/Product/Product.aspx?Item=9SIA0U00JZ2490

I don't know if the set has HDMI in or not; it's an older Philips; 37"
I think.  Probably.

> > I'll try the RAM. It's really odd, though, that the badblocks workload
> > and both memtests couldn't find a problem, if it is the memory plane...
> 
> This isn't odd at all and actually quite common. The problem likely is
> not in the DRAM modules or individual transistors in the DRAM chips.
> The problem is likely unstable signalling to/from the DIMM sockets, or
> unstable power to the CPU or Northbridge, caused by old and now
> damaged power delivery circuits on the mainboard.
> 
> Download and run burnp6 for 5-10 minutes. That'll tell you if the CPU
> is getting sufficient power. Make sure the CPU fan is in working order
> first. It's called BURNp6 for a reason. The Athlons didn't have
> thermal shutdown capability, and this will literally destroy the CPU
> with heat build up if the fans aren't working properly. If cooling is
> good, and the system hard locks or exhibits other strange behavior,
> then you know it's time to replace the board. But I think you know that
> already. This will simply be the exclamation point.

Well, oddly, it's up to about 1.4TB moved now overnight, and not a whisper 
of an error in any channel.  It does need to be replaced, but the question
is can I make it limp along reliably until she gets another job...

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
