Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 06:58:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6NDwhbm020959
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 06:58:45 -0700
Message-ID: <46A4B416.5040105@sandeen.net>
Date: Mon, 23 Jul 2007 08:58:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Remove Makefile wrappers in XFS
References: <200707231100.36852.ak@suse.de>
In-Reply-To: <200707231100.36852.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

Andi Kleen wrote:
> Makefile (and Kbuild) would include Makefile-linux-26
> I doubt XFS will really still compile on 2.4; so drop that. This
> moves Makefile-linux-26 into Makefile and drops Kbuild.
> Also having wrappers as both Kbuild and Makefile seemed redundant
> anyways.
> 
> The patch is relatively large because it renames a file, but
> no functional changes.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>


> +
> +EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char

The other thing we should technically do is -I$(src) -I$(src)/linux-2.6
etc, I think... and a few other things like this.  I've been sitting on
that patch for ages, should send it in... will do soon.

-Eric
