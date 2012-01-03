Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q033P28u257639
	for <linux-xfs@oss.sgi.com>; Mon, 2 Jan 2012 21:25:08 -0600
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 2EQt0iXQJmkJ78A8 for <linux-xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 19:25:00 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Rhuzj-0003JB-Go
	for linux-xfs@oss.sgi.com; Tue, 03 Jan 2012 04:24:59 +0100
Received: from 75-134-99-39.dhcp.aldl.mi.charter.com ([75.134.99.39])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jan 2012 04:24:59 +0100
Received: from mlueck by 75-134-99-39.dhcp.aldl.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jan 2012 04:24:59 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: Why does xfsdump encounter "WARNING: could not get list of
	non-root attributes for nondir ino nnnn: Cannot allocate memory (12)"?
Date: Mon, 02 Jan 2012 22:24:52 -0500
Message-ID: <jdtsdv$2r1$1@dough.gmane.org>
References: <jdo01m$62j$1@dough.gmane.org> <20120102213706.GQ23662@dastard>
Mime-Version: 1.0
In-Reply-To: <20120102213706.GQ23662@dastard>
Reply-To: mlueck@lueckdatasystems.com
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
To: linux-xfs@oss.sgi.com

Dave Chinner wrote:
> Memory is less fragmented, hence more likely to have a order-5
> allocation succeed. Try the patch below, and see if that helps.

More I was feeling a bit guilty that I was bouncing the machines to have the backup work without error... as "Linux Administrators NEVER reboot their boxes!"

I have a few too many things in the test tubes at the moment to take on custom patching a kernel build.

So, do these mean that there is anything wrong with the backup being made? Is the final SUCCESS return code in error?

Thank you for providing an explanation and patch.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
