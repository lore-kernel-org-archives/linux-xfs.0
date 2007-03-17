Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 07:32:52 -0700 (PDT)
Received: from mtagate1.uk.ibm.com (mtagate1.uk.ibm.com [195.212.29.134])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HEWe6p025842
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 07:32:42 -0700
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l2HEWcAX084742
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 14:32:38 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2HEWcUc1626332
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 14:32:38 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2HEWb7Z005719
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 14:32:38 GMT
Date: Sat, 17 Mar 2007 15:30:43 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070317143043.GA8577@osiris.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <17915.48105.70494.958220@cargo.ozlabs.ibm.com> <20070317110706.GB29931@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317110706.GB29931@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Sat, Mar 17, 2007 at 05:07:06AM -0600, Matthew Wilcox wrote:
> On Sat, Mar 17, 2007 at 08:59:05PM +1100, Paul Mackerras wrote:
> > ... but wouldn't work on 32-bit powerpc. :(  We would end up with a
> > pad argument between fd and offset, giving 7 arguments in all
> > (counting the loff_t's as 2), but we only support 6.
> 
> Ditto mips and parisc.

Can't be. Or: mips supports 7 arguments and parisc doesn't pad.
Otherwise they couldn't have wired up

sys_sync_file_range(int fd, loff_t offset, loff_t nbytes, unsigned int flags)

But from what I read, it's currently not possible for 32-bit powerpc to
wire up the already present sync_file_range system call.
