Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A0phOX124084 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 19:51:44 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F40F15F303
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 17:52:27 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id TYA5lZeP8qfgpUH2 for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 17:52:27 -0700 (PDT)
Message-ID: <4C898149.7050305@sauce.co.nz>
Date: Fri, 10 Sep 2010 12:52:25 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
References: <4C89668E.6010800@sauce.co.nz> <201009100225.55562@zmi.at>
In-Reply-To: <201009100225.55562@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:

> FWIW, a stripe set of 256k means you do read/write 256k from a single
> drive on each I/O, then the next 256k from the next drive. I hope you
> have very few small accesses and mostly very large files. If you'd use a
> database on that system it would crawl...

Mostly > 2MB and multi GB.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
