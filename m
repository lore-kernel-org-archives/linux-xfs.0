Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FF2329DF8
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:35:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A6408F8035
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 09:35:47 -0800 (PST)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	RGPxg8VMFEs76CBz for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 09:35:45 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 2B94C1F00124
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 12:35:45 -0500 (EST)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id rtpMCkfIvGSt for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 12:35:40 -0500 (EST)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id CE54B1F00120
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 12:35:40 -0500 (EST)
Date: Sat, 28 Dec 2013 12:35:40 -0500 (EST)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <23931797.1848.1388252140769.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52BF0295.9040301@hardwarefreak.com>
Subject: Re: [xfs_check Out of memory: ]
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
To: xfs <xfs@oss.sgi.com>

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>

> Create a 100GB swap partition and leave the remainder unallocated. The
> unallocated space will automatically be used for GC and wear leveling,
> increasing the life of all cells in the drive.

*Great* tip.  :-)

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
