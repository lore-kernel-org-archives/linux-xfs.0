Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28M9Wue074945 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 16:09:33 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DA6F18F22CD
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 14:11:03 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id OA2uNZMJzwVl6jwX for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 14:11:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id 4D9D098C3B4
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 23:11:04 +0100 (CET)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 8c8OXPuuIoyO for <xfs@oss.sgi.com>;
	Mon,  8 Mar 2010 23:10:55 +0100 (CET)
Received: from citd.de (p4FC4C439.dip.t-dialin.net [79.196.196.57])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTPSA id 8153898C3A4
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 23:10:54 +0100 (CET)
Date: Mon, 8 Mar 2010 23:10:44 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
Message-ID: <20100308221044.GA17830@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi


More than a month ago i bought 4 Western Digital WD15EARS (1.5 TB) which 
are (AFAIK) the first general/commercial available 4k sector SATA-HDDs.

Unfortunatly the HDDs lie about the 4k physical sector size and the most 
prominent drawback is a worse than abysmal delete performance.
("Normal" Read & Write-performance is OK)

So if i wanted to (re-)mkfs the filesystems what would the correct 
parameters be?

Kernel/Userspace is pretty recent (Debian-SID):
mkfs.xfs version 3.1.1, kernel v2.6.33, util-linux 2.16.0
Not that that should matter when the HDDs lies.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
