Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 06:11:51 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JDBcDW001709
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 06:11:38 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <17598.2129.999932.67127@base.ty.sabi.co.UK>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <17595.47312.720883.451573@base.ty.sabi.co.UK>
	 <1153262166.2669.267.camel@localhost.localdomain>
	 <17597.27469.834961.186850@base.ty.sabi.co.UK>
	 <1153272044.2669.282.camel@localhost.localdomain>
	 <17598.2129.999932.67127@base.ty.sabi.co.UK>
Content-Type: text/plain
Date: Wed, 19 Jul 2006 09:11:10 -0400
Message-Id: <1153314670.2691.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>
Cc: Linux XFS <linux-xfs@oss.sgi.com>

On Wed, 2006-07-19 at 11:24 +0100, Peter Grandi wrote:
> >>> On Tue, 18 Jul 2006 21:20:44 -0400, Ming Zhang <mingz@ele.uri.edu> said:
> 
> [ ... ]
> 
> mingz> when u say large parallel storage system, you mean
> mingz> independent spindles right? but most people will have all
> mingz> disks configured in one RAID5/6 and thus it is not
> mingz> parallel any more.
> 
> As I was saying...
> 
>   pg> Most of the reports about ''corruption'' are consequences
>   pg> of not being aware of what it was designed for, how it
>   pg> works and how it should be used...
> 
>   mingz> [ .. ] example on what is an improper use?
>   pg> Well, this mailing list is full of them :-).
> 
>   pg> But then I have seen people building RAIDs stuffing in a
>   pg> couple dozen drives from the same shipping box, [ ... ]
> 
> :-)
> 
> BTW as to these:
> 
>   * A 64 bit system.
>   * With a large, parallel storage system.
>   * The block IO system handles all storage errors.
>   * With backups of the contents of the storage system.
> 
> I forgot a very essential one:
> 
>   * With lots of RAM, size proportional to that of the largest filesystem.
> 
> [ ... ]
> 

what kind of "ram vs fs" size ratio here will be a safe/good/proper one?
any rule of thumb? thanks!

hope not 1:1. :)

Ming
