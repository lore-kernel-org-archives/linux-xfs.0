Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DNMXaM235891 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 18:22:33 -0500
Received: from exprod7og119.obsmtp.com (exprod7og119.obsmtp.com [64.18.2.16])
	by cuda.sgi.com with SMTP id vwjdLd0azbUSDzli (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Sep 2012 16:23:38 -0700 (PDT)
Message-ID: <50526AF5.50201@genband.com>
Date: Thu, 13 Sep 2012 17:23:33 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: global serialization points in XFS circa 2.6.27?
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com


Hi,

I've got an embedded system running a modified 2.6.27 (yes, we're trying 
to upgrade) and we're running into a scenario where something is 
happening that causes accesses to *all* XFS filesystems to hang or be 
delayed for some time.

I know it may be a bit of a stretch since the kernel is old, but I was 
wondering if you might have any suggestions as to what I might look at 
as far as locks/algorithms within XFS that would affect all filesystems.

In case it matters, the hardware is fairly beefy-- 32 threads of Sandy 
Bridge CPU, 64GB RAM, SAS drives, etc.

Chris

-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
