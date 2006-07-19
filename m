Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 07:11:26 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JEB7DW009520
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 07:11:07 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060719055621.GA1491@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <17595.47312.720883.451573@base.ty.sabi.co.UK>
	 <1153262166.2669.267.camel@localhost.localdomain>
	 <17597.27469.834961.186850@base.ty.sabi.co.UK>
	 <1153272044.2669.282.camel@localhost.localdomain>
	 <20060719055621.GA1491@tuatara.stupidest.org>
Content-Type: text/plain
Date: Wed, 19 Jul 2006 10:10:06 -0400
Message-Id: <1153318206.2691.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Tue, 2006-07-18 at 22:56 -0700, Chris Wedgwood wrote:
> On Tue, Jul 18, 2006 at 09:20:44PM -0400, Ming Zhang wrote:
> 
> > when u say large parallel storage system, you mean independent
> > spindles right? but most people will have all disks configured in
> > one RAID5/6 and thus it is not parallel any more.
> 
> it depends, you might have 100s of spindles in groups, you don't make
> a giant raid5/6 array with that many disks, you make a number of
> smaller arrays

right

> 
> > i think with write barrier support, system without UPS should be ok.
> 
> with barrier support a UPS shouldn't be necessary
> 
> > considering even u have UPS, kernel oops in other parts still can
> > take the FS down.
> 

i mean with UPS and huge write cache, but no write barrier.

> but a crash won't cause writes to be 'reordered'
> 
> 
> reordering is bad because the fs pushes writes down in a manner that
> means when it comes back it will be able to make it self consistent,
> so if you have a number of writes pending and some of them are lost,
> and those that are lost are not the most recent writes because of
> reordering, you can end up with a corrupt fs
