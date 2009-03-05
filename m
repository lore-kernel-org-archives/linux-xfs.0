Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n256jg88127701 for <xfs@oss.sgi.com>; Thu, 5 Mar 2009 00:45:43 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A80AE17212C
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 22:45:12 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 26QjUiMymsSCRIJR for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2009 22:45:12 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id C2E7743E5
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2009 07:44:39 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id CED8D40017A
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2009 07:44:39 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Thu, 5 Mar 2009 07:44:39 +0100
References: <200902170959.55077@zmi.at> <20090224163823.GA19811@infradead.org>
	<200902250740.43223@zmi.at>
In-Reply-To: <200902250740.43223@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903050744.39283@zmi.at>
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

On Mittwoch 25 Februar 2009 Michael Monnerie wrote:
> Q: Which settings are best with virtualization like VMware, XEN,
> qemu?
>
> The biggest problem is that those products seem to also virtualize
> disk writes in a way that even barriers don't work anymore, which
> means even a fsync is not reliable. Tests confirm that unplugging the
> power from such a system even with RAID controller with battery
> backed cache and hard disk cache turned off (which is save on a
> normal host) you can destroy a database within the virtual machine
> (client, domU whatever you call it).
>
> In qemu you can specify cache=off on the line specifying the virtual
> disk. For others I have no information what to do.

In as question 26 now
http://xfs.org/index.php/XFS_FAQ

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
