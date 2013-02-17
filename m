Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA3E68023
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 18:06:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9C5D8F8033
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 16:06:06 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id Iz5FjVKaASaJaA8X
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Feb 2013 16:06:05 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id fa11so2255451pad.23
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 16:06:05 -0800 (PST)
From: Daniel Browning <db@kavod.com>
Subject: Re: xfsdump segfault
Date: Sat, 16 Feb 2013 16:06:02 -0800
References: <201302152220.46756.db@kavod.com> <20130216065111.GV26694@dastard>
In-Reply-To: <20130216065111.GV26694@dastard>
MIME-Version: 1.0
Message-Id: <201302161606.02693.db@kavod.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks for the quick response, Dave.

On Friday 15 February 2013 10:51:11 pm Dave Chinner wrote:
> On Fri, Feb 15, 2013 at 10:20:46PM -0800, Daniel Browning wrote:
> > Hello folks,
> >
> > I ran into a segfault while running xfsdump, what should I do
> > to find the cause?
> 
> xfsrestore segfaulted, not xfsdump.

Ah, yes, that's right.

> Can you run xfsdump to dump to
> a file, then xfsrestore to restore from the file, rather than piping
> one into the other? 

Done. It took a little while since it's a 2.4TiB filesystem. Here is
the last line of the "-v debug" restore (path names scrubbed for
anonymity):

xfsrestore: restoring UNIX domain socket ino 128004852 backup/secondary/backups/firefly/root/backups/[...]/etc/socket
Segmentation fault (core dumped)

[root@betelgeuse ~]# dmesg | tail -n 1
xfsrestore[18838]: segfault at 10 ip 00000033fd8478de sp 00007fcad10a0e00 error 4 in libc-2.12.so[33fd800000+189000]

So it appears that a socket is causing the problem. What should I
try next?

--
DB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
