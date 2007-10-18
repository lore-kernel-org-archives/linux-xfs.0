Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 06:26:30 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IDQJ0K026867
	for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 06:26:21 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 7B9493015E28
	for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 15:11:17 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WY49l3QlOpxk for <linux-xfs@oss.sgi.com>;
	Thu, 18 Oct 2007 15:11:17 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 585E53013BA2
	for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 15:11:17 +0200 (CEST)
Received: from styx.apartia.fr (styx.apartia.fr [10.0.3.109])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "styx.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by zenon.apartia.fr (Postfix) with ESMTP id CABDBF08AA01E
	for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 15:11:16 +0200 (CEST)
Date: Thu, 18 Oct 2007 15:11:16 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20071018131116.GA11957@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <20071017212434.GB995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017212434.GB995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Thu, Oct 18, 2007 at 07:24:39AM +1000, David Chinner wrote:
> On Wed, Oct 17, 2007 at 06:15:04PM +0200, Louis-David Mitterrand wrote:
> > Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't 
> > remove that file:
> > 
> > sylla:/# rm /lost+found/3912672557
> > rm: cannot remove `/lost+found/3912672557': Operation not permitted
> > 
> > sylla:/# ls -li /lost+found/3912672557                                 
> > 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz
> 
> Can you post the output of:
> 
> # xfs_db -r -c "inode 3912672557" -c "p" <device>

Here:

core.magic = 0x494e
core.mode = 0120777
core.version = 1
core.format = 1 (local)
core.nlinkv1 = 1
core.uid = 0
core.gid = 0
core.flushiter = 1
core.atime.sec = Sun Apr  9 19:10:38 2006
core.atime.nsec = 316368304
core.mtime.sec = Sun Apr  9 19:10:38 2006
core.mtime.nsec = 316368304
core.ctime.sec = Sun Apr  9 19:10:38 2006
core.ctime.nsec = 317368152
core.size = 9
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0x4d291522
core.dmstate = 21036
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 1
core.append = 1
core.sync = 0
core.noatime = 1
core.nodump = 0
core.rtinherit = 1
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 1
core.gen = 0
next_unlinked = null
u.symlink = "unix.7.gz"


Thanks,
