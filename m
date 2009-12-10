Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA0vc3t024313 for <xfs@oss.sgi.com>; Wed, 9 Dec 2009 18:57:38 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D50FE1358
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 16:58:13 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id rG42T4S4kgIcEfAP for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 16:58:13 -0800 (PST)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.4 #31773)
	id <01NH2P4JU9V490VLVN@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	10 Dec 2009 01:57:18 +0100
Date: Thu, 10 Dec 2009 01:57:39 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
In-reply-to: <4B204334.1000605@shiftmail.org>
Message-id: <4B204783.7040109@shiftmail.org>
MIME-version: 1.0
References: <4B204334.1000605@shiftmail.org>
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
Cc: linux-raid <linux-raid@vger.kernel.org>

Asdo wrote:
> and I think I have seen around 10MB/sec when they are of 500KB (this 
> transfer at 10MB/sec was in parallel with another faster one however). 
Yes I definitely confirm: right now I have just 1 rsync copy running, 
it's in a zone where files are around 500KB on average, and it's going 
at 9 MB/sec.
Stack traces of the writer process conform to what I have posted in my 
previous email, even now that the writer is the only process using the 
destination array.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
