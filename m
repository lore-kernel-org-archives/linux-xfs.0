Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 01:58:53 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T8wjtL008178
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 01:58:47 -0700
Date: Fri, 29 Jun 2007 10:58:46 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: xfs_fsr, performance related tweaks
Message-ID: <20070629085846.GD14519@one.firstfloor.org>
References: <4683ADF5.9050901@corky.net> <1183075929.15488.148.camel@edge.yarra.acx> <4684A728.1050405@corky.net> <20070629081357.GC14519@one.firstfloor.org> <4684C168.2050605@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684C168.2050605@corky.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: Andi Kleen <andi@firstfloor.org>, nscott@aconex.com, xfs@oss.sgi.com

On Fri, Jun 29, 2007 at 09:23:04AM +0100, Just Marc wrote:

> You might have hit the 
> nail on the head, some of the files it was not able to improve are on 
> filesystems that are almost full.    

Don't do that then. It's probably the reason you get the bad fragmentation
in the first place. Most file systems perform very poorly when
they are nearly full.

-Andi
