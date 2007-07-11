Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 01:11:30 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B8BPbm011422
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 01:11:26 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6B8BSop022451
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 04:11:28 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6B8BRBw423710
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 04:11:27 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6B8BRxh022347
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 04:11:27 -0400
Date: Wed, 11 Jul 2007 13:41:41 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and powerpc
Message-ID: <20070711081141.GA25383@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710202000.GB8797@amitarora.in.ibm.com> <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 11, 2007 at 12:10:34PM +1000, Stephen Rothwell wrote:
> On Wed, 11 Jul 2007 01:50:00 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> > --- linux-2.6.22.orig/arch/x86_64/ia32/sys_ia32.c
> > +++ linux-2.6.22/arch/x86_64/ia32/sys_ia32.c
> > @@ -879,3 +879,11 @@ asmlinkage long sys32_fadvise64(int fd, 
> >  	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
> >  				len, advice);
> >  }
> > +
> > +asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
> > +				unsigned offset_hi, unsigned len_lo,
> > +				unsigned len_hi)
> 
> Please call this compat_sys_fallocate in line with the powerpc version -
> it gives us a hint that maybe we should think about how to consolidate
> them.  I know other stuff in that file is called sys32_ ... but it is time
> for a change :-)

I think this can be handled as a separate patch once this patchset
is in mainline. Since, anyhow we will need to do this for other sys32_
calls which are already there...

--
Regards,
Amit Arora
