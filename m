Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 05:53:21 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l42CrGfB024777
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 05:53:17 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l42CrBgT015874
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 08:53:11 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l42CrB9i554574
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 08:53:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l42CrAET015347
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 08:53:10 -0400
Date: Wed, 2 May 2007 18:23:12 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070502125312.GA5845@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430052559.GA13145@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Chinner <dgc@sgi.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
> On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
> 
> > For FA_ALLOCATE, it's supposed to change the file size if we
> > allocate past EOF, right?
> 
> I would argue no.  Use truncate for that.

The patch I posted for ext4 *does* change the filesize after
preallocation, if required (i.e. when preallocation is after EOF).
I may have to change that, if we decide on not doing this.

--
Regards,
Amit Arora 
