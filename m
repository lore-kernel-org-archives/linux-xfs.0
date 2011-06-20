Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KCVZ98150958 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 07:31:35 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E70271578CA6
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 05:31:34 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id IDEl4ZQpyNMCXbOL for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 05:31:34 -0700 (PDT)
Date: Mon, 20 Jun 2011 14:31:32 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110620123132.GA1717@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de> <201106201345.30271@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201106201345.30271@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 2011.06.20 at 13:45 +0200, Michael Monnerie wrote:
> On Montag, 20. Juni 2011 Markus Trippelsdorf wrote:
> > Here are two more examples. The time when the hang occurs is marked
> 
> Could it be that some sectors on the disk are not easy to read for the 
> drive, and that it simply retries several times until it works again? 
> SATA disks can show that behaviour. You could try with "dd" with 
> seek/skip parameters so you read 1gb at once, then skip 1gb and read 1gb 
> again etc, and compare the throughput over all 1gb areas. If there's one 
> slower, that might be the problem.
> 
> Maybe a check with "smartctl" could help, too.

Thanks for the hint, Michael. I've just checked the SMART status on
both disks and the 4kb drive looks indeed suspicious:

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       8
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       8

The 512 byte drive appears to be fine. But I'm running the long
SMART self test on both of them right now and will report back
the result in a few hours.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
