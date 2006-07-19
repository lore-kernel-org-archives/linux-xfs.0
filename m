Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 01:44:16 -0700 (PDT)
Received: from e450.epcc.ed.ac.uk (e450.epcc.ed.ac.uk [129.215.56.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6J8hUDW028947
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 01:43:33 -0700
Date: Wed, 19 Jul 2006 08:37:28 +0100
From: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Subject: Re: oops with CentOS 4.3 / xfs / nfsd
Message-ID: <20060719073728.GA14530@garnet.epcc.ed.ac.uk>
References: <1153214961.6793.15.camel@x41ade> <20060719083014.B1935136@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060719083014.B1935136@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com, maciej@epcc.ed.ac.uk

> This is very likely to be due to the way older versions of XFS
> managed incore inode extent lists.  So, you've likely got a very
> fragmented file/files here, and XFS used to require large amounts
> of contiguous memory to deal with that. 

More than likely - the filesystem is exported to our Blue Gene rack
so gets hammered by parallel IO constantly. Oh, and the server also
exports a chunk of SATA raid out (3ware controller) as pvfs2...

I guess our priority should be to try and "source" some more memory
than the 512M we have in at the moment. 

> Your options are to take
> steps to combat inode extent fragmentation (like fsr), or use a
> more recent kernel (2.6.17+ IIRC).

OK - we were trying to stay reasonably simple by using vendor kernels but I guess it's time for a quick "make menuconfig"

Ta

Andrew

-- 
Andrew Elwell, System Administrator EPCC
Tel 0131 445 7833 (ACF Building)
Tel 0131 650 5023 (Rm 3309, JCMB)
