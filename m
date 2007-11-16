Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Nov 2007 03:03:18 -0800 (PST)
Received: from smtp118.sbc.mail.sp1.yahoo.com (smtp118.sbc.mail.sp1.yahoo.com [69.147.64.91])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAGB3B0g032644
	for <linux-xfs@oss.sgi.com>; Fri, 16 Nov 2007 03:03:12 -0800
Date: Fri, 16 Nov 2007 03:03:15 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071116110315.GA27969@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de> <20071116003410.GA16797@puku.stupidest.org> <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com

On Fri, Nov 16, 2007 at 10:17:17AM +0100, Christian Kujau wrote:

> OK, I'll try this. I hope this can be fixed somehow before 2.6.24...

Well, one simple nasty idea would be something like:

diff --git a/fs/Kconfig b/fs/Kconfig
index 429a002..da231fd 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1604,7 +1604,7 @@ config NFS_FS
 
 config NFS_V3
 	bool "Provide NFSv3 client support"
-	depends on NFS_FS
+	depends on NFS_FS && !XFS
 	help
 	  Say Y here if you want your NFS client to be able to speak version
 	  3 of the NFS protocol.

So people who are likely to be affect just side-step the issue until
it's resolved.
