Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7FC27F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 18:59:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6AA1C304039
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:59:43 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	35is1rLZ3RG34klw for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 16:59:41 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 442241F0077C
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:59:41 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id v08irs4HiKlm for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 19:59:37 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 30BBD1F00643
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:59:37 -0400 (EDT)
Date: Mon, 15 Jul 2013 19:59:37 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <11399340.1426.1373932777053.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <20130715231145.GA5738@citd.de>
Subject: Re: XFS errors on 3TB HDD that is identified of size 2TB only
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
> From: "Matthias Schniedermeyer" <ms@citd.de>

> > Stop! Wait a minute! Stop it, boy!
> >
> > (Sorry; Meat Loaf flashback. :-)
> >
> > You're looking at that partition table with fdisk, *which doesn't
> > understand
> > GPT partition tables*; it's amazing it didn't complain louder.
> 
> It does. At least the version i got does:
> 
> ...
> WARNING: The size of this disk is 3.0 TB (3000592982016 bytes).
> DOS partition table format can not be used on drives for volumes
> larger than (2199023255040 bytes) for 512-byte sectors. Use parted(1)
> and GUID partition table format (GPT).
> ...

You're reading it wrong.  That's the fdisk which you tell me understands
GPT tables *telling you it does not*.

> And that's not even the most recent version:
> fdisk -v
> fdisk (util-linux 2.20.1)
> 
> But in the OP-Case the kernel appeared to reported the disc as 2TB,
> which could be seen in the fdisk output.

fdisk is not guaranteed to be using a long enough variable there to be
able to report the drive size correctly.

TTBOMK, *nothing* other than parted presently knows how to create
and modify GPT partition tables.

Except, apparently, for a program with the *singularly* poorly chosen 
name of "GPT Fdisk":

  http://sourceforge.net/projects/gptfdisk/

I know, that sounds like a *really good* name.  I've been doing tech 
support for 30 years; trust me, it's about the worst imaginable name. :-}

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
