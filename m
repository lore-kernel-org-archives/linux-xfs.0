Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 04:59:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8RBwvaG032423
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:58:58 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14863460948
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:58:15 -0700 (PDT)
Received: from agami.com ([192.168.168.146])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8RBwFRC004470
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:58:15 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8RBw91T015990
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:58:10 -0700
Message-ID: <451A669D.9020503@agami.com>
Date: Wed, 27 Sep 2006 17:25:09 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org>
In-Reply-To: <20060926224053.GA31542@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Rene Salmon <rsalmon@tulane.edu>, xfs@oss.sgi.com

>>Thanks for the reply. The "-s size=4096" helped I was able to create
>>the file system, then mount it and use it.  I did however get a
>>warning still about "cannot set blocksize on block device".

> 
> I don't know much about the LVM code, my guess is that
> ioctl(... ,BLKBSZSET, ...) is failing, strace would confirm this.


libxfs_device_open () seems to be working with the pre-conceived notion 
of assuming block devices of only 512 bytes in size.

if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
    platform_set_blocksize(fd, path, statb.st_rdev, 512);

This eventually calls to set the blk sz to 512. Since, your volume does 
not support less than 4k, it returns EINVAL. I think, libxfs_init should 
be modified to take pass on the -s size option to this call so that it 
does not happen.
      However, I don't see any problem despite this failure. Everything 
else should work fine.




>>Everything seems to be working but I am a bit worried about the
>>warning message.  Following is the message.  Any ideas if it is safe
>>to ignore this or any way to get rid of it?
> 
> 
> What does:
> 
>   blockdev --getbsz /dev/vg_u00/lv_u00
> 
> say?
> 
> 
> If mkfs.xfs is trying to set a blocksize that already matches the
> underlying device, it woudn't be hard to silence the warning by doing
> a check before unconditionally setting it, though I don't know that
> it's worth it.
> 
> 
