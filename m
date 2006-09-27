Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 06:17:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8RDHfaG012530
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 06:17:43 -0700
Received: from tricca.tcs.tulane.edu (tricca.tcs.tulane.edu [129.81.224.27])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39C6445FED3
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 06:17:01 -0700 (PDT)
Message-ID: <451A79BC.1010302@tulane.edu>
Date: Wed, 27 Sep 2006 08:16:44 -0500
From: Rene Salmon <rsalmon@tulane.edu>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com>
In-Reply-To: <451A669D.9020503@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>, Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Hi,


Thanks for the replies.  The block size of my LV is indeed 4096

helix-priv:~ # blockdev --getbsz /dev/vg_u00/lv_u00
4096

I can mount and use the xfs file system no problems.  I have even tested
extending the LV and doing an xfs_grow and that seemed to work no 
problems.  So I take it I can safely ignore the warning.

Should I report this as a bug?  If so Can someone point me to the 
bugzilla page or something of the sorts?

Thanks
Rene



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
> 
> 
>>> Everything seems to be working but I am a bit worried about the
>>> warning message.  Following is the message.  Any ideas if it is safe
>>> to ignore this or any way to get rid of it?
>>
>>
>> What does:
>>
>>   blockdev --getbsz /dev/vg_u00/lv_u00
>>
>> say?
>>
>>
>> If mkfs.xfs is trying to set a blocksize that already matches the
>> underlying device, it woudn't be hard to silence the warning by doing
>> a check before unconditionally setting it, though I don't know that
>> it's worth it.
>>
>>

-- 
-
--
         Rene Salmon
         Tulane University
         Center for Computational Science
         http://www.ccs.tulane.edu
	rsalmon@tulane.edu
         Tel 504-862-8393
	Tel 504-988-8552
         Fax 504-862-8392
