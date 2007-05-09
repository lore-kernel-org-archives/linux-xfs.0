Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 03:52:33 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49AqPfB028412
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 03:52:26 -0700
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l49AEJTa016628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 06:14:20 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49AECOf004909
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 06:14:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49AECD9171760
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 04:14:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49AECFt015558
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 04:14:12 -0600
Date: Wed, 9 May 2007 15:45:07 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509101507.GA26056@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <17978.47502.786970.196554@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17978.47502.786970.196554@cargo.ozlabs.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Fri, May 04, 2007 at 02:41:50PM +1000, Paul Mackerras wrote:
> Andrew Morton writes:
> 
> > On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > 
> > > This patch implements the fallocate() system call and adds support for
> > > i386, x86_64 and powerpc.
> > > 
> > > ...
> > >
> > > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > 
> > Please add a comment over this function which specifies its behaviour. 
> > Really it should be enough material from which a full manpage can be
> > written.
> 
> This looks like it will have the same problem on s390 as
> sys_sync_file_range.  Maybe the prototype should be:
> 
> asmlinkage long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)

Yes, but the trouble is that there was a contrary viewpoint preferring that fd
first be maintained as a convention like other syscalls (see the following
posts)

http://marc.info/?l=linux-fsdevel&m=117585330016809&w=2 (Andreas)
http://marc.info/?l=linux-fsdevel&m=117690157917378&w=2  (Andreas)

http://marc.info/?l=linux-fsdevel&m=117578821827323&w=2 (Randy)

So we are kind of deadlocked, aren't we ?

The debates on the proposed solution for s390

http://marc.info/?l=linux-fsdevel&m=117760995610639&w=2  
http://marc.info/?l=linux-fsdevel&m=117708124913098&w=2 
http://marc.info/?l=linux-fsdevel&m=117767607229807&w=2

Are there any better ideas ?

Regards
Suparna

> 
> Paul.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India
