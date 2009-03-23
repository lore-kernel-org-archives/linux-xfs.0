Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2NGMnmR169500
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 11:23:10 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 075C41C62FAE
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:22:10 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id fwAZb287VIkYkLdW for <linux-xfs@oss.sgi.com>;
	Mon, 23 Mar 2009 09:22:10 -0700 (PDT)
Message-ID: <49C7B730.7030506@rtr.ca>
Date: Mon, 23 Mar 2009 12:22:08 -0400
From: Mark Lord <liml@rtr.ca>
MIME-Version: 1.0
Subject: Re: How to configure 36 disks ?
References: <174852.24274.qm@web51309.mail.re2.yahoo.com>
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com>
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
To: Jon@eHardcastle.com
Cc: linux-aio@kvack.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Raz <raziebe@gmail.com>, linux-fsdevel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>

Jon Hardcastle wrote:
> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!
..

Here's one way:

  -- four onboard SATA ports
  -- plus four add-in PCI/PCIX/PCIe 8-port Marvell SATA cards.
  -- and a honkin' huge PSU!

:)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
