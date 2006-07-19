Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 22:56:57 -0700 (PDT)
Received: from smtp105.sbc.mail.mud.yahoo.com (smtp105.sbc.mail.mud.yahoo.com [68.142.198.204])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6J5ujDW001004
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 22:56:46 -0700
Date: Tue, 18 Jul 2006 22:56:21 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060719055621.GA1491@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain> <17595.47312.720883.451573@base.ty.sabi.co.UK> <1153262166.2669.267.camel@localhost.localdomain> <17597.27469.834961.186850@base.ty.sabi.co.UK> <1153272044.2669.282.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153272044.2669.282.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Tue, Jul 18, 2006 at 09:20:44PM -0400, Ming Zhang wrote:

> when u say large parallel storage system, you mean independent
> spindles right? but most people will have all disks configured in
> one RAID5/6 and thus it is not parallel any more.

it depends, you might have 100s of spindles in groups, you don't make
a giant raid5/6 array with that many disks, you make a number of
smaller arrays

> i think with write barrier support, system without UPS should be ok.

with barrier support a UPS shouldn't be necessary

> considering even u have UPS, kernel oops in other parts still can
> take the FS down.

but a crash won't cause writes to be 'reordered'


reordering is bad because the fs pushes writes down in a manner that
means when it comes back it will be able to make it self consistent,
so if you have a number of writes pending and some of them are lost,
and those that are lost are not the most recent writes because of
reordering, you can end up with a corrupt fs
