Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 06:19:41 -0800 (PST)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEEJOSn023040
	for <xfs@oss.sgi.com>; Wed, 14 Nov 2007 06:19:30 -0800
Message-ID: <473B03EA.2040002@linworks.de>
Date: Wed, 14 Nov 2007 15:19:22 +0100
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: porting xfs_reno to linux
References: <4739EB0B.6030407@linworks.de> <20071113210018.GX995458@sgi.com>
In-Reply-To: <20071113210018.GX995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner schrieb:
> On Tue, Nov 13, 2007 at 07:20:59PM +0100, Ruben Porras wrote:
>   
>> Let's go back to the shrink xfs theme.
>>
>>     
>>> 2. Move inodes out of offline AGs
>>> 		- On Irix, we have a program called 'xfs_reno' which
>>> 		  converts 64 bit inode filesystems to 32 bit inode
>>> 		  filesystems. This needs to be:
>>> 		  	- released under the GPL (should not be a problem).
>>>       
>> done
>>
>>     
>>> 			- ported to linux
>>>       
>> Do you mean, rewrite the program to work on kernel space,
>>     
>
> No.
>
>   
>> or just port it 
>> to glibc?
>>     
>
> Port to linux. i.e. make it work and remove any tainted code that it
> might contain from  Irix so we can open source it.  Barry has
> already done this; the patch is here:
>
> http://oss.sgi.com/archives/xfs/2007-10/msg00054.html
>
> All it needs is reviewing and then xfs_reno for linux is done.
>
>   
Sorry, I didn't exlplain myself well enough. I already saw the mail from 
Barry, but the program needs not only a review. Now xfs_reno filter the 
inodes with nftw and the stat info. The problem is that we need to 
filter the inodes according to the AG where they are. Currently there is 
no way to find this out. Possibilities:

a) Extend the bulkstat structure to include the AG number (better not)
b) A new ioctl to find out the AG of an inode. and call the ioctl for 
each file on the fs.
c) Find all the inodes in 'marked' AGs. Export it through a new ioctl. 
xfs_reno needs to find later which files on the fs were on the list.

The second way would be to do everything in kernel space. The steps 
would be:

a) Find all the inodes in 'marked' AGs
b) Allocate a new inode for each one
c) Move the information from each old inode to the new one and unlink 
the old one. (This is what Barry suggest to do anyway in kernel space)

xfs_reno does only steps b) and c).

The second needs more work, but it doesn't need to traverse the 
filesystem several times.
> Cheers,
>
> Dave.
>   


-- 
Rubén Porras
LinWorks GmbH
