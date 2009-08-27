Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R9kbHp078362 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 04:46:52 -0500
Received: from mx1.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D651402898
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 02:47:24 -0700 (PDT)
Received: from mx1.empa.ch (mx1.empa.ch [152.88.7.31]) by cuda.sgi.com with
	ESMTP id bhN4vOlXBLNObqbm for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2009 02:47:24 -0700 (PDT)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Thu, 27 Aug 2009 11:47:06 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA65237@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<alpine.DEB.2.01.0908270232540.5744@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0908270232540.5744@bogon.housecafe.de>
Content-Language: en-US
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thank you Christian for your reply.


>
>SLES 10, that's Linux 2.6.16-something, right?
>

Linux 2.6.16.60  x86_64

>I know, I probably shouldn't ask this right now, but I'm kinda curious:
>_Why_ aren't they backed up?
>

It is absolutely legitimate as question.
Because it is a storage unit of 20 TB that we can't backup, and the users know it.


>> 3) xfs_ncheck eats a lot of memory and freezes after 6-7 hours without
>giving output
>
>Did you look into the syslog too? Maybe the box was out of memory and
>killed xfs_ncheck. How much memory does the box have?

Unfortunately xfs_ncheck was not killed, it went "D" state.
The box has 16Gb.

Can I do something with my xfs_metadump [please be polite :-) ]
Daniele

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
