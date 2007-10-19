Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Oct 2007 03:10:35 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9JAA8fP015451
	for <linux-xfs@oss.sgi.com>; Fri, 19 Oct 2007 03:10:10 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 621A6300E040
	for <linux-xfs@oss.sgi.com>; Fri, 19 Oct 2007 12:10:09 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sj61s8qKV9ir for <linux-xfs@oss.sgi.com>;
	Fri, 19 Oct 2007 12:10:09 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 3F2A1300E37B
	for <linux-xfs@oss.sgi.com>; Fri, 19 Oct 2007 12:10:09 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id ADA5AF08E6B1F
	for <linux-xfs@oss.sgi.com>; Fri, 19 Oct 2007 12:10:08 +0200 (CEST)
Date: Fri, 19 Oct 2007 12:10:08 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20071019101008.GA28175@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <20071017212434.GB995458@sgi.com> <20071018131116.GA11957@apartia.fr> <20071018220714.GM995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018220714.GM995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Oct 19, 2007 at 08:07:14AM +1000, David Chinner wrote:
> On Thu, Oct 18, 2007 at 03:11:16PM +0200, Louis-David Mitterrand wrote:
> > On Thu, Oct 18, 2007 at 07:24:39AM +1000, David Chinner wrote:
> > > On Wed, Oct 17, 2007 at 06:15:04PM +0200, Louis-David Mitterrand wrote:
> > > > Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't 
> > > > remove that file:
> > > > 
> > > > sylla:/# rm /lost+found/3912672557
> > > > rm: cannot remove `/lost+found/3912672557': Operation not permitted
> > > > 
> > > > sylla:/# ls -li /lost+found/3912672557                                 
> > > > 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz
> > > 
> > > Can you post the output of:
> > > 
> > > # xfs_db -r -c "inode 3912672557" -c "p" <device>
> > 
> > Here:
> > 
> > core.magic = 0x494e
> > core.mode = 0120777
> > core.version = 1
> > core.format = 1 (local)
> > core.nlinkv1 = 1
> .....
> > core.immutable = 1
>   ^^^^^^^^^^^^^^^^^^
> 
> You can't remove this link until you remove the immutable flag.
> 
> # xfs_io -r -c "chattr -i" /lost+found/3912672557

sylla:~# xfs_io -r -c "chattr -i" /lost+found/3912672557 
/lost+found/3912672557: No such file or directory

Tough cookie this one :)
