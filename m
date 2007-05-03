Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 03:34:34 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l43AYRfB018100
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 03:34:28 -0700
Date: Thu, 3 May 2007 03:34:25 -0700
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070503103425.GE6220@schatzie.adilger.int>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org> <20070502125312.GA5845@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502125312.GA5845@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Chris Wedgwood <cw@f00f.org>, David Chinner <dgc@sgi.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On May 02, 2007  18:23 +0530, Amit K. Arora wrote:
> On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
> > On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
> > 
> > > For FA_ALLOCATE, it's supposed to change the file size if we
> > > allocate past EOF, right?
> > 
> > I would argue no.  Use truncate for that.
> 
> The patch I posted for ext4 *does* change the filesize after
> preallocation, if required (i.e. when preallocation is after EOF).
> I may have to change that, if we decide on not doing this.

I think I'd agree - it may be useful to allow preallocation beyond EOF
for some kinds of applications (e.g. PVR preallocating live TV in 10
minute segments or something, but not knowing in advance how long the
show will actually be recorded or the final encoded size).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
