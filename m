Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Oct 2006 17:08:17 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9V185aG005115
	for <xfs@oss.sgi.com>; Mon, 30 Oct 2006 17:08:07 -0800
Date: Tue, 31 Oct 2006 11:08:08 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs_quota project + symlinks
Message-ID: <EFAEF35C8D3C3C927A1C43D3@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <1162247043.17754.160.camel@edge>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>	
 <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>	
 <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local> <1162247043.17754.160.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Sten Spans <sten@blinkenlights.nl>, xfs@oss.sgi.com

Okay, thanks, Nathan,

So does that mean we need a way for FSGETXATTR and FSSETXATTR ioctls to
work on the symlink inode? Is this (symlink ioctls) done elsewhere? :)

One for Donald :)

--Tim

--On 31 October 2006 9:24:03 AM +1100 Nathan Scott <nscott@aconex.com> wrote:

> On Mon, 2006-10-30 at 15:39 +1000, Timothy Shimmin wrote:
>> Hi,
>>
>> > If path is a symlink, then the project id is applied to a file
>> > potentially on another filesystem. Wouldn't it be better to
>> > add O_NOFOLLOW here ?
>>
>> You want it to error out if it is a symlink.
>>
>
> Thats not ideal.  But some way to stay on the symlink's filesystem
> is probably needed here, from the sound of it.
>
>> I'm not that familiar with quotas (Nathan?, Donald?), but I would presume
>> that since symlinks take up space depending on the symlink path, that they should
>> have quota control on the space they take up.
>
> If they require space to be allocated (i.e the symlink target is not
> stored in the inode literal area), then that space allocation will be
> subject to quota IIRC.
>
>> In which case, one would actually not want to follow the symlink but rather
>> apply a limit to that actual symlink inode.
>
> *nod*
>
>>
>> But I agree, I doubt one wants to follow the symlinks - it would get rather
>> confusing.
>
> *nod*
>
> cheers.
>
> --
> Nathan
