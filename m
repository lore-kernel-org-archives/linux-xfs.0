Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 07:33:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9QEXAaG028480
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 07:33:11 -0700
Received: from mx1.blinkenlights.nl (mx1.blinkenlights.nl [80.84.249.153])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E44E4DC518
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 06:46:03 -0700 (PDT)
Received: from zaphod.blinkenlights.nl (zaphod.blinkenlights.nl [IPv6:2001:980:ffe:3:2e0:81ff:fe2f:bb6a])
	by mx1.blinkenlights.nl (Postfix) with ESMTP id 2982C73038
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 15:46:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zaphod.blinkenlights.nl (Postfix) with ESMTP id EBAE617F455
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 15:45:59 +0200 (CEST)
Date: Thu, 26 Oct 2006 15:45:59 +0200 (CEST)
From: Sten Spans <sten@blinkenlights.nl>
Subject: Re: xfs_quota project + symlinks
In-Reply-To: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
Message-ID: <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, 26 Oct 2006, Sten Spans wrote:

>
> This is with
>
> root@backup:/root/backup# xfs_quota -V
> xfs_quota version 2.8.11
> root@backup:/backup# ln -s foo bar
> root@backup:/backup# xfs_quota -x -c 'project -c 0'
> Checking project 7 (path /backup)...
> xfs_quota: cannot open /backup/bar: No such file or directory
> Processed 1 /etc/projects paths for project 0
>
> Would it be possible to handle symlinks better ?
> Perhaps a check for symlinks in project.c ?

      86         if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1)
      87                 fprintf(stderr, _("%s: cannot open %s: %s\n"),
      88                         progname, path, strerror(errno));
      89         else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0)

If path is a symlink, then the project id is applied to a file
potentially on another filesystem. Wouldn't it be better to
add O_NOFOLLOW here ?
