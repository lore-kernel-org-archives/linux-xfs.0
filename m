Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 11:30:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AIUq4p000971
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 11:30:53 -0700
Message-ID: <46E5670E.9000703@sandeen.net>
Date: Mon, 10 Sep 2007 10:47:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Attempt to Access Beyond End of Device
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
In-Reply-To: <1189432747.4385.27.camel@auctoritas.fs3.ph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: linux-xfs@oss.sgi.com, Alec Joseph Rivera <agi@fs3.ph>

Federico Sevilla III wrote:
> Hi,
> 
> We've set up Debian GNU/Linux 4.0 "Etch" on an IBM x3400 machine with
> two 73.4GB SAS hard drives in hardware RAID 1 with a battery-backed
> cache. We are using the stock Debian 2.6.18-4-686 kernel.

can you send along the results of:

	# xfs_db -r -c "sb 0" -c "print" /dev/sda8?

and
	# cat /proc/partitions

... and does the hardware raid have a funky sector size?

-Eric
