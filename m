Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 03:24:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8SAObaG020269
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 03:24:40 -0700
Message-ID: <451BA2AF.9090703@sgi.com>
Date: Thu, 28 Sep 2006 20:23:43 +1000
From: Tim Shimmin <tes@sgi.com>
Reply-To: tes@sgi.com
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com>
In-Reply-To: <451A669D.9020503@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: Chris Wedgwood <cw@f00f.org>, Rene Salmon <rsalmon@tulane.edu>, xfs@oss.sgi.com

Shailendra Tripathi wrote:
>>> Thanks for the reply. The "-s size=4096" helped I was able to create
>>> the file system, then mount it and use it.  I did however get a
>>> warning still about "cannot set blocksize on block device".
> 
>>
>> I don't know much about the LVM code, my guess is that
>> ioctl(... ,BLKBSZSET, ...) is failing, strace would confirm this.
> 
> 
> libxfs_device_open () seems to be working with the pre-conceived notion 
> of assuming block devices of only 512 bytes in size.
> 
> if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
>    platform_set_blocksize(fd, path, statb.st_rdev, 512);
> 
> This eventually calls to set the blk sz to 512. Since, your volume does 
> not support less than 4k, it returns EINVAL. I think, libxfs_init should 
> be modified to take pass on the -s size option to this call so that it 
> does not happen.
>      However, I don't see any problem despite this failure. Everything 
> else should work fine.
> 
> 
Sounds reasonable.
I'll have a look soon at passing the mkfs.xfs -s option thru to libxfs
which is consistent with the existing code.

--Tim
