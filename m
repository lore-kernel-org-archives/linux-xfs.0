Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39728 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753308AbeCFRTK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 12:19:10 -0500
Subject: Re: [PATCH 05/16] xfs_scrub: fix #include ordering to avoid build
 failure
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993160650.22223.13639058352038800793.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f5cff729-0bbc-2f63-5370-d23aa16ac99b@sandeen.net>
Date: Tue, 6 Mar 2018 11:19:09 -0600
MIME-Version: 1.0
In-Reply-To: <151993160650.22223.13639058352038800793.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, Mikael Magnusson <mikachu@gmail.com>

On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the ordering of the header includes in all the scrub source.  We put
> xfs.h first so that it will pull in include/linux.h which pulls in
> linux/fs.h + whatever overrides are necessary (currently limited to
> struct fsxattr) to make things work on this platform, and then we remove
> the #includes for anything that will get pulled (directly or indirectly)
> by xfs.h for cleanliness.  Without this, a user compiling new xfsprogs
> on a system with a 4.7 kernel gets this:
> 
> Building scrub
>     [CC]     disk.o
> In file included from ../include/xfs.h:37:0,
>                  from disk.c:40:
> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
>  struct fsxattr {
>         ^~~~~~~
> In file included from disk.c:31:0:
> /usr/include/linux/fs.h:155:8: note: originally defined here
>  struct fsxattr {
>         ^~~~~~~
> gmake[2]: *** [../include/buildrules:60: disk.o] Error 1
> gmake[1]: *** [include/buildrules:36: scrub] Error 2
> make: *** [Makefile:77: default] Error 2
> 
> Reported-by: Mikael Magnusson <mikachu@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

mmkay.  I guess the question of whether having our own redefined
fsxattr is wise in the first place is a different discussion.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
