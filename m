Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5OKSre3046340 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 15:28:54 -0500
Received: from mailgate.ics.forth.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C135C154542F
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 13:31:34 -0700 (PDT)
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2]) by
	cuda.sgi.com with ESMTP id 5oLrs1bS56y4aXDY for
	<xfs@oss.sgi.com>; Thu, 24 Jun 2010 13:31:34 -0700 (PDT)
Received: from av1.ics.forth.gr (av1-in.ics.forth.gr [139.91.1.71])
	by mailgate.ics.forth.gr (8.14.3/ICS-FORTH/V10-1.8-GATE) with ESMTP id
	o5OKVVsJ004496
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 23:31:33 +0300 (EEST)
Received: from [192.168.1.63] (adsl-200.91.140.92.tellas.gr [91.140.92.200])
	(authenticated bits=0)
	by enigma.ics.forth.gr (8.14.3//ICS-FORTH/V10.3.0C-EXTNULL-SSL-SASL)
	with ESMTP id o5OKXD3x023817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 23:33:14 +0300
Message-ID: <4C23C074.5080100@ics.forth.gr>
Date: Thu, 24 Jun 2010 23:30:44 +0300
From: Yannis Klonatos <klonatos@ics.forth.gr>
MIME-Version: 1.0
Subject: Metadata hit ratio
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
To: xfs@oss.sgi.com

Hello all,

         Along with my other (yet pending :-( ) question/issue, I have 
another question (i hope this is the last :-) )
now.
         I would like to measure the hit ratio of the metadata accesses 
of XFS (inode+internal buffers). It is my
understanding that XFS uses its own data structures, and does not rely 
on the buffercache mechanisms of
the Linux kernel. However, even doing so, there may be cases that the 
metadata may not fit in the RAM,
and I/O operations are required to fetch them from the underlying 
storage. I have found out that there are
two places that XFS uses the submit_bio function. If i add some counters 
there, would it suffice to measure all
the metadata misses?
         Or is this information available in one (or more) of the 
xfs_stats counters? And if so, what do i need to sum
up in order to get the total metadata hit and miss ratio?

Thanks (again!) in advance,
Yannis Klonatos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
