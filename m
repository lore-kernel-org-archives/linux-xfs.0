Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 10:41:04 -0700 (PDT)
Received: from postfix1-g20.free.fr (postfix1-g20.free.fr [212.27.60.42])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9AHewdf017743
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 10:41:00 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 581631B55FA5
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 19:15:04 +0200 (CEST)
Date: Wed, 10 Oct 2007 19:14:52 +0200
From: Emmanuel Florac <eflorac@free.fr>
Subject: Re: running xfs_repair on large partitions
Message-ID: <20071010191452.1fdad848@galadriel.home>
In-Reply-To: <20071010143337.GA2815@apartia.fr>
References: <20071010143337.GA2815@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Le Wed, 10 Oct 2007 16:33:38 +0200 vous écriviez:

> 1) it would be nice to have a way to know xfs_repair's version
> (-V ?), when using it from a rescue disk I'm never sure if I should
> get a newer one.

Did you try "xfs_repair -V" as you suggest? On my system, it replies
with the version...

> 2) on a 32bit system, using xfsprogs version 2.9.0 , it seems
> xfs_repair will fail if its process exceeds 4G. Is that right? Is
> there a way to circumvent that limitation?

No, this is precisely what 32 bits mean. A 32 bits process can't
address more than 2^32 bits, which is 4GB. However I'm
surprised you have this problem; I've xfs_repaired up to 16TB
filesystem (maximum manageable with a 32 bits kernel ) without such
problem.
-- 
Since we're all here, we must not be all there.
		-- Bob "Mountain" Beck
