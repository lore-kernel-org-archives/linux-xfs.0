Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B12C7F67
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 08:37:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 212168F8049
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 06:37:02 -0700 (PDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id 5XDEEHfVFyozKkl7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Apr 2015 06:37:00 -0700 (PDT)
Received: by wgsk9 with SMTP id k9so97958244wgs.3
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 06:36:59 -0700 (PDT)
Date: Thu, 9 Apr 2015 14:36:58 +0100 (BST)
From: Mark Hills <mark.hills@framestore.com>
Subject: Re: Errors from basic open_by_handle operations
In-Reply-To: <1428584963.5198.478.camel@montana.filmlight.ltd.uk>
Message-ID: <1504091422580.18609@sys953.ldn.framestore.com>
References: <1504091316590.18609@sys953.ldn.framestore.com>
	<1428584963.5198.478.camel@montana.filmlight.ltd.uk>
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

> There's a small gotcha - the filesystem itself has to have been opened:
> 
>         void *xfs_handle = 0;
>         size_t hlen  = 0;
> 
>         /* xfs library needs the filesystem to have been opened */
> 
>         if (path_to_fshandle(mountpoint, &xfs_handle, &hlen) < 0) {
>                 /* error */
>                 exit(4);
>         }
> 
>         free(xfs_handle);

Thank you Roger, that moves me one step but not to success

Now I know "Operation not permitted" is the correct message I assume that 
use of XFS file handles requires root.

But even as root, I cannot open a file with O_RDONLY:

  $ sudo ./test-xfs ~/scratch/tmp/xfs/file.c ; echo $?
  Handle 8 bytes: bd2c94ba959858
  Handle 24 bytes: bd2c94ba959858e0000000870000000
  readlink_by_handle: Not a directory
  open_by_handle: Not a directory
  0

I am able to do open_by_handle(O_RDONLY) on a directory though:

  $ sudo ./test-xfs ~/scratch/tmp/xfs/directory ; echo $?
  Handle 8 bytes: bd2c94ba959858
  Handle 24 bytes: bd2c94ba959858e0000000880000000
  readlink_by_handle: Invalid argument
  0

and a readlink_by_handle on a symlink works:

  $ sudo ./test-xfs ~/scratch/tmp/xfs/link.c ; echo $?
  Handle 8 bytes: bd2c94ba959858
  Handle 24 bytes: bd2c94ba959858e0000000860000000
  Link: fortress.c
  open_by_handle: Operation not permitted
  0

Switching to O_RDWR does not succeed in opening a file either, and also 
stops the directory case.

It seems possible flags are getting mangled and are not what I think they 
mean. The docs state the call as analogous to open(); is the 'oflags' 
argument actually ready to accept O_RDONLY etc. or some other set of 
flags? Because it seems like I can't actually open a file here.

Many thanks

-- 
Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
