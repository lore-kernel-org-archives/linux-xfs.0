Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1D9a5hZ125152 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 03:36:06 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D657624DFC8
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 01:35:30 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id SbplGx6seJ37c3zN for
	<xfs@oss.sgi.com>; Fri, 13 Feb 2009 01:35:30 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id A25313FC7
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 10:35:29 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id AC294400154
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 10:35:29 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs preallocation timeout
Date: Fri, 13 Feb 2009 10:35:29 +0100
References: <200902111522.11987@zmi.at> <20090212220803.GU8830@disturbed>
In-Reply-To: <20090212220803.GU8830@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902131035.29407@zmi.at>
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

On Donnerstag 12 Februar 2009 Dave Chinner wrote:
> Yes.
>
> BTW, you are referring to "delayed allocation", not
> "pre-allocation". Pre-allocation is the act of immediately
> allocating space on disk without writing data; delayed allocation is
> avoiding allocation until the data is to be written to disk...

Thank you Dave. I didn't remember the correct wording. So 
/proc/sys/vm/dirty_expire_centisecs for XFS says how much data, but not 
metadata, I could loose on kernel crash/power outage etc. No need to 
worry, right?

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
