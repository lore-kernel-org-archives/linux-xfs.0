Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G9AZTZ123670 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 04:10:35 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 737C21598D87
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 02:16:48 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id K6Yk8TxonMSjDVE2 for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 02:16:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 46571BA3F
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 11:13:09 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BlraG0UxLN7H for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 11:13:07 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 32833B98D
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 11:13:07 +0200 (CEST)
References: <20100615132221.GA17385@infradead.org>
Message-ID: <cone.1276679587.153934.32947.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: Re: XFS status update for May 2010
Date: Wed, 16 Jun 2010 11:13:07 +0200
Mime-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Christoph Hellwig writes:

> Meanwhile active development aimed at 2.6.35 merge progressed.  The
> major feature for this window is the merge of the delayed logging code,
> which adds a new logging mode that dramatically reduces the bandwidth
> required for log I/O.  See the documentation [1] for details.  Testers
> for this new code are welcome.

As of today I'm running 2.6.35-rc3 with XFS and delayed logging on a 4GB
software raid0 we use to do nightly builds of about 150 software packages 
(kernel, samba, etc) on Slackware 10.1.

If there's anything specific I can do, please let me know. I have some more 
hardware around to test with.

By the way: thanks for these monthly status updates: they're really useful!

Regards,

roel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
