Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 09:15:12 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HGF667028929
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 09:15:08 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 5FE0D301C603
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:15:08 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a8b8pMjF+2qW for <linux-xfs@oss.sgi.com>;
	Wed, 17 Oct 2007 18:15:08 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 3CCCE300EB21
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:15:08 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id AD82EF08D9018
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:15:04 +0200 (CEST)
Date: Wed, 17 Oct 2007 18:15:04 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20071017161504.GA13077@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EA9741.6060303@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 09:14:25AM -0500, Eric Sandeen wrote:
> Louis-David Mitterrand wrote:
> > Hello,
> > 
> > While cleaning up /lost+found a directory resisted removal:
> > 
> > 	sylla:/lost+found# rm 1879629858 -rf
> > 	rm: cannot remove directory `1879629858': Directory not empty
> > 
> > The directory _is_ empty and "-rf" should remove it anyway, so this 
> > looks like a fs error.
> > 
> > This is on debian unstable with 2.6.23-rc6.
> 
> Any errors in the system logs?  I'd try most recent xfs_repair next.  If
> that doesn't fix it, make an xfs_metadump for Barry to look at.  :)
> Make a backup first if you're paranoid.

Hi again,

Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't 
remove that file:

sylla:/# rm /lost+found/3912672557
rm: cannot remove `/lost+found/3912672557': Operation not permitted

sylla:/# ls -li /lost+found/3912672557                                 
3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz
