Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31FB629DF8
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:24:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1606F304062
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 07:24:15 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by cuda.sgi.com
	with ESMTP id q1EEUzQ9jWQTLcuY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 07:24:14 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-64075195-5d6c-40f8-97ba-cc348261c69f-1403619853159@3capp-gmx-bs44>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Tue, 24 Jun 2014 16:24:13 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3786051696770217882=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3786051696770217882==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<pre>Hello Eric,
ok will never use xfs_check ;). Yes i saw option -P but i though if i desabled that test, i will never get fix those problems. The Version is from Debian Wheezy stable, so why it is such old, when it is that important :do not understand this from debianmaintainer...: So what could i do to use latest Version under Debian Wheezy? Normaly i use the package system.. Any risk to loos all my data? Where came the Problem from? If the version is such old, was the md2 created out of that, or are there only the tools in it?
Thx

On 6/24/14, 8:01 AM, Dragon wrote:
</pre>

<blockquote>Hello, i have a fresh install Debian Wheezy with software raid as md2 for my files. MD2 is nealry full of 8TB and i wanted to migrate the data to a newier system. While copy files i got an message that i have to run xfs_repair. I first run xfs_check but it eats up all my 11GB memory and the system stalls.</blockquote>
Yep, xfs_check doesn&#39;t scale and is on the way to deprecation.

<blockquote>Then i run xfs_repair -n /dev/md2 but it hangs each time add: problem with directory contens in inode 2147997719 - would have cleared inode 2147997719. If i break this and restart, it hangs at the same position. System seems to do nothing over hours.</blockquote>
You might try the -P option to repair. -P Disable prefetching of inode and directory blocks. Use this option if you find xfs_repair gets stuck and stops proceeding. If that works, it likely indicates a bug, but it might get you going.

<blockquote>Some Infos: xfsprogs in Version 3.1.7+b1</blockquote>
And that&#39;s a 3-year old xfsprogs, so an upgrade might help, too. -Eric</div></div></body></html>


--===============3786051696770217882==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3786051696770217882==--
