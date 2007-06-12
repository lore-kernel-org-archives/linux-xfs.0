Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 00:14:43 -0700 (PDT)
Received: from bay0-omc1-s19.bay0.hotmail.com (bay0-omc1-s19.bay0.hotmail.com [65.54.246.91])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5C7EdWt024452
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 00:14:40 -0700
Message-ID: <BAY103-DAV164930BAD25A9841FEF442B2190@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl> <20070607130505.GE85884050@sgi.com> <BAY103-DAV141D991980E54836534A00B2250@phx.gbl> <20070612061440.GQ86004887@sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Tue, 12 Jun 2007 09:14:27 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

David Chinner wrote:

> On Fri, Jun 08, 2007 at 03:59:39PM +0200, Marco Berizzi wrote:
> > David Chinner wrote:
> > > Where we saw signs of on disk directory corruption. Have you run
> > > xfs_repair successfully on the filesystem since you reported
> > > this?
> >
> > yes.
> >
> > > If you did clean up the error, does xfs_repair report the same
sort
> > > of error again?
> >
> > I have run xfs_repair this morning.
> > Here is the report:
>
> <reports no on disk errors>
>
> > > Have you run a 2.6.16-rcX or 2.6.17.[0-6] kernel since you last
> > > reported this problem?
> >
> > No. I have run only 2.6.19.x and 2.6.21.x
> >
> > After the xfs_repair I have remounted the file system.
> > After few hours linux has crashed with this message:
> > BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
> > I have also the monitor bitmap.
>
> This is sounding like memory corruption is no corruption is being
> found on disk by xfs_repair.  Have you run memtest86 on that box to
> see if it's got bad memory?

Yes. I have run memtest for one week:
no errors.
I have also changed the mother board,
scsi controller and ram. Only the cpu
and the 2 hot swap scsi disks were
not replaced. IMHO this isn't an
hardware problem, because the kernel
with debugging options enabled didn't
crash for a long time (>1 month). Just
for record, at this moment this box is
running 2.6.22-rc4 with no debug
options enabled. I will keep you
informed.
Thanks everybody for the support.
