Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 01:12:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C8BxWt005443
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 01:12:01 -0700
Date: Tue, 12 Jun 2007 18:11:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070612081128.GS86004887@sgi.com>
References: <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612061652.GA6320@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: David Chinner <dgc@sgi.com>, Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Tue, Jun 12, 2007 at 11:46:52AM +0530, Amit K. Arora wrote:
> On Sat, May 12, 2007 at 06:01:57PM +1000, David Chinner wrote:
> > Minimal definition to replace what applicaitons use on XFS and to
> > support poasix_fallocate are the thre that have been mentioned so
> > far (FA_ALLOCATE, FA_PREALLOCATE, FA_DEALLOCATE). I'll document them
> > all in a man page...
> 
> Hi Dave,
> 
> Did you get time to write the above man page ? It will help to push
> further patches in time (eg. for FA_PREALLOCATE mode).

No, I didn't. Instead of working on new preallocation stuff, I've
been spending all my time fixing bugs found by new and interesting
(ab)uses of preallocation and hole punching.

> The idea I had was to push the patch with bare minimum functionality
> (FA_ALLOCATE and FA_DEALLOCATE modes) and parallely finalize on other
> new mode(s) based on the man page you planned to provide.

Push them. I'll just make XFS work with whatever is provided.
Is there a test harness for the syscall yet?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
