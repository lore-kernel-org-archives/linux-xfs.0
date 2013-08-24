Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 898AA7CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 18:48:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0FDE5AC00A
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 16:48:35 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	HqCmzWzvVbP4JQck for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 16:48:34 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 435801F002E9
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 19:48:10 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 8irGFDnEZsCv for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 19:48:05 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id DA9B21F0029C
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 19:48:05 -0400 (EDT)
Date: Sat, 24 Aug 2013 19:48:05 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <1365641.4934.1377388085878.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <5211BF74.9060605@hardwarefreak.com>
Subject: Default mkfs parms for my DVR drive
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

This is a Seagate ST3000DM001, all one volume, for my sister's DVR on 
which I've been doing this volume recovery work.  The default setup that
mkfs.xfs returns with no parms supplies is this:

meta-data=/dev/sda1              isize=256    agcount=4, agsize=183141568 blks
         =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=732566272, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=357698, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

and that takes about 3 minutes to mkfs a 3TB drive.

Anyone have some thoughts they wish to cast upon the waters about either part 
of that?

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
