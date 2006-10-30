Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Oct 2006 23:55:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9U7tNaG012109
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 23:55:23 -0800
Received: from mx0.blinkenlights.nl (unknown [80.84.249.153])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E61AD1B2075
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 23:54:36 -0800 (PST)
Date: Mon, 30 Oct 2006 08:54:33 +0100 (CET)
From: Sten Spans <sten@blinkenlights.nl>
Subject: Re: xfs_quota project + symlinks
In-Reply-To: <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
Message-ID: <Pine.LNX.4.64.0610300847450.17271@zaphod.blinkenlights.nl>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
 <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
 <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 30 Oct 2006, Timothy Shimmin wrote:

> Hi,
>
> --On 26 October 2006 3:45:59 PM +0200 Sten Spans <sten@blinkenlights.nl> 
> wrote:
>
>> On Thu, 26 Oct 2006, Sten Spans wrote:
>> 
>> If path is a symlink, then the project id is applied to a file
>> potentially on another filesystem. Wouldn't it be better to
>> add O_NOFOLLOW here ?
>> 
> You want it to error out if it is a symlink.

Well It currently errors out for symlinks pointing to
nowhere, but it does follow working symlinks.

I am using project quota's on a backup server, and was thinking
of using xfs_quota -c to check quota weekly. But if xfs_quota
follows symlinks then quota are also applied to other filesystems.

> I'm not familiar with O_NOFOLLOW. Looking at man page:
>   If  pathname  is  a  symbolic  link, then the open fails.
>   Symbolic links in earlier components of the pathname will still be 
> followed.
> So it would still allow you to follow onto another filesystem if part of the 
> path
> contained symlinks, by the look of it.
> So I'm not sure that is what we want. Also this source is shared on IRIX and
> I don't believe O_NOFOLLOW exists there.
>
> I'm not that familiar with quotas (Nathan?, Donald?), but I would presume
> that since symlinks take up space depending on the symlink path, that they 
> should
> have quota control on the space they take up.
> In which case, one would actually not want to follow the symlink but rather
> apply a limit to that actual symlink inode.
> I don't know if this is the case though.
>
> But I agree, I doubt one wants to follow the symlinks - it would get rather
> confusing.

Indeed quota are normally filesystem specific,
following symlinks breaks this which creates unexpected situations.

-- 
Sten Spans

"There is a crack in everything, that's how the light gets in."
Leonard Cohen - Anthem
