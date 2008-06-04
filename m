Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 17:32:28 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m540WPtF005785
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 17:32:25 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] scale down 074 on lower end machines
References: <20080515173913.GA11494@lst.de>
Date: Wed, 04 Jun 2008 10:33:17 +1000
In-Reply-To: <20080515173913.GA11494@lst.de> (Christoph Hellwig's message of
	"Thu, 15 May 2008 19:39:13 +0200")
Message-ID: <nccskvuujhu.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@lst.de> writes:

> 074 takes ages to complete on my kvm test VM, but scaling it back to the
> level used on IRIX makes it complete in slightly under 10 minutes.
>
> I'm not sure if checking for UP vs SMP is the right way to go into slow
> mode, but I couldn't think of anything better.

Looks good enough for now.
-- 
Niv Sardi
