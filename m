Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLF4s1H050320 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 09:04:55 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD5C2E7D3E3
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 07:05:32 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id r6zkX4wGoXh1JKX6 for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2009 07:05:32 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
Date: Tue, 22 Dec 2009 00:05:27 +0900
In-Reply-To: <4B2F7A95.3010708@byu.net> (Eric Blake's message of "Mon, 21 Dec
	2009 06:39:33 -0700")
Message-ID: <87hbrkjrk8.fsf@devron.myhome.or.jp>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Blake <ebb9@byu.net>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Eric Blake <ebb9@byu.net> writes:

According to OGAWA Hirofumi on 12/21/2009 12:31 AM:
>>> This in turn caused a regression in coreutils 8.2, visible through 'touch -a':
>>> http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00171.html
>>>
>>> GNU coreutils will end up working around the bug by calling fstat/[l]stat
>>> prior to futimens/utimensat, and populating the mtime field with the
>>> desired value rather than using UTIME_OMIT.  But this is a pointless stat
>>> call, which could be avoided if the kernel were fixed to comply with POSIX
>>> by updating ctime even when mtime is UTIME_OMIT.
>> 
>> I couldn't reproduce this with your test program on my machine (latest
>> linus tree). And that utime path looks like no problem, um..., can you
>> provide output of strace or something?

> According to Eric Blake on 12/21/2009 6:12 AM:
>
> It may also be file-system dependent.  On the machine where I saw the
> original failure:
>> $ uname -a
>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>> x86_64 GNU/Linux
>
> $ df -T .
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data

Thanks.

This is good point. This would be xfs issue or design. xfs seems to have
own special handling of ctime.

Cc: to xfs peoples. Any idea?

> But on the machine where the test case is working:
>> $ uname -a
>> Linux vladim 2.6.31.6-166.fc12.i686 #1 SMP Wed Dec 9 11:14:59 EST 2009
>> i686 GNU/Linux
>
> $ df -T .
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sda3     ext3    34123236  25894932   6494892  80% /

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
