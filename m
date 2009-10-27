Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9RHFZQI068520
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 12:15:44 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ACCC4018F
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 10:17:08 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id VCiO8pRIySMEpuBj for <linux-xfs@oss.sgi.com>;
	Tue, 27 Oct 2009 10:17:08 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1N2pfO-0005eL-Fv
	for linux-xfs@oss.sgi.com; Tue, 27 Oct 2009 18:17:06 +0100
Received: from 66-227-165-199.dhcp.klmz.mi.charter.com ([66.227.165.199])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 18:17:06 +0100
Received: from mlueck by 66-227-165-199.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 18:17:06 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: xfsrestore restoring MANY more files/dirs than expected, why?
Date: Tue, 27 Oct 2009 13:16:42 -0400
Message-ID: <hc79tr$t62$1@ger.gmane.org>
References: <hc724t$tcn$1@ger.gmane.org> <4AE717CF.5020308@sgi.com>
Mime-Version: 1.0
In-Reply-To: <4AE717CF.5020308@sgi.com>
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

Bill Kendall wrote:

>> Why is this? What am I doing incorrectly?
> 
> "-s shares/data" is the problem. See -i in the xfsrestore man page:
> 
>      Initially nothing is selected, except for those subtrees specified
>      with -s command line options.

Great catch Bill!

I updated my sample syntax to use -i and -s mutually exclusive.

Now, since I had to Ctrl-Break the previous xfsrestore, I do not seem to know how to correctly clear out the previous session it is remembering.

How do I correctly invoke the -Q switch of xfsrestore? Various things I have tried xfsrestore does not like the syntax of.

Thanks!

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
