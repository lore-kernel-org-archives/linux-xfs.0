Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9P5Op0E198098 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 00:24:51 -0500
Received: from mailgate.ics.forth.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51798120A28
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 22:26:07 -0700 (PDT)
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2]) by
	cuda.sgi.com with ESMTP id 1fxjyCApGdHUoj10 for
	<xfs@oss.sgi.com>; Sun, 24 Oct 2010 22:26:07 -0700 (PDT)
Received: from av1.ics.forth.gr (av1-in.ics.forth.gr [139.91.1.71])
	by mailgate.ics.forth.gr (8.14.3/ICS-FORTH/V10-1.8-GATE) with ESMTP id
	o9P5Q4Bp025817
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:26:06 +0300 (EEST)
Message-ID: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
Date: Mon, 25 Oct 2010 08:26:04 +0300
Subject: XFS journaling position
From: klonatos@ics.forth.gr
MIME-Version: 1.0
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

Hello,

     I have recently discovered that the default journalling position of
XFS is in the "middle" AG, if the log is internal (e.g. for 32 AGs
the journal will be placed at the AG = 16). Although I am aware that
there is possible to explicitly specify a journal location using the
-l agnum=X mkfs option, I am really curious about the resoning behind
the default choice.

Thanks in advance,
Yannis Klonatos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
