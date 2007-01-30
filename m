Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 05:46:55 -0800 (PST)
Received: from pem-exsmtp01.silverapp.local (pem-smtp01.silverapp.com [209.43.6.67] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0UDkkqw009423
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 05:46:47 -0800
Message-ID: <45BF4C0F.8040004@apparatus.net>
Date: Tue, 30 Jan 2007 08:45:51 -0500
From: Andrew Jones <ajones@apparatus.net>
MIME-Version: 1.0
Subject: Re: RE: xfs_repair leaves things un-repaired.
References: <200701300010.LAA00558@larry.melbourne.sgi.com>
In-Reply-To: <200701300010.LAA00558@larry.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>, xfs@oss.sgi.com

Barry Naujok wrote:

>Hi Andrew,
>
>The xfs_repair output is valid. All the inodes that are reporting errors
>are orphaned inodes that were moved into lost+found. At the start of
>phase 4, the lost+found directory is deleted which causes all the inodes
>in lost+found to be re-orphaned. The current solution to this problem is
>to rename lost+found after an xfs_repair run and then unmount and try
>xfs_repair again.
>
>Regarding the shutdown, that is not normal and I personally don't know
>what the problem is from the trace. If it's a corrupt lost+found that
>xfs_repair is generating (I gather you are rm'ing lost+found), the
>second xfs_repair run after a rename should identify the problem with
>the directory. You can also try running xfs_check on the device as it
>may pick up something xfs_repair is missing.
>
>Regards,
>Barry.
>  
>
Thanks a lot for the clear explanation.   I still don't know why it 
bombs out and shuts down the filesystem when the corrupt directories are 
manipulated, but I don't particularly care, in this case.  Moving 
lost+found and re-running xfs_repair has worked out the problem. I can 
now manipulate the contents of lost+found safely.
