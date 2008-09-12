Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 10:08:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8CH8lo0017322
	for <xfs@OSS.SGI.com>; Fri, 12 Sep 2008 10:08:47 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D432F434EB6
	for <xfs@OSS.SGI.com>; Fri, 12 Sep 2008 10:10:17 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id uEehUeIgOZMNj10b for <xfs@OSS.SGI.com>; Fri, 12 Sep 2008 10:10:17 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1)
	id 1Ke9Aa-0003Z4-En
	for <xfs@OSS.SGI.com>; Fri, 12 Sep 2008 14:58:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18634.30099.698572.877313@tree.ty.sabi.co.uk>
Date: Fri, 12 Sep 2008 14:58:43 +0100
Subject: Re: What happened to my XFS?
In-Reply-To: <20080912121655.7430a630@harpe.intellique.com>
References: <20080912121655.7430a630@harpe.intellique.com>
From: pg_xfs2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

> This is a 39TB XFS filesystem, that I use for a PVFS2
> cluster.

How long did check/repair take?

> I'm running the following hardware configuration : 3 identical
> servers with 2 Opteron dual core, running Linux 2.6.24.7 in 64
> bits mode, SMP and NUMA (debian etch), 4GB RAM, 48 1TB Seagate
> drives, in 2 striped (LVM2) RAID-6 arrays.

That looks like each server has a RAID0 of two 22+2 RAID6s (or
perhaps two 20+2 RAID6 given the total size, but perhaps the
filesystem size is 39TiB, not 39TB).

That is a truly STUNNING configuration. :-)

I wonder what the 'su'/'sw' parameters for that filesystem look
like, they could be AMAZING too. :-)

[ ... ]
