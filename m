Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 17:50:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J0nsxO030023
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 17:49:56 -0700
Message-ID: <4717FF91.5010902@sgi.com>
Date: Fri, 19 Oct 2007 10:51:29 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: Make xfs_bulkstat() to report unlinked but referenced
 inodes
References: <4715A22D.1070409@sgi.com>
In-Reply-To: <4715A22D.1070409@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

ping!

I ran XFS QA with this patch and didn't see any regressions and
I (and Judith in US) have verified the expected behavior - xfs_bulkstat()
now reports referenced inodes with link count of zero.

Regards,
Vlad

Vlad Apostolov wrote:
> We need xfs_bulkstat() to report inode stat for inodes with
> link count zero but reference count non zero.
>
> The fix here:
>
> http://oss.sgi.com/archives/xfs/2007-09/msg00266.html
>
> changed this behavior and made xfs_bulkstat() to filter all
> unlinked inodes including those that are not destroyed yet but
> held by reference.
>
> The attached patch returns back to the original behavior by
> marking the on-disk inode buffer "dirty" when di_mode is cleared
> (at that time both inode link and reference counter are zero).
>
> Regards,
> Vlad
