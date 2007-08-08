Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 18:34:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l781Yabm010073
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 18:34:38 -0700
Date: Wed, 8 Aug 2007 11:34:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: many subdirectories, slow search.
Message-ID: <20070808013430.GL12413810@sgi.com>
References: <337047880.20070807181022@ethaniel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337047880.20070807181022@ethaniel.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arkadiy Kulev <eth@ethaniel.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 07, 2007 at 06:10:22PM +0400, Arkadiy Kulev wrote:
> Hello xfs,
> 
>   I have a external SATA storage, that is connected to my server via
>   SCSI HBA. The server is a 32 bit core2duo with 1gb RAM.
.....
>   I started noticing, that images are being accessed slowly (high
>   lag of 5-10 seconds). Even when I connect via ssh and do "ls /data1"
>   for instance (/data1 is my 2 terabyte xfs partition) it gives me a
>   result only after a few seconds, even though the root folder is not
>   big.

Is it always slow, or does it slow down after some runtime?

Does that slow access correspond to running out of free memory on the
machine? i.e. Does it speed up again if you:

# echo 3 > /proc/sys/vm/drop_caches

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
