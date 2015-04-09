Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 997CF7F8C
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 09:34:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 907978F8040
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 07:34:27 -0700 (PDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id Bc8lUGtYcsDRBF5S
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Apr 2015 07:34:25 -0700 (PDT)
Received: by wgin8 with SMTP id n8so122321717wgi.0
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 07:34:24 -0700 (PDT)
Date: Thu, 9 Apr 2015 15:34:22 +0100 (BST)
From: Mark Hills <mark.hills@framestore.com>
Subject: Re: Errors from basic open_by_handle operations
In-Reply-To: <1428588558.5198.483.camel@montana.filmlight.ltd.uk>
Message-ID: <1504091515150.18609@sys953.ldn.framestore.com>
References: <1504091316590.18609@sys953.ldn.framestore.com>
	<1428588558.5198.483.camel@montana.filmlight.ltd.uk>
MIME-Version: 1.0
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Thu, 9 Apr 2015, Roger Willcocks wrote:

> The code below works here on a CentOS 6.4 box ('test' is a file at the
> root of the volume):
> 
> $ ./a.out
> hlen = 24
> fd = -1
> $ sudo ./a.out
> hlen = 24
> fd = 4

Yup, and I can reproduce that here on my system, thanks.

It seems the subtlety is rooted here:

>   if (path_to_fshandle("/mnt/disk1", &xfs_handle, &hlen) < 0)
>     exit(4);
> 
>   if (path_to_handle("/mnt/disk1/test", &xfs_handle, &hlen) < 0)
>     exit(5);

This code is correct, and it looks like it's necessary to do 
path_to_fshandle on the file system root, otherwise it does not satisfy 
the precondition of open_by_handle().

So what I was doing:

  path_to_fshandle("/mnt/disk1/test-file" ... );
  ...
  path_to_handle("/mnt/disk1/test-file" ... );

even though it reports the expected success (and returns the right file 
handles), is not enough to allow open_by_handle() to work on a file.

It does leave me needing to have prior knowledge of the mounted filesystem 
root (or look it up); handle_to_fshandle() doesn't achieve the same.

Definitely some oddities here -- but now I have enough to get me started 
though I hope.

Thanks for all the help, and perhaps I can look at some patches to the man 
page as I go.

Thanks

-- 
Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
