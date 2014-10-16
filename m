Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45FBD7F3F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 22:33:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C66C8AC003
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 20:33:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kZ5ayHIv6Ypr01kA for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 20:33:47 -0700 (PDT)
Message-ID: <543F3C9A.4060603@sandeen.net>
Date: Wed, 15 Oct 2014 22:33:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsdump not work in 3.17
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
In-Reply-To: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>, xfs <xfs@oss.sgi.com>

On 10/15/14 9:31 PM, Tommy Wu wrote:
> Hi!
> 
>    xfsdump 3.1.4
>    xfsprogs 3.2.1
>    linux kerenl 3.17/3.17.1
> 

...

>    It just create  a small dump file, and if I run the same xfsdump again (or umount the filesystem), it will hang, like:
> 
> fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0 -o -J -F - /dev/vg/root | gzip > test.gz
> /sbin/xfsdump: using file dump (drive_simple) strategy
> /sbin/xfsdump: version 3.1.4 (dump format 3.0)
> /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
> /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
> /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
> /sbin/xfsdump: session label: ""
> /sbin/xfsdump: ino map phase 1: constructing initial dump list
> 
> 
>    switch back to kernel 3.16, the same command work fine.
> 

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693

addresses the small backup file, and

[PATCH] xfs: bulkstat doesn't release AGI buffer on error

(on the list) most likely addresses the hang, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
