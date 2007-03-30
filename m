Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 05:55:58 -0700 (PDT)
Received: from mtagate4.de.ibm.com (mtagate4.de.ibm.com [195.212.29.153])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2UCtp6p007392
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 05:55:52 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id l2UCtnFg119100
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 12:55:49 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2UCtmYu2150494
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 14:55:48 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2UCtcZg003995
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 14:55:39 +0200
Date: Fri, 30 Mar 2007 14:55:38 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070330125538.GE8365@osiris.boeblingen.de.ibm.com>
References: <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com> <20070330104449.GA9371@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070330104449.GA9371@lazybastard.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Fri, Mar 30, 2007 at 12:44:49PM +0200, Jörn Engel wrote:
> On Fri, 30 March 2007 19:15:58 +1000, Paul Mackerras wrote:
> > It does mean extra unnecessary work for 64-bit platforms, though...
> 
> Wouldn't that work be confined to fallocate()?  If I understand Heiko
> correctly, the alternative would slow s390 down for every syscall,
> including more performance-critical ones.

That is correct.
