Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Nov 2007 02:57:58 -0800 (PST)
Received: from spike.grumly.eu.org (spike.grumly.eu.org [195.5.253.226])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA7AvoJU004674
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2007 02:57:54 -0800
Date: Wed, 7 Nov 2007 11:58:14 +0100
From: Cedric - Equinoxe Media <cedric@e-m.fr>
Subject: Re: xfs crash
Message-ID: <20071107105814.GD25295@e-m.fr>
References: <20071105215135.GA12238@e-m.fr> <20071106082632.GU995458@sgi.com> <20071106092157.GB16694@e-m.fr> <20071106160721.GB25295@e-m.fr> <20071106205556.GZ995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071106205556.GZ995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On 07/11/2007 07:55, David Chinner wrote:
> On Tue, Nov 06, 2007 at 05:07:21PM +0100, Cedric - Equinoxe Media wrote:
> > I just had exactly the same crash again today :
> > /dev/sda4 on /filer type xfs (rw,noexec,nosuid,nodev,noatime)
> 
> What did xfs_check tell you about the corruption?

I had quite the same message as last time, forgot to copy/paste...

> > Seems to be again on a setattr() ?
> 
> Doing a truncation freeing some blocks.
> 
> What is the client doing (i.e. io patterns, application, etc) to
> cause this? can you reproduce it without NFS being used? To track
> this down I'm going to need a reproducable test case....

It is 5 web servers with php as nfsv3 clients.

> Seeing this is a brand new server, have you run and soak or stress
> test on the raw storage to confirm it is error free?

I have run bonnie++ and memtest86+ with no errors.

I am now trying to recompile linux without nfsv4, ACL and all
experimental features of nfs and xfs.

-- 
Cédric Tabary
Ingénieur réseau - Equinoxe Media
+33 (0)6 77 45 80 15 
