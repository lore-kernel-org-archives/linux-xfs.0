Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n95BUXge197558 for <xfs@OSS.SGI.com>; Mon, 5 Oct 2009 06:30:34 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DCA71D782CA
	for <xfs@OSS.SGI.com>; Mon,  5 Oct 2009 04:31:57 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id UsK1I2PfslCezgKe
	for <xfs@OSS.SGI.com>; Mon, 05 Oct 2009 04:31:57 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1Mule0-0003ay-Sl
	for <xfs@OSS.SGI.com>; Mon, 05 Oct 2009 12:22:20 +0100
MIME-Version: 1.0
Message-ID: <19145.55016.313563.304290@tree.ty.sabi.co.uk>
Date: Mon, 5 Oct 2009 12:22:16 +0100
Subject: Re: XFS Question
In-Reply-To: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
References: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>


> [ ... ]  XFS on my RHEL 5.1 system. [ ... ]  update the system
> to the latest RHEL release(5.4). [ ... ] My question is, I
> will perform the system update, but what will happen to my XFS
> system?

Your XFS system was not part of RHEL and will continue to be so.
It will continue to work.

> Do I simply locate the above three RPM's for the latest kernel
> I am installing and be good to go?

RHEL5.1 and RHEL5.4 are just updates of the same OS, and RH sort
of guarantees binary compatibility between various updates of
the same OS. This actually works in practice as well as in
theory, especially for the kernel (RH slip on other stuff) and
its modules.

RHEL5.4 kernels have an XFS kernel module included, but RH only
supports XFS as an optional "layered product", that is an
additional support license (like GFS, RHCS and others).

If you are using RHEL because you want RH support, that is
probably something you want to look into. RH presumably added
XFS as a layered product precisely because so many customers
like you were using it even if not supported.

Otherwise consider using the new ElRepo repository, or the XFS
packages from CentOS Plus or Scientific Linux (yes, they work
with RHEL too, both kernel modules and userspace modules).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
