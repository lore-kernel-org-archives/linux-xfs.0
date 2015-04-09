Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84BA67F91
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 08:09:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 123BBAC008
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 06:09:26 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id JbaHxMdST9qVSvBi for
	<xfs@oss.sgi.com>; Thu, 09 Apr 2015 06:09:25 -0700 (PDT)
Subject: Re: Errors from basic open_by_handle operations
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <1504091316590.18609@sys953.ldn.framestore.com>
References: <1504091316590.18609@sys953.ldn.framestore.com>
Date: Thu, 09 Apr 2015 14:09:23 +0100
Message-Id: <1428584963.5198.478.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Mark Hills <mark.hills@framestore.com>
Cc: xfs@oss.sgi.com

There's a small gotcha - the filesystem itself has to have been opened:

        void *xfs_handle = 0;
        size_t hlen  = 0;

        /* xfs library needs the filesystem to have been opened */

        if (path_to_fshandle(mountpoint, &xfs_handle, &hlen) < 0) {
                /* error */
                exit(4);
        }

        free(xfs_handle);


On Thu, 2015-04-09 at 13:53 +0100, Mark Hills wrote:
> I am having troubles with elementary file handle functions in libhandle.
> 
> A basic open_by_handle is giving "Bad file descriptor".
> 
> But I am suspicious of a side effect; using path_to_fshandle earlier in 
> the program changes these errors to "Operation not permitted".
> 
> Is there a basic mistake in my use of these calls, or a bug/unmaintained 
> code?
> 
> I am on an XFS filesystem (otherwise the first call fails with 
> 'inappropriate ioctl'). The only documentation I can find is the man page; 
> no mention about initialising the library, and I wasn't able to find any 
> examples.
> 
> I'm on Scientific Linux 6.6 (like RedHat 6, kernel 2.6.32-504.1.3), and 
> also tried updating to the latest xfsprogs from Git, with the same 
> results.
> 
> Many thanks
> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
