Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 17:24:52 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0H1Oihx023901
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 17:24:46 -0800
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2684E52A922
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 17:25:02 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id sEIKgIYnETQ9CRfD for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 17:25:02 -0800 (PST)
Subject: Re: Question related to XFS sync , especially fsync
From: Andi Kleen <andi@firstfloor.org>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	<20080114224245.GT155259@sgi.com>
	<d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
	<478CCEAC.9010008@sandeen.net>
	<1200436012.9463.184.camel@edge.scott.net.au>
	<d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com>
	<20080116064840.GA5725@puku.stupidest.org>
	<d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>
Date: Thu, 17 Jan 2008 02:25:00 +0100
In-Reply-To: <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com> (Gopala Krishna's message of "Wed\, 16 Jan 2008 12\:55\:17 +0530")
Message-ID: <p73ejchkzv7.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: Chris Wedgwood <cw@f00f.org>, nscott@aconex.com, xfs@oss.sgi.com

"Gopala Krishna" <gopalakrishna.n.m@gmail.com> writes:

> we need to get information about
> file like it's extent information and associated block numbers etc.
 To
> extract these there is no system call 

Actually there is the FIOBMAP ioctl for data blocks. e.g. it's used by
boot loaders like lilo to create a block map to read a file without
knowledge of the file system. Should work on all file systems that
support lilo.

It won't give you information about metadata blocks though.

-Andi
