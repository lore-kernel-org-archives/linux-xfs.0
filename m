Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 17:55:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9T0srOQ026419
	for <xfs@oss.sgi.com>; Sun, 28 Oct 2007 17:54:56 -0700
Message-ID: <47252F62.6030503@sgi.com>
Date: Mon, 29 Oct 2007 11:54:58 +1100
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: bug: truncate to zero + setuid
References: <47249E7A.7060709@filmlight.ltd.uk>
In-Reply-To: <47249E7A.7060709@filmlight.ltd.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

Hi Roger,

Roger Willcocks wrote:
> The nfsv3 setattr call permits a simultaneous truncate + setuid/gid 
> operation. Normally XFS handles this fine, but if the file's being 
> truncated to zero, and the file's already empty, XFS simply ignores the 
> setuid/gid part, returning 'success'.
> 
> The error's in xfs_vnodeops.c/xfs_setattr below the comment 'Short 
> circuit the truncate case for zero length files', which bypasses all 
> other changes.
> 
> The simplest fix is to test whether this is the only change that's 
> happening, otherwise you get tangled in transactions.
> 
>        if (mask & XFS_AT_SIZE) {
>                /* Short circuit the truncate case for zero length files */
> -               if ((vap->va_size == 0) &&
> +               if (((mask & ~XFS_AT_SIZE) == 0) && (vap->va_size == 0) &&
>                   (ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 0)) {
> 
> 
> -- 
> Roger
> 

Yeah, I see your problem.
It is interesting to know how much of multiple actions (different
bits of mask) are supported.
XFS_AT_UPDTIMES doesn't support anything else and will return quickly.
As far as code which goes via error_return, it looks like the
only non-error case is the short-circuit one mentioned above -
truncating to zero an already zeroed file.

I see your fix will get what we want although, it will mean that we
will go thru the truncating path when we don't need to.
It would be nice if we could act like the XFS_AT_SIZE was never set
on the call in the case that other bits are set.
Though when we first test the AT_SIZE, we don't have the inode locked.
And I presume in that case we don't necessarily need to send a
DMAPI truncate event?
So I wonder if before the 1st AT_SIZE test that we have now,
in the AT_SIZE case and with other bits set,
we could lock the inode and test
for the zero truncate of zero-len file and if so then remove the AT_SIZE bit
and then go on to the other testing as if AT_SIZE was never set.
Hmmm, may be that just complicates things too much.


--Tim
