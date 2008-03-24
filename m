Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 12:12:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2OJC9YF005263
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 12:12:11 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0069610191C4
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 12:12:43 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id 1PiFZTbVQI2RV2oh for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 12:12:43 -0700 (PDT)
Date: Mon, 24 Mar 2008 15:12:41 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: Poor VMWare disk performance on XFS partition
Message-ID: <20080324191241.GB32221@josefsipek.net>
References: <876423.51989.qm@web52006.mail.re2.yahoo.com> <Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk> <47E7B3E4.1020205@thebarn.com> <18407.51134.786769.234995@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18407.51134.786769.234995@tree.ty.sabi.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs2@xfs2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

On Mon, Mar 24, 2008 at 03:24:46PM +0000, Peter Grandi wrote:
> >>> On Mon, 24 Mar 2008 09:00:04 -0500, Russell Cattelan
...
> > [ ... ] The preallocation would also help out quite bit if you
> > don't mind dedicating the disk space vs the sparse file method,
> > which allow for over subscribing the physical space. [ ... ]
> 
> But sparse files are a crazy idea for virtual machines, because
> the software inside is built on the idea that its storage is
> allocated in contiguous volumes, and relies on that for its own
> optimizations.

Yup, gets you LOTS of extents => takes forever to unlink.

> Or else one ends up with a CP/CMS situation where the "CMS"
> inside the virtual machine is fully aware that it is running
> inside a virtual machine and passes "out-of-bandwidth" hints to
> the virtual machine software.

IIRC, only the first version of CMS was capable of running on bare hardware.
It was rather silly (and still is) to do that, and so all sort of tweaks
were made to make it faster, but at the same time make it depend on CP (the
DIAG instruction, etc.).

There's nothing wrong with this aproach, it just happens that vmware does it
to a _very_ limited extent (using the vmware tools you install in the guest
- last I checked it was used to enhance the display/mouse/etc.).

Ok, this was somewhat offtopic.

Josef 'Jeff' Sipek.

-- 
Only two things are infinite, the universe and human stupidity, and I'm not
sure about the former.
		- Albert Einstein
