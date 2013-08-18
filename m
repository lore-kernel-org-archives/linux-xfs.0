Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0DEF7F63
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 17:12:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0FE9304032
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 15:11:57 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	iHP4YdGVQzFjaqnD for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 15:11:56 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 39E5A1F0022A
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 18:11:56 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 4ksht5qvBB1g for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 18:11:51 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id C9FD41F001B0
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 18:11:51 -0400 (EDT)
Date: Sun, 18 Aug 2013 18:11:51 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <240990.4028.1376863911761.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <521141F5.9030703@gmail.com>
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
> From: "Joe Landman" <joe.landman@gmail.com>

> > You need at least 497MB RAM to run with prefetching enabled.
> 
> ^^^^^
> 
> This is 1/2 GB ram, and you didn't specify the memory options of the
> xfs_repair ... so I'm going to guess at this point that you ran out of
> ram. Paging while running xfs_repair is no fun.
> 
> How much ram do you have in this box? Next question is, is this an ECC
> memory box?

512M.  It's a *very* old KT6V based board, and when we tried to expand
it several years back, it went bat-guano with any more than half a gig.

> Not sure if you are hitting a bug as much as running into something
> else like a hardware limit (RAM) or a memory stick issue.

Well, the upstream cause was a 7 year old Antec power supply that
finally died, about a month ago, slowly.

> Do you have EDAC (or mcelog) on? Any errors from this?

I don't have mcelog on, and no, the memory isn't registered, but a
4-pass run of Memtest+ came up clean, so I'm speculating that the
*continuing* problem isn't hardware; I'm pretty sure it was just the
failing 12V rail on the dying PS.  I just have to clean up after it
enough to get *one* of these 2 drives cleaned off, then I can make a 
new FS, and play musical files.

Or, I may just go grab a 3TB external after all.  :-)

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
