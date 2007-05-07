Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 04:10:42 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47BAbfB018894
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 04:10:39 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47BBYno028901
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:11:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47BAbK5550866
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:10:37 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47BAaUk020671
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:10:36 -0400
Date: Mon, 7 May 2007 16:40:38 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070507111038.GB7012@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <20070504060731.GJ32602149@melbourne.sgi.com> <20070503232815.2f62a75e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503232815.2f62a75e.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 03, 2007 at 11:28:15PM -0700, Andrew Morton wrote:
> The above opengroup page only permits S_ISREG.  Preallocating directories
> sounds quite useful to me, although it's something which would be pretty
> hard to emulate if the FS doesn't support it.  And there's a decent case to
> be made for emulating it - run-anywhere reasons.  Does glibc emulation support
> directories?  Quite unlikely.
> 
> But yes, sounds like a desirable thing.  Would XFS support it easily if the above
> check was relaxed?

I think we may relax the check here and let the individual file system
decide if they support preallocation for directories or not. What do you
think ?

One thing to be thought in this case is the error code which should be
returned by the file system implementation, incase it doesn't support
preallocation for directories. Should it be -ENODEV (to match with what
posix says) , or something else (which might make more sense in this
case) ?

--
Regards,
Amit Arora
