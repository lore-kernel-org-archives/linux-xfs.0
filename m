Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Apr 2007 13:49:55 -0700 (PDT)
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3RKnlfB010551
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 13:49:48 -0700
Date: Fri, 27 Apr 2007 13:42:07 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070427204207.GA29551@tuatara.stupidest.org>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com> <20070427144327.GC22949@lazybastard.org> <20070427174613.GA8228@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427174613.GA8228@osiris.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Fri, Apr 27, 2007 at 07:46:13PM +0200, Heiko Carstens wrote:

> If one insists to have fd at first argument, what is wrong with
> having u32 arguments only?

Well, I was one of those who objected as it seems *UGLY* to me.

> It's not that this syscall comes even close to what can be
> considered performance critical...

Right.

> It adds userspace overhead for one architecture. Every *trace and
> *libc needs special handling on s390 for this syscall. I would
> prefer to avoid this.

I'm not that bothered about it.  I would prefer it did use clean
64-bit arguments, but given it's a non-critical syscall I'm don't
think the aesthetics are worth impossing crud on s390 for.
