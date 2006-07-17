Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 08:21:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HFL2DW031551
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 08:21:15 -0700
Date: Tue, 18 Jul 2006 00:19:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: file system defragmentation
Message-ID: <20060717141917.GY2114946@melbourne.sgi.com>
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356806.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cosmo Nova <cs_mcc98@hotmail.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Jul 17, 2006 at 12:36:09AM -0700, Cosmo Nova wrote:
> 
> Hi, you mentioned delayed allocation. What is the size of the buffer holding
> the data, before they're actually written to disk?  How can it tackle growing
> files?

No special buffering is needed in XFS as the page cache does it all for us.
delalloc means that XFS does not allocate until the data gets written to disk
(i.e. flushed from the cache). The size of the allocation is dependent on the
amount of contiguous dirty data in the file. That is, The more sequential
dirty pages in the page cache for a file, the larger the allocation...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
