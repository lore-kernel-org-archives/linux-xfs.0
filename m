Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 16:47:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2JNkwBY008552
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 16:47:01 -0700
Date: Thu, 20 Mar 2008 10:48:31 +1100
Subject: Re: Duplicate directory entries
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <D9A1816327F7BF4F931ADE74C248DFC90DD4FD00@it-004.Isys.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t8ae25ry3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <D9A1816327F7BF4F931ADE74C248DFC90DD4FD00@it-004.Isys.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jim Paradis <jparadis@exagrid.com>, xfs@oss.sgi.com

On Thu, 20 Mar 2008 06:26:05 +1100, Jim Paradis <jparadis@exagrid.com>  
wrote:

> We recently ran across a situation where we saw two directory entries
> that were exactly the same.  A ls -li of the directory in question shows
> the following:
>
>
> 3758898162 -rw-r--r--  1 root root 1592 Jan 28 02:21
> 4b13e98d-2165-4630-851d-c2d94149401f.i
>
> 3758898162 -rw-r--r--  1 root root 1592 Jan 28 02:21
> 4b13e98d-2165-4630-851d-c2d94149401f.i
>
> 3758901942 -rw-r--r--  1 root root 1805 Mar 16 21:43
> 848a74ed-ec3a-4504-a478-6b75cede7ccc.i
>
>
> There are only three entries in the directory.  Note that the first two
> are identical - same name, same inode number.  Note, too, that the inode
> has a link count of *one* despite its having two directory entries
> pointing at it.
>
>
> When I run xfs_db and examine this directory, I see that this is a
> short-form dir2 directory in the inode literal area, and it is the first
> two entries that are identical.  I searched the archives and found a
> similar situation described in 2006, but no resolution.  The xfs_db
> inode dump is below... any thoughts as to how this happens and is there
> a fix?

I can't comment on how it was caused, but xfs_repair -n on the filesystem
should detect it, and running xfs_repair without the -n should fix it.

Regards,
Barry.
