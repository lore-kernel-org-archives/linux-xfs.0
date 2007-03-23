Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 14:32:54 -0700 (PDT)
Received: from postfix1-g20.free.fr (postfix1-g20.free.fr [212.27.60.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2NLWn6p017830
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 14:32:50 -0700
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 76297BFDD98
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 22:10:22 +0100 (CET)
Received: from [192.168.100.11] (alf94-14-88-166-211-59.fbx.proxad.net [88.166.211.59])
	by smtp5-g19.free.fr (Postfix) with ESMTP id BE7798B9D
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 22:10:19 +0100 (CET)
Subject: Re: xfs_repair on Debian testing 64bits
From: Patrick Noel <patrick.noel.g@free.fr>
In-Reply-To: <20070323162522.GA27240@pc51072.physik.uni-regensburg.de>
References: <1174655443.5441.37.camel@localhost.localdomain>
	 <20070323162522.GA27240@pc51072.physik.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 23 Mar 2007 22:10:14 +0100
Message-Id: <1174684214.5758.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Yes H for show threads as if they were processes

with ps xa under debian sarge i saw the threads

Thanks

Patrick

Le vendredi 23 mars 2007 à 17:25 +0100, Christian Guggenberger a écrit :
> > i try to force 8 thread with -o thread=8
> > 
> > and i have this message :
> > 
> >  xfs_repair -o thread=8 /dev/sdb1
> >  - creating 8 worker thread(s)
> > 
> > 
> > but with ps xa  | grep repair i see only one thread.
> >
> 
> IMHO, you'll need 'ps xaH' 
> 
> cheers.
>  - Christian
