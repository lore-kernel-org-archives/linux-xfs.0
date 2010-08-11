Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7BH1RI1150539
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 12:01:30 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40F144ABD38
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 10:01:51 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id nJw8Dem8a9yljCyU for <linux-xfs@oss.sgi.com>;
	Wed, 11 Aug 2010 10:01:51 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OjEgO-0000CM-Vr
	for linux-xfs@oss.sgi.com; Wed, 11 Aug 2010 19:01:40 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 19:01:40 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 19:01:40 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: Re: observed significant performance improvement using "delaylog"
	in a real-world application
Date: Wed, 11 Aug 2010 19:01:31 +0200
Message-ID: <i3ul1b$d3b$1@dough.gmane.org>
References: <i3rt4t$46c$1@dough.gmane.org>
	<201008111003.36890@zmi.at>	<i3trg6$eps$1@dough.gmane.org>
	<201008111428.31196@zmi.at>
Mime-Version: 1.0
In-Reply-To: <201008111428.31196@zmi.at>
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

On 08/11/2010 02:28 PM, Michael Monnerie wrote:
> Thank you. Are those files located within one dir or do you use a hash
> structure like squid cache does?

There's only a shallow hierarchy (for functional, not for distribution
reasons), so the relevant directories have thousands of files in them.

I think after the "ext2"-age no serious file system ever had
a real problem dealing with lots of files in one directory -
or do you have contradicting information?

Regards,

Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
