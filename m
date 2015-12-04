Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06EE87F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 06:03:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC34B304059
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 04:03:22 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id ps1hHxGQyvXvTLX9 (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 04:03:21 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYU01NTQ1HJPV30@mailout3.samsung.com> for
	xfs@oss.sgi.com; Fri, 04 Dec 2015 21:03:19 +0900 (KST)
Date: Fri, 04 Dec 2015 12:03:18 +0000 (GMT)
From: VIVEK TRIVEDI <t.vivek@samsung.com>
Subject: Re: Re: [PATCH 03/11] xfsprogs: mkfs: fix unintentional integer
	overflow
MIME-version: 1.0
MIME-version: 1.0
Message-id: <1232503614.283861449230598249.JavaMail.weblogic@epmlwas07c>
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

>I dislike unexplained casts in code like this. Nobody knows exactly
>why it is there. A better fix is to change the definition of
>rswidth to a 64 bit type so casts are not ever necessary...
thanks for review!
I will resend updated patch.
thanks!
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
