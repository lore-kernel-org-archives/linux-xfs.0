Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 04:37:34 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49BbSfB013664
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 04:37:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Date: Wed, 9 May 2007 21:37:22 +1000
From: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
In-Reply-To: <20070509111011.GA21619@in.ibm.com>
References: <20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426180332.GA7209@amitarora.in.ibm.com>
	<20070503212955.b1b6443c.akpm@linux-foundation.org>
	<17978.47502.786970.196554@cargo.ozlabs.ibm.com>
	<20070509101507.GA26056@in.ibm.com>
	<17985.42884.971318.859402@cargo.ozlabs.ibm.com>
	<20070509111011.GA21619@in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: suparna@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

Suparna Bhattacharya writes:

> > Of course the interface used by an application program would have the
> > fd first.  Glibc can do the translation.
> 
> I think that was understood.

OK, then what does it matter what the glibc/kernel interface is, as
long as it works?

It's only a minor point; the order of arguments can vary between
architectures if necessary, but it's nicer if they don't have to.
32-bit powerpc will need to have the two int arguments adjacent in
order to avoid using more than 6 argument registers at the user/kernel
boundary, and s390 will need to avoid having a 64-bit argument last
(if I understand it correctly).

Paul.
