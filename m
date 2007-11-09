Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 21:34:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA95XoLt018838
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 21:33:56 -0800
Message-ID: <4733F198.1090107@sgi.com>
Date: Fri, 09 Nov 2007 16:35:20 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] bulkstat fixups
References: <4733EEF2.9010504@sgi.com>
In-Reply-To: <4733EEF2.9010504@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

It is looking good Lachlan.

I also verified the patch with XFS QA and Judith reported that
it fixed the xfs_bulkstat() problem - skipping inodes in the last AG.

Regards,
Vlad
 
Lachlan McIlroy wrote:
> Here's a collection of fixups for bulkstat for all the remaining issues.
>
> - sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()
>
> - remove the special case for XFS_IOC_FSBULKSTAT with count == 1.  
> This special
>   case causes bulkstat to fail because the special case uses 
> xfs_bulkstat_single()
>   instead of xfs_bulkstat() and the two functions have different 
> semantics.
>   xfs_bulkstat() will return the next inode after the one supplied 
> while skipping
>   internal inodes (ie quota inodes).  xfs_bulkstate_single() will only 
> lookup the
>   inode supplied and return an error if it is an internal inode.
>
> - in xfs_bulkstat(), need to initialise 'lastino' to the inode 
> supplied so in cases
>   were we return without examining any inodes the scan wont restart 
> back at zero.
>
> - sanity check for valid *ubcountp values.  Cannot sanity check for 
> valid ubuffer
>   here because some users of xfs_bulkstat() don't supply a buffer.
>
> - checks against 'ubleft' (the space left in the user's buffer) should 
> be against
>   'statstruct_size' which is the supplied minimum object size.  The 
> mixture of
>   checks against statstruct_size and 0 was one of the reasons we were 
> skipping
>   inodes.
>
> - if the formatter function returns BULKSTAT_RV_NOTHING and an error 
> and the error
>   is not ENOENT or EINVAL then we need to abort the scan.  ENOENT is 
> for inodes that
>   are no longer valid and we just skip them.  EINVAL is returned if we 
> try to lookup
>   an internal inode so we skip them too.  For a DMF scan if the inode 
> and DMF
>   attribute cannot fit into the space left in the user's buffer it 
> would return
>   ERANGE.  We didn't handle this error and skipped the inode.  We 
> would continue to
>   skip inodes until one fitted into the user's buffer or we completed 
> the scan.
>
> - put back the recalculation of agino (that got removed with the last 
> fix) at the
>   end of the while loop.  This is because the code at the start of the 
> loop expects
>   agino to be the last inode examined if it is non-zero.
>
> - if we found some inodes but then encountered an error, return 
> success this time
>   and the error next time.  If the formatter aborted with ENOMEM we 
> will now return
>   this error but only if we couldn't read any inodes.  Previously if 
> we encountered
>   ENOMEM without reading any inodes we returned a zero count and no 
> error which
>   falsely indicated the scan was complete.
