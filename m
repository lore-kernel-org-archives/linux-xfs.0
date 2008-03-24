Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 11:57:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2OIuu2O004019
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 11:56:58 -0700
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17DC76DC8A1
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 11:57:30 -0700 (PDT)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id Lr4QMZN4KCkxAb12 for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 11:57:30 -0700 (PDT)
Date: Mon, 24 Mar 2008 19:56:59 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Poor VMWare disk performance on XFS partition
In-Reply-To: <18407.51134.786769.234995@tree.ty.sabi.co.uk>
Message-ID: <Pine.LNX.4.64.0803241908250.4383@alienAngel.home.sk>
References: <876423.51989.qm@web52006.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk> <47E7B3E4.1020205@thebarn.com>
 <18407.51134.786769.234995@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs2@xfs2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

On Mon, 24 Mar 2008, Peter Grandi wrote:

> >>> On Mon, 24 Mar 2008 09:00:04 -0500, Russell Cattelan
> >>> <cattelan@thebarn.com> said:
> 
> >> [ ... ] Mount XFS partition with "nobarrier" option. [ ... ]
> 
> > I can verify that ... barriers are killers when running vmware
> > guest disk/memory images. [ ... ]
> 
> But of course running VM images with 'nobarrier' is quite brave:
> because it removes *any* integrity guarantee to IO initiated
> inside the virtual machine.

But of course barrier is workaround for hardware problems like power outage.
So if you want to have integrity in VM without performance penalty you must
ensure integrity in HW and don't leave it to barrier option. VMWare
performace is compromised with barrier on. And if you compare ext3 with xfs
you must have on mind that ext3 does not use barrier by default.
 
jan

-- 
