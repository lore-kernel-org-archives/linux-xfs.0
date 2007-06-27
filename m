Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 03:16:26 -0700 (PDT)
Received: from waldorf.loreland.org (ip186.digipost.co.nz [203.110.30.186] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5RAGKtL021835
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 03:16:21 -0700
Message-ID: <46823480.1000305@loreland.org>
Date: Wed, 27 Jun 2007 10:57:20 +0100
From: James Braid <jamesb@loreland.org>
MIME-Version: 1.0
Subject: Re: reasonable xfs fs size for 30-100 TB?
References: <20070626171719.GD32546@p15145560.pureserver.info>
In-Reply-To: <20070626171719.GD32546@p15145560.pureserver.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs-oss <xfs@oss.sgi.com>

Ralf Gross wrote:
> My main concern is the amount of RAM I need for a fsck of the xfs fs.
> Last time I search for the xfs requirements, I found the rule of
> thumb: 2 GB RAM for 1 TB of disk storage + some RAM per x inodes.

A real world example: we have a ~70TB filesystem, with ~70M inodes and 
xfs_repair uses about 13-15GB of memory IIRC (haven't run a repair in a 
while) using a recentish 2.8.x version.

Hope that helps.
