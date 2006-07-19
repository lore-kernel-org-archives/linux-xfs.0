Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 03:22:08 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JALcDW008804
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 03:21:53 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G39E3-0000Pz-UN
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 11:24:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17598.2129.999932.67127@base.ty.sabi.co.UK>
Date: Wed, 19 Jul 2006 11:24:17 +0100
Subject: Re: stable xfs
In-Reply-To: <1153272044.2669.282.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Tue, 18 Jul 2006 21:20:44 -0400, Ming Zhang <mingz@ele.uri.edu> said:

[ ... ]

mingz> when u say large parallel storage system, you mean
mingz> independent spindles right? but most people will have all
mingz> disks configured in one RAID5/6 and thus it is not
mingz> parallel any more.

As I was saying...

  pg> Most of the reports about ''corruption'' are consequences
  pg> of not being aware of what it was designed for, how it
  pg> works and how it should be used...

  mingz> [ .. ] example on what is an improper use?
  pg> Well, this mailing list is full of them :-).

  pg> But then I have seen people building RAIDs stuffing in a
  pg> couple dozen drives from the same shipping box, [ ... ]

:-)

BTW as to these:

  * A 64 bit system.
  * With a large, parallel storage system.
  * The block IO system handles all storage errors.
  * With backups of the contents of the storage system.

I forgot a very essential one:

  * With lots of RAM, size proportional to that of the largest filesystem.

[ ... ]
