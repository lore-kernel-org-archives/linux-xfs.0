Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 22:00:15 -0700 (PDT)
Received: from mtagate7.de.ibm.com (mtagate7.de.ibm.com [195.212.29.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B503bm007374
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 22:00:04 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l6B502FY098876
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 05:00:02 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6B502fs1986646
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 07:00:02 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6B501At000602
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 07:00:02 +0200
Date: Wed, 11 Jul 2007 06:59:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and powerpc
Message-ID: <20070711045958.GA12843@osiris.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710202000.GB8797@amitarora.in.ibm.com> <20070711121034.a3b925b9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

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

Maybe it would be worth to finally consider this:

http://marc.info/?l=linux-kernel&m=118411511620432&w=2

?
