Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 15:31:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6IMV1DW011707
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 15:31:12 -0700
Date: Wed, 19 Jul 2006 08:30:14 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: oops with CentOS 4.3 / xfs / nfsd
Message-ID: <20060719083014.B1935136@wobbly.melbourne.sgi.com>
References: <1153214961.6793.15.camel@x41ade>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153214961.6793.15.camel@x41ade>; from andrewe@epcc.ed.ac.uk on Tue, Jul 18, 2006 at 10:29:21AM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Cc: xfs@oss.sgi.com, maciej@epcc.ed.ac.uk

On Tue, Jul 18, 2006 at 10:29:21AM +0100, Andrew Elwell wrote:
> Hi Folks,
> 
> We've migrated some of our storage servers to CentOS 4.3 and are seeing
> lockups. It *could* be hardware I know, and I'm scheduling downtime to
> run memtest86+ ASAP.
> ...
>  IP 172.20.0.224
> SysRq : HELP : loglevel0-8 reBoot Crash tErm kIll saK showMem powerOff showPc unRaw Sync showTasks Unmount shoWcpus 
> nfsd: page allocation failure. order:4, mode:0x50

This is very likely to be due to the way older versions of XFS
managed incore inode extent lists.  So, you've likely got a very
fragmented file/files here, and XFS used to require large amounts
of contiguous memory to deal with that.  Your options are to take
steps to combat inode extent fragmentation (like fsr), or use a
more recent kernel (2.6.17+ IIRC).

Oh yes, and like Joshua said, those old kernels also had 4Kstack
related issues.

cheers.

-- 
Nathan
