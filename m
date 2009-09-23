Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NLkIoE037332 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 16:46:18 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC856477FA7
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:47:36 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 2nGjQdoYBd5vyoQM for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:47:36 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 380AC689
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 23:47:10 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id BAB8240016C
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 23:47:34 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: problems with xfs_growfs after lvextend
Date: Wed, 23 Sep 2009 23:47:05 +0200
References: <4ABA8D56.2040101@phy.duke.edu>
In-Reply-To: <4ABA8D56.2040101@phy.duke.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909232347.05945@zmi.at>
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

On Mittwoch 23 September 2009 Jimmy Dorff wrote:
> Any suggestions ? Any help understanding why this didn't work ?

Hm, hasn't there been a problem with growing more than 2TB at once?

I search in my local box and found this, might help:
May 09: [PATCH] fix overflow in xfs_growfs_data_privat

Maybe kernel update?

mfg zmi
-- 
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
