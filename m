Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 14:02:12 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAFM26u7012315
	for <linux-xfs@oss.sgi.com>; Thu, 15 Nov 2007 14:02:07 -0800
Date: Thu, 15 Nov 2007 23:01:56 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
In-Reply-To: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
Message-ID: <alpine.DEB.0.99999.0711152258130.30603@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com

On Thu, 15 Nov 2007, Christian Kujau wrote:
> Upon accessing the /data/sub part of the CIFS share, the client hung, waiting 
> for the server to respond (the [cifs] kernel thread on the client was 
> spinning, waiting for i/o). On the server, similar things as with the nfsd 
> processes happened

Turns out that the CIFS only hung because the server was already stuck 
because of the nfsd/XFS issue. After rebooting the server, I was 
able to access the CIFS shares (the xfs partition too) just fine. Yes, the 
xfs partition itsself has been checked too and no errors were found.

C.
-- 
BOFH excuse #348:

We're on Token Ring, and it looks like the token got loose.
