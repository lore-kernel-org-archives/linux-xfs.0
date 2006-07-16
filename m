Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 10:33:58 -0700 (PDT)
Received: from amanpulo.hosting.qsr.com.ph (amanpulo.hosting.qsr.com.ph [64.34.170.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6GHXMDW015224
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 10:33:22 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id C1F71C06F478
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 01:32:49 +0800 (PHT)
Received: from musang.free.net.ph (amanpulo.hosting.qsr.com.ph [64.34.170.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id 54DE5C0001FD
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 01:32:42 +0800 (PHT)
Date: Mon, 17 Jul 2006 01:32:38 +0800
From: Federico Sevilla III <jijo@free.net.ph>
Subject: Re: XFS and write barrier
Message-ID: <20060716173238.GD3417@free.net.ph>
References: <200607151248.56603.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200607151248.56603.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> I am currently gathering information to write an article about journal
> filesystems with emphasis on write barrier functionality, how it
> works, why journalling filesystems need write barrier and the current
> implementation of write barrier support for different filesystems.

Cool! Would you by any chance have information on the interaction
between journal filesystems with write barrier functionality, and
software RAID (md)? Based on my experience with 2.6.17, XFS detects that
the underlying software RAID 1 device does not support barriers and
therefore disables that functionality.

Cheers!

 --> Jijo

-- 
Federico Vicente C. Sevilla III
Information Technology Consultant
Q Software Research Corporation
Website: http://jijo.free.net.ph
