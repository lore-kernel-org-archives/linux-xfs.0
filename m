Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Oct 2006 21:39:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9U5daaG018867
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 21:39:39 -0800
Date: Mon, 30 Oct 2006 15:39:32 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs_quota project + symlinks
Message-ID: <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
 <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sten Spans <sten@blinkenlights.nl>, xfs@oss.sgi.com

Hi,

--On 26 October 2006 3:45:59 PM +0200 Sten Spans <sten@blinkenlights.nl> wrote:

> On Thu, 26 Oct 2006, Sten Spans wrote:
>
>>
>> This is with
>>
>> root@backup:/root/backup# xfs_quota -V
>> xfs_quota version 2.8.11
>> root@backup:/backup# ln -s foo bar
>> root@backup:/backup# xfs_quota -x -c 'project -c 0'
>> Checking project 7 (path /backup)...
>> xfs_quota: cannot open /backup/bar: No such file or directory
>> Processed 1 /etc/projects paths for project 0
>>
>> Would it be possible to handle symlinks better ?
>> Perhaps a check for symlinks in project.c ?
>
>       86         if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1)
>       87                 fprintf(stderr, _("%s: cannot open %s: %s\n"),
>       88                         progname, path, strerror(errno));
>       89         else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0)
>
> If path is a symlink, then the project id is applied to a file
> potentially on another filesystem. Wouldn't it be better to
> add O_NOFOLLOW here ?
>
You want it to error out if it is a symlink.

I'm not familiar with O_NOFOLLOW. Looking at man page:
    If  pathname  is  a  symbolic  link, then the open fails.
    Symbolic links in earlier components of the pathname will still be followed.
So it would still allow you to follow onto another filesystem if part of the path
contained symlinks, by the look of it.
So I'm not sure that is what we want. Also this source is shared on IRIX and
I don't believe O_NOFOLLOW exists there.

I'm not that familiar with quotas (Nathan?, Donald?), but I would presume
that since symlinks take up space depending on the symlink path, that they should
have quota control on the space they take up.
In which case, one would actually not want to follow the symlink but rather
apply a limit to that actual symlink inode.
I don't know if this is the case though.

But I agree, I doubt one wants to follow the symlinks - it would get rather
confusing.

--Tim
