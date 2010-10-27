Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9R63pop143348 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 01:03:52 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1B0B128E0C
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 23:05:07 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id YuUqqjClPXKaKAwj for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 23:05:07 -0700 (PDT)
Date: Wed, 27 Oct 2010 08:04:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101027080454.31a59a3c@galadriel.home>
In-Reply-To: <201010270124.44846@zmi.at>
References: <4CC67450.9020602@profihost.ag> <4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
	<201010270124.44846@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, xfs@oss.sgi.com

Le Wed, 27 Oct 2010 01:23:35 +0200 vous =E9criviez:

> BTW: any recommendations for these tuning knobs on VM-ized servers?
> What should be set in the VMs and what on the host?

>From my experience, using iSCSI as the transport to export lvs to the
VMs, the best performance is reach by setting scheduler to noop and
queue depth on the target and the VM; but setting the readahead only on
the VM side.

For different configurations, as usual, YMMV. =


-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
