Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 11:58:53 -0700 (PDT)
Received: from poczta.o2.pl (mx12.go2.pl [193.17.41.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47IwjfB013062
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:58:46 -0700
From: =?utf-8?q?=C5=81ukasz_Fibinger?= <lucke@o2.pl>
Reply-To: lucke@o2.pl
Subject: Re: RESVSP problems
Date: Mon, 7 May 2007 20:58:32 +0200
References: <200705072004.22848.lucke@o2.pl> <463F7368.8090101@sandeen.net>
In-Reply-To: <463F7368.8090101@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072058.32679.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Monday 07 of May 2007, you wrote:
> You've probably hit:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
> unwritten extents remain unwritten after mmap() modifies them
>
> Bug dchinner about it... ;-)

Dave, consider it a bugging from my humble self :-)

> yeah... ISTR that the arguments are funky.  I can't remember if it's a
> bug or not.  :)  FWIW, allocsp just writes zeros to the file, so you
> could do it just as well from userspace w/ no fancy ioctls...  ALLOCSP
> is a bit pointless if you ask me... though maybe someone knows why it's
> there :)

Let me say that I have noticed that using ALLOCSP seems to create less extents 
than posix_fallocate/manual zeroing.

Thanks for your answer. Incidentally, I'm really happy that XFS has been 
bestowed upon linux users. Thanks for all your work, guys :-)

Cheers,

Luke
