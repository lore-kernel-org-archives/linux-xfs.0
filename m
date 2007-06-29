Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 01:14:04 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T8DutL027964
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 01:13:58 -0700
Date: Fri, 29 Jun 2007 10:13:57 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: xfs_fsr, performance related tweaks
Message-ID: <20070629081357.GC14519@one.firstfloor.org>
References: <4683ADF5.9050901@corky.net> <1183075929.15488.148.camel@edge.yarra.acx> <4684A728.1050405@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684A728.1050405@corky.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: nscott@aconex.com, xfs@oss.sgi.com, andi@firstfloor.org

> I run fsr all the time because in my case there is hundreds of gigs of 
> new data added to each file system every day, some of it does badly need 
> to be defragged as the files added are actively being served, not just 

It might be better to investigate why XFS does such a poor job
for your workload in the first case. Unless the file systems
are always nearly full or you have a lot of holes it shouldn't fragment
that badly in the first place.

-Andi
