Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6E9E7CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 22:41:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46066AC001
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 20:41:36 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	TOJtkzRPH62xpHS7 for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 20:41:31 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 5142C1F00568
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 23:41:31 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 32bfeS6QHY0N for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 23:41:26 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id E1E891F004EF
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 23:41:26 -0400 (EDT)
Date: Sat, 24 Aug 2013 23:41:26 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <22593430.4954.1377402086863.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <4336525.4942.1377391265287.JavaMail.root@benjamin.baylink.com>
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

----- Original Message -----
> From: "Jay Ashworth" <jra@baylink.com>

> And this latest rsync has gotten 78G and then paused; 80G and then
> paused....
> 
> 84G and then paused...
> 
> 5 min LA 1.9, and the rsync is the top process.
> 
> I have smartd running; no errors yet.
> 
> Still watching...

Well, it's now up to 377GB, and it hasn't crashed yet.  Since the original
FSs and the new one were mkfs'd by different versions of the mkfs program,
I suppose it's possible that might have contributed to the crash in some
perverted way that running badblocks -w in the middle would definitely
prevent.  

We'll see if it survives the night.

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
