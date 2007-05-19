Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 May 2007 00:01:41 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4J71YfB002584
	for <xfs@oss.sgi.com>; Sat, 19 May 2007 00:01:35 -0700
Date: Fri, 18 May 2007 23:44:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6][TAKE4] fallocate system call
Message-Id: <20070518234444.f53a4230.akpm@linux-foundation.org>
In-Reply-To: <20070517141115.GA24260@amitarora.in.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070517141115.GA24260@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, 17 May 2007 19:41:15 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> fallocate() is a new system call being proposed here which will allow
> applications to preallocate space to any file(s) in a file system.

I merged the first three patches into -mm, thanks.

All the system call numbers got changed due to recent additions.  They
may change in the future, too - nothing is stable until the code lands
in mainline.

I didn't merge any of the ext4 changes as they appear to be in Ted's
devel tree.  Although I didn't check that they are 100% the same in 
that tree.

What's the plan to get some ext4 updates into mainline, btw?  Things
seem to be rather gradual.
