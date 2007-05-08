Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 07:48:02 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48ElvfB024039
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 07:47:58 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l48EluvR013297
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 10:47:56 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l48EluWL551990
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 10:47:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l48ElujD011654
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 10:47:56 -0400
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <20070508105247.GA1950@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426181332.GD7209@amitarora.in.ibm.com>
	 <20070503213133.d1559f52.akpm@linux-foundation.org>
	 <20070507120719.GD7012@amitarora.in.ibm.com>
	 <1178551477.12900.6.camel@kleikamp.austin.ibm.com>
	 <20070508105247.GA1950@amitarora.in.ibm.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 09:47:54 -0500
Message-Id: <1178635675.11344.10.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Tue, 2007-05-08 at 16:22 +0530, Amit K. Arora wrote:
> On Mon, May 07, 2007 at 10:24:37AM -0500, Dave Kleikamp wrote:
> > On Mon, 2007-05-07 at 17:37 +0530, Amit K. Arora wrote:
> > > On Thu, May 03, 2007 at 09:31:33PM -0700, Andrew Morton wrote:

> > > > So we don't implement fallocate on bitmap-based files!  Well that's huge
> > > > news.  The changelog would be an appropriate place to communicate this,
> > > > along with reasons why, or a description of the plan to fix it.
> > > 
> > > Ok. Will add this in the function description as well.
> > > 
> > > > Also, posix says nothing about fallocate() returning ENOTTY.
> > > 
> > > Right. I don't seem to find any suitable error from posix description.
> > > Can you please suggest an error code which might make more sense here ?
> > > Will -ENOTSUPP be ok ? Since we want to say here that we don't support
> > > non-extent files.
> > 
> > Isn't the idea that libc will interpret -ENOTTY, or whatever is returned
> > here, and fall back to the current library code to do preallocation?
> > This way, the caller of fallocate() will never see this return code, so
> > it won't violate posix.
> 
> You are right.
> 
> But, we still need to "standardize" (and limit) the error codes
> which we should return from kernel when we want to fall back on the
> library implementation. The posix_fallocate() library function will have
> to look for a set of errors from fallocate() system call, upon receiving
> which it will do preallocation from user level; or else, it will return
> success/error-code returned by the system call to the user.
> 
> I think we can make it fall back to library implementation of fallocate,
> whenever posix_fallocate() receives any of the following errors from
> fallocate() system call:
> 
> 1. ENOSYS
> 2. EOPNOTSUPP
> 3. ENOTTY        (?)
> 
> Now the question is - should we limit the set of errors for this purpose
> to just 1 & 2 above ? In that case I will need to change the error being
> returned here to -EOPNOTSUPP (from current -ENOTTY).

If you want my opinion, -EOPNOTSUPP is better than -ENOTTY.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
