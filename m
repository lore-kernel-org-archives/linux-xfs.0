Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 01:56:11 -0700 (PDT)
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7V8tEDW013154
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 01:55:57 -0700
Date: Thu, 31 Aug 2006 01:54:30 -0700
From: Andrew Morton <akpm@osdl.org>
Subject: Re: kernel BUG in __xfs_get_blocks at
 fs/xfs/linux-2.6/xfs_aops.c:1293!
Message-Id: <20060831015430.6df0d8ba.akpm@osdl.org>
In-Reply-To: <20060831081726.GV5737019@melbourne.sgi.com>
References: <44F67847.6030307@cn.ibm.com>
	<20060831074742.GD807830@melbourne.sgi.com>
	<44F6979C.4070309@cn.ibm.com>
	<20060831081726.GV5737019@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Yao Fei Zhu <walkinair@cn.ibm.com>, linux-kernel@vger.kernel.org, haveblue@us.ibm.com, xfs@oss.sgi.com

On Thu, 31 Aug 2006 18:17:26 +1000
David Chinner <dgc@sgi.com> wrote:

> > BTW, I have CONFIG_PPC_64K_PAGES enabled.
> 
> But that might be a good place to start. Can you see if you can
> reproduce the problem without this config option set?

It would be useful to compare the compiler warning output for 64k pages
versus that for smaller-pages.  

Several quite worrisome-looking warnings are emitted from various parts of
the kernel with 64k pages.  Related to arithmetic on short types.
