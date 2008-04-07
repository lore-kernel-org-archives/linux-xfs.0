Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 14:55:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37LtCtn000955
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 14:55:17 -0700
Date: Tue, 8 Apr 2008 07:55:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: new xfsqa mismatches
Message-ID: <20080407215539.GC108924158@sgi.com>
References: <20080407100140.GA11891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407100140.GA11891@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 07, 2008 at 12:01:40PM +0200, Christoph Hellwig wrote:
> 103:
> 
>  - output mismatch (see 103.out.bad)
> 7c7
> < ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
> ---
> > ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
> 
> not sure where the double to comes from but we should catch it

>From the last fix that I did to fix this for new version of ln.

If other ppl sent xfsqa patches to the oss list, then you'd see that
a patch to fix this was sent out for review yesterday....

> 130 and 132 expetect Bytes in various places but get bytes from xfs_io
> from CVS

What's the error output? I've not seen that one....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
