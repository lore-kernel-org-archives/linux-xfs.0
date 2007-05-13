Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 20:09:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4D38vfB027310
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 20:08:58 -0700
Message-ID: <46468148.7000708@sandeen.net>
Date: Sat, 12 May 2007 22:08:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Review: Concurrent Multi-File Data Streams
References: <20070511003606.GB85884050@sgi.com> <p73sla1ev7o.fsf@bingen.suse.de>
In-Reply-To: <p73sla1ev7o.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Andi Kleen wrote:

> Also centisecs is a really ugly unit whose use should be probably not propagated.
> 
> -Andi

Hmm at one point I thought the preferred unit for this sort of tuneable 
*was* centisecs.  What's the unit du jour?

[root@neon ~]# sysctl -a  |grep cent
vm.dirty_expire_centisecs = 2999
vm.dirty_writeback_centisecs = 499
fs.xfs.age_buffer_centisecs = 1500
fs.xfs.xfsbufd_centisecs = 100
fs.xfs.xfssyncd_centisecs = 3000

I think xfs was following the vm lead at one point.

-Eric
