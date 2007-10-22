Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Oct 2007 00:06:34 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9M74ONI009116
	for <linux-xfs@oss.sgi.com>; Mon, 22 Oct 2007 00:06:27 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 65735302312F
	for <linux-xfs@oss.sgi.com>; Mon, 22 Oct 2007 09:04:26 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PtH1ZbM-quuj for <linux-xfs@oss.sgi.com>;
	Mon, 22 Oct 2007 09:04:26 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 14C343000407
	for <linux-xfs@oss.sgi.com>; Mon, 22 Oct 2007 09:04:26 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 4E28DF0AF2F09
	for <linux-xfs@oss.sgi.com>; Mon, 22 Oct 2007 09:04:25 +0200 (CEST)
Date: Mon, 22 Oct 2007 09:04:25 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20071022070425.GA15091@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <20071017212434.GB995458@sgi.com> <20071018131116.GA11957@apartia.fr> <20071018220714.GM995458@sgi.com> <20071019101008.GA28175@apartia.fr> <20071021235052.GV995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021235052.GV995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Mon, Oct 22, 2007 at 09:50:52AM +1000, David Chinner wrote:
> On Fri, Oct 19, 2007 at 12:10:08PM +0200, Louis-David Mitterrand wrote:
> > On Fri, Oct 19, 2007 at 08:07:14AM +1000, David Chinner wrote:
> > > On Thu, Oct 18, 2007 at 03:11:16PM +0200, Louis-David Mitterrand wrote:
> > > > On Thu, Oct 18, 2007 at 07:24:39AM +1000, David Chinner wrote:
> > > > > On Wed, Oct 17, 2007 at 06:15:04PM +0200, Louis-David Mitterrand wrote:
> > > > > > Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't 
> > > > > > remove that file:
> > > > > > 
> > > > > > sylla:/# rm /lost+found/3912672557
> > > > > > rm: cannot remove `/lost+found/3912672557': Operation not permitted
> > > > > > 
> > > > > > sylla:/# ls -li /lost+found/3912672557                                 
> > > > > > 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz
> > > > > 
> > > > > Can you post the output of:
> > > > > 
> > > > > # xfs_db -r -c "inode 3912672557" -c "p" <device>
> > > > 
> > > > Here:
> > > > 
> > > > core.magic = 0x494e
> > > > core.mode = 0120777
> > > > core.version = 1
> > > > core.format = 1 (local)
> > > > core.nlinkv1 = 1
> > > .....
> > > > core.immutable = 1
> > >   ^^^^^^^^^^^^^^^^^^
> > > 
> > > You can't remove this link until you remove the immutable flag.
> > > 
> > > # xfs_io -r -c "chattr -i" /lost+found/3912672557
> > 
> > sylla:~# xfs_io -r -c "chattr -i" /lost+found/3912672557 
> > /lost+found/3912672557: No such file or directory
> 
> Strange. This implies that lookup can't find inode # 3912672557.
> We know it is there...
> 
> How many other files in the directory? Can you get the inode number
> for the lost+found directory and dump that with xfs_db (as per above)?
> 
> Also, what happens if you "touch /lost+found/unix.7.gz" and try again?

sylla:/lost+found# touch /lost+found/unix.7.gz   

sylla:/lost+found# l
total 0
lrwxrwxrwx 1 root root 9 2006-04-09 19:10 3912672557 -> unix.7.gz
-rw-r--r-- 1 root root 0 2007-10-22 09:02 unix.7.gz

sylla:/lost+found# xfs_io -r -c "chattr -i" /lost+found/3912672557

sylla:/lost+found# rm 3912672557
rm: remove symbolic link `3912672557'? y
rm: cannot remove `3912672557': Operation not permitted
