Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4AAvSdu061899 for <xfs@oss.sgi.com>; Tue, 10 May 2011 05:57:29 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75C4D440F68
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 03:57:27 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id pqLsODuYog7kbVMl for
	<xfs@oss.sgi.com>; Tue, 10 May 2011 03:57:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id 3C34EA65C35
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 12:57:26 +0200 (CEST)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 7FYt-f5-4x9M for <xfs@oss.sgi.com>;
	Tue, 10 May 2011 12:57:10 +0200 (CEST)
Received: from citd.de (p5B05D88B.dip.t-dialin.net [91.5.216.139])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTPSA id 41D75A65C34
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 12:57:09 +0200 (CEST)
Date: Tue, 10 May 2011 12:57:00 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Files appear too big in `du`
Message-ID: <20110510105700.GA20307@citd.de>
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


Since a few weeks i'm experiencing an annoying 'thing' where files are 
often too big in `du` and directory totals are to high in `ls -l`.

I appears that files, which are in the process of beeing 
copied/downloaded/whatever, grow in large chunks ahead of time, while 
the actual file-content is beeing copied into the files. And then it 
appears that the last chunk isn't shrunk after the process is finished.
Neither xfs_bmap (Version 3.1.5) nor filefrag show anything beyond the 
extent that compromises the actual file-content.

I've noticed this at least with:
- "git gc"
- cp -a
- rsync
- downloads with firefox (technically Iceweasel)

Kernel is currently 2.6.38.5, Distribution is an up-to-date Debian-SID.
mount is with default-parameters, except "noatime".

Any idea how to debug this, or is this a known bug and waiting a few 
days for 2.6.39 should fix this?




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
