Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 22:43:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S5guDW014260
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 22:43:08 -0700
Message-ID: <44C9A353.1050702@sgi.com>
Date: Fri, 28 Jul 2006 15:40:35 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: fix bulkstat error detection logic
References: <20060726102406.I2118045@wobbly.melbourne.sgi.com>
In-Reply-To: <20060726102406.I2118045@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Nathan Scott wrote:
> Hi,
> 
> An earlier patch to remove bulkstat verbosity in debug kernels
> changed the xfs_itobp logic slightly, such that we no longer do
> the first stage of buffer checking there.  Turns out this isn't
> the right fix, we need to do that check still, and pass out the
> error code to bulkstat still, otherwise we either trip up logic
> in later debug code, or pass out success incorrectly.
> 
> This fixes that up, and is the last bulkstat change I have for
> awhile. :)  Its error handling is correct once more, its a fair
> bit quicker, and no more debug-kernel console spam - hooray!
> 
> cheers.
> 

Looks reasonable.
So you still do the inode buffer validation but we don't print out
a corruption error msg and we return EINVAL instead of EFSCORRUPTED.
Can we not be bulkstat'ing over inodes with reasonable numbers/locations but
the inode data on disk is just corrupted?
(I missed looking at the original patch)

(Interesting how previously you set ni to 0 in the XFS_IMAP_BULKSTAT
case and yet in the loop which would then never iterate (0<0=F),
you test for XFS_IMAP_BULKSTAT :)

--Tim
