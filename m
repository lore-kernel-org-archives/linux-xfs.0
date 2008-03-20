Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 13:37:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2KKb3pD006418
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 13:37:06 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11502FE1E45
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 13:37:36 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id Hz0cRFjp5GFMAGoq for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 13:37:36 -0700 (PDT)
Date: Thu, 20 Mar 2008 16:37:35 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix xfsqa 049 when using whole scratch device
Message-ID: <20080320203735.GD16357@josefsipek.net>
References: <47E1CCF0.9070904@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E1CCF0.9070904@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 19, 2008 at 09:33:20PM -0500, Eric Sandeen wrote:
> if SCRATCH_DEV happens to be a whole device, mke2fs will wait
> for confirmation.
> 
> (mke2fs -F would work, too...)

Tested; does NOT cause a regression.

Josef 'Jeff' Sipek.

-- 
Failure is not an option,
It comes bundled with your Microsoft product.
