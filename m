Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 304FC7F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 06:01:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC68AAC002
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 04:01:40 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id 3brxtHcEdcVDNUAO (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 04:01:34 -0800 (PST)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYU01IC21EKWI40@mailout3.samsung.com> for
	xfs@oss.sgi.com; Fri, 04 Dec 2015 21:01:32 +0900 (KST)
Date: Fri, 04 Dec 2015 12:01:32 +0000 (GMT)
From: VIVEK TRIVEDI <t.vivek@samsung.com>
Subject: Re: Re: [PATCH 02/11] xfsprogs: fix integer overflow in
	xlog_find_verify_cycle
MIME-version: 1.0
MIME-version: 1.0
Message-id: <2126448940.283821449230492151.JavaMail.weblogic@epmlwas07c>
Reply-To: t.vivek@samsung.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: AMIT SAHRAWAT <a.sahrawat@samsung.com>, PANKAJ MISHRA <pankaj.m@samsung.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Ummm, in isolation that change is technically correct, but when you
> look at what bufblks contains it is clearly wrong.  nbblks is an
> int, so "1 << ffs(nbblks)" should not be larger than an int.

> i.e. bufblks is simply a count of blocks in the log, which by
> definition cannot be more than an int (in fact, 2^31 / 2^9 is the
> largest legal value it can have). Hence it can't be larger than an
> int, and all the functions it is passed to expect it to be an
> int...
>
>Hence the use of xfs_daddr_t is wrong, and that's the first thing
>that needs fixing....
thanks for review!
I will resend updated patch.
thanks!
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
