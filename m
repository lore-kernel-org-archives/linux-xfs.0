Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n91AiYVF089228 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 05:44:34 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7044D495AAD
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 03:45:55 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id QoOX35tfybsZ8RVR for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2009 03:45:55 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B6FA86E1
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 12:45:52 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 35A0E400163
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 12:45:53 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Two XFS involving stack traces from Debian's 2.6.26-2-amd64
Date: Thu, 1 Oct 2009 12:44:37 +0200
References: <4AC45B72.9060500@decisionsoft.co.uk>
In-Reply-To: <4AC45B72.9060500@decisionsoft.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910011244.37489@zmi.at>
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

On Donnerstag 01 Oktober 2009 Stuart Rowan wrote:
> umount /tmp/$from ; /sbin/lvremove -f /dev/$vgroup/snap-shot ; rmdir
> /tmp/$from

Why don't you
umount /tmp/$from && /sbin/lvremove -f /dev/$vgroup/snap-shot && rmdir 
/tmp/$from
from your script so this won't happen again?
Or make a loop around umount?

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
