Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q921pmOA227990 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 20:51:48 -0500
Received: from moltke.seatribe.se (moltke.seatribe.se [178.63.100.209]) by
	cuda.sgi.com with ESMTP id nb5e0CWsX5tfbuJM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 18:53:11 -0700 (PDT)
Received: from [2002:5c20:fa6c::1] (helo=nerv.dolda2000.com)
	by moltke.seatribe.se with esmtp (Exim 4.72)
	(envelope-from <fredrik@dolda2000.com>) id 1TIrfZ-00043Y-Qm
	for xfs@oss.sgi.com; Tue, 02 Oct 2012 03:53:10 +0200
Received: from [2002:5c20:fa6c:200:ca60:ff:fe16:97ac]
	([IPv6:2002:5c20:fa6c:200:ca60:ff:fe16:97ac]) (authenticated bits=0)
	by nerv.dolda2000.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	q921r8bQ013372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 03:53:09 +0200
Date: Tue, 2 Oct 2012 03:53:08 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
Subject: Extreme I/O latency
Message-ID: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
MIME-Version: 1.0
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

Dear list,

I'm having some problems with a Linux system using XFS filesystems, on top 
of LVM, on top of mdraid, and I'm lacking ideas for how to proceed with 
debugging it. The problem manifests itself in that certain, simple I/O 
operations sometimes take extremely long to complete -- not seldomly up to 
20-30 seconds!

I used to have lesser problems of a similar kind previously, but this 
extremeness only started showing up since I upgraded the system from 
Debian Lenny (using Linux 2.6.26) to Squeeze (using 2.6.32). I've since 
upgraded to 3.2.0, and now to 3.5.4, and they all exhibit the same 
problem.

The process having the worst problems with it usually sees them when it 
calls upon Berkeley DB, the stack traces in which seems to tell me that 
it's trying to do mmap'ed I/O in its region files, so I can only assume 
that the stop happens when it's pulling in pages from disk. I can't say I 
know for sure, but I'm getting the feeling that it happens when some other 
process calls fdatasync() or somesuch operation. I get this feeling 
because the problems very often seem to happen exactly when I fetch a 
MySQL-backed webpage from the system's HTTP server (at which point mysqld 
syncs its data to disk after some session table update or the like).

Does anyone have any clue as to what might cause symptoms like these, or, 
if not, how I can debug the issue further? Admittedly, it's not as if I 
can be sure that the problem belongs with XFS proper rather than LVM or 
mdraid, but I have to being somewhere. At least XFS is the direct 
interface that my programs call before getting stuck. :)

Your most obt. St. &c&c,
Fredrik Tolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
