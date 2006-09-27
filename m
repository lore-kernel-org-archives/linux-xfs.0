Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 08:50:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8RFnwaG008464
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 08:50:01 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3798D118765
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 08:49:18 -0700 (PDT)
Message-ID: <451A9D55.30607@sandeen.net>
Date: Wed, 27 Sep 2006 10:48:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com>
In-Reply-To: <451A669D.9020503@agami.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: Chris Wedgwood <cw@f00f.org>, Rene Salmon <rsalmon@tulane.edu>, xfs@oss.sgi.com

Shailendra Tripathi wrote:

> libxfs_device_open () seems to be working with the pre-conceived notion 
> of assuming block devices of only 512 bytes in size.
> 
> if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
>     platform_set_blocksize(fd, path, statb.st_rdev, 512);
> 
> This eventually calls to set the blk sz to 512. Since, your volume does 
> not support less than 4k, it returns EINVAL. I think, libxfs_init should 
> be modified to take pass on the -s size option to this call so that it 
> does not happen.
>       However, I don't see any problem despite this failure. Everything 
> else should work fine.
> 

Yep, this looks to me like an oversight when the larger-sector-size
support was added.  Seems like if the device can't be set to a smaller
sector size than X, then the tools should run as if a sector size of X
had been specified?

-Eric
