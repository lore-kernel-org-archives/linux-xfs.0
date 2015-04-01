Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7A127F5E
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 12:12:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7B46304039
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 10:12:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MvGv0RkwQObYMRmG for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 10:12:32 -0700 (PDT)
Message-ID: <551C26FC.10803@sandeen.net>
Date: Wed, 01 Apr 2015 13:12:28 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs corruption issue
References: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
In-Reply-To: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Danny Shavit <danny@zadarastorage.com>, xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Lev Vainblat <lev@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>

On 4/1/15 10:09 AM, Danny Shavit wrote:
> Hello Dave,
> My name is Danny Shavit and I am with Zadara storage.
> We will appreciate your feedback reagrding an xfs_corruption and xfs_reapir issue.
> 
> We found a corrupted xfs volume in one of our systems. It is around 1 TB size and about 12 M files.
> We run xfs_repair on the volume which succeeded after 42 minutes.
> We noticed that memory consumption raised to about 7.5 GB.
> Since some customers are using only 4GB (and sometimes even 2 GB) we tried running "xfs_repair -m 3200" on a 4GB RAM machine.
> However, this time an OOM event happened during handling of AG 26 during step 3.
> The log of xfs_repair is enclosed below.
> We will appreciate your feedback on the amount of memory needed for xfs_repair in general and when using "-m" option specifically.
> The xfs metadata dump (prior to xfs_repair) can be found here:
> https://zadarastorage-public.s3.amazonaws.com/xfs/xfsdump-prod-ebs_2015-03-30_23-00-38.tgz
> It is a 1.2 GB file (and 5.7 GB uncompressed).
> 
> We will appreciate your feedback on the corruption pattern as well.
> -- 
> Thank you,
> Danny Shavit
> Zadarastorage
> 
> ---------- xfs_repair log  ----------------

Just a note ...

> bad . entry in directory inode 5691013154, was 5691013170: correcting

101010011001101011111100000100100
101010011001101011111100000110100
                            ^ bit flip

> bad . entry in directory inode 5691013156, was 5691013172: correcting

101010011001101011111100000100100
101010011001101011111100000110100
                            ^ bit flip

etc ...

> bad . entry in directory inode 5691013157, was 5691013173: correcting
> bad . entry in directory inode 5691013163, was 5691013179: correcting

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
