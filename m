Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CDE27CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 19:41:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C2A4304039
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 17:41:14 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	71oaIda0I9HlttzM for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 17:41:10 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id D52411F002E9
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 20:41:09 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 9lDyMG361x11 for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 20:41:05 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 7111F1F0029C
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 20:41:05 -0400 (EDT)
Date: Sat, 24 Aug 2013 20:41:05 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <4336525.4942.1377391265287.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52194911.3050606@gmail.com>
Subject: Re: Default mkfs parms for my DVR drive
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

---- Original Message -----
> From: "Joe Landman" <joe.landman@gmail.com>

> Dave, Eric, and the rest of the xfs team will tell you "use the defaults
> Luke". For 99 and 44/100ths percent of users, this is the right choice.

Well, if I can't; they're the ones who screwed up.  :-)

> I am guessing that some of the delay may be the speed of the interface
> to the disk ... but even then 3 minutes sounds long, unless something
> else is hitting the disk at the same time.
> 
> Which kernel version btw? A quick 'uname -a' is a good thing.

Ok, ok; this isn't the same thread anymore.  :-)

Linux duckling 3.4.47-2.38-default #1 SMP Fri May 31 20:17:40 UTC 2013 (3961086) i686 athlon i386 GNU/Linux

> Your hardware could also be somewhat slow ... Could you do an
> 
> lshw -class disk -class storage

It probably is.

It's an old Athlon, MSI MS-7021, KT6V chipset; 512M of DDR... maybe that's
DDR 2; it won't run right with more.

I don't seem to have lshw.

Or, oddly, hwconfig.  It's got 3 Seagate ST3000DM001s, 2 on a SiI 7114 PCI
with a pair of Fujitsu Deskstars, 2T and 1T; 40G Samsung boot on the mobo SATA;
the third 3000 is in a USB 2 enclosure.

And this latest rsync has gotten 78G and then paused; 80G and then paused....

84G and then paused...

5 min LA 1.9, and the rsync is the top process.

I have smartd running; no errors yet.

Still watching...

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
