Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAEBEWhE164589 for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 05:14:32 -0600
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26B721C3E60C
	for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 03:16:02 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id jfUZRDYCgyJpHwQR for
	<xfs@oss.sgi.com>; Sun, 14 Nov 2010 03:16:02 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1PHaYz-0000cc-27
	for xfs@oss.sgi.com; Sun, 14 Nov 2010 03:16:01 -0800
Message-ID: <30211747.post@talk.nabble.com>
Date: Sun, 14 Nov 2010 03:16:01 -0800 (PST)
From: johahoff <jh@not-dark-yet.de>
Subject: Re: Fwd: xfs - fixing wrong xfs size
In-Reply-To: <4BE1EF9D.2030901@sandeen.net>
MIME-Version: 1.0
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
	<49E353FD.5060207@sandeen.net>
	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
	<4BE1EF9D.2030901@sandeen.net>
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
To: xfs@oss.sgi.com


> You can use xfs_db to set it; or you could comment out the kernel
> check... and mount readonly, and copy off the data you can get to?

I have got the same problem after recovering a xfs volume using ddrescue. It
seems that the new 1 TB drive I dd'ed to is a few blocks short ...

I had a look at the xfs_db man page, but wasn't able to figure out which
command would allow me to set the block count of the fs. Can you please give
the appropriate commands? I think I'll be able to figure out the correct
counts on my own.

Thanks a lot!

-Johannes
-- 
View this message in context: http://old.nabble.com/xfs---fixing-wrong-xfs-size-tp23023562p30211747.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
