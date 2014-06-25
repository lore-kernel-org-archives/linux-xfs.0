Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE5B87F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 10:29:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C3FBB8F8068
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 08:28:58 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com
	[209.85.192.45]) by cuda.sgi.com with ESMTP id xRM3CV1uoyL1hzuB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jun 2014 08:28:47 -0700 (PDT)
Received: by mail-qg0-f45.google.com with SMTP id 63so1815078qgz.32
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 08:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625012144.GK9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
Date: Wed, 25 Jun 2014 17:28:46 +0200
Message-ID: <CA+o=1OVmoGxtX2J9_dxwiT8N5f5MjnUaWvNV+zBiMeh4WAsjiA@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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

2014-06-25 3:21 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> What kernel are you running? (uname -a, please)

Linux (none) 3.15.1-1-ARCH #1 SMP PREEMPT Tue Jun 17 09:32:20 CEST
2014 x86_64 GNU/Linux

> Can you reproduce the problem on demand from a brand new filesystem?
> If so, can you run the cycle:
>
>         mount
>         write
>         crash
>         <restart>
>         take metadump
>         mount
>         unmount
>         run xfs_repair -n <dev>
>         if clean
>                 do another iteration
>         otherwise, something is wrong.
>         record dmesg
>         take a post-mount metadump
>         post the pre- and post-mount metadumps for me to look at
>         post the entire dmesg so I can look at it.

I can try.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
