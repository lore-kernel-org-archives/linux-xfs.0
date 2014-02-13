Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 955A97F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:14:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16980AC00B
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:14:43 -0800 (PST)
Received: from mail-pb0-f49.google.com (mail-pb0-f49.google.com
	[209.85.160.49]) by cuda.sgi.com with ESMTP id w5eX0kQ8SeIDwHpC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:14:39 -0800 (PST)
Received: by mail-pb0-f49.google.com with SMTP id up15so11307552pbc.8
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:14:39 -0800 (PST)
Date: Thu, 13 Feb 2014 14:14:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
In-Reply-To: <alpine.DEB.2.19.4.1402131158590.6233@trent.utfs.org>
Message-ID: <alpine.DEB.2.02.1402131413070.13899@chino.kir.corp.google.com>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
	<alpine.DEB.2.19.4.1402131158590.6233@trent.utfs.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, 13 Feb 2014, Christian Kujau wrote:

> > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > the WARNING below was printed.
> > 
> > Shortly after, a lockdep warning appeared (possibly related to my 
> > post to the XFS list yesterday[0]).
> 
> Sigh, only _after_ sending the email, I came across an earlier posting on 
> lkml: http://marc.info/?l=linux-mm&m=139145788623391
> 

There's a fix for that: http://marc.info/?l=linux-kernel&m=139145999324131
or alternatively wait for 3.14-rc3 which will already have it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
