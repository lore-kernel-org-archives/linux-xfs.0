Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9RIFpo3072024
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 13:15:52 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 946B4C68FFB
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 11:17:28 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Do6uDnvEJSlgY9Dp for <linux-xfs@oss.sgi.com>;
	Tue, 27 Oct 2009 11:17:28 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1N2qbi-0004hO-47
	for linux-xfs@oss.sgi.com; Tue, 27 Oct 2009 19:17:22 +0100
Received: from 66-227-165-199.dhcp.klmz.mi.charter.com ([66.227.165.199])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 19:17:22 +0100
Received: from mlueck by 66-227-165-199.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 19:17:22 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: xfsrestore restoring MANY more files/dirs than expected, why?
Date: Tue, 27 Oct 2009 14:16:51 -0400
Message-ID: <hc7dei$bco$1@ger.gmane.org>
References: <hc724t$tcn$1@ger.gmane.org>
	<4AE717CF.5020308@sgi.com>	<hc79tr$t62$1@ger.gmane.org>
	<4AE73365.7070206@sgi.com>
Mime-Version: 1.0
In-Reply-To: <4AE73365.7070206@sgi.com>
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
> From the sound of it, you could just wipe out the old state
> directory ("xfsrestorehousekeepingdir") and start a fresh restore.

Greetings Bill-

Yes indeed. I finally found it. As /srv is its own partition, it was in that directory. "rm -rf" quickly took care of it, and xfsrestore was able to work once again.

Thanks very much! A productive day of learning in xfs-land! :-)

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
