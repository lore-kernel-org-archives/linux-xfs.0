Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTBGA1D031799 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 05:16:10 -0600
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E1FC4E5FC
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:16:10 -0800 (PST)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.148])
	by cuda.sgi.com with ESMTP id CIO00gAhLddDY3uJ for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:16:10 -0800 (PST)
Received: by qw-out-1920.google.com with SMTP id 5so16302545qwc.32
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:16:09 -0800 (PST)
Message-ID: <43d009740812290316v7babab12t218a0e122e05f871@mail.gmail.com>
Date: Mon, 29 Dec 2008 18:16:09 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest
	stable version of the Linux kernel is".
In-Reply-To: <4958AF9E.7070005@yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <fa.AyhwSGaa29qThLZ5OhBSbACDzmI@ifi.uio.no>
	<fa.O2INIKnSvQY5+2WFbCRxoh8xutg@ifi.uio.no>
	<fa.fGgFQweuOQlZ5w9soKo4267nPkc@ifi.uio.no>
	<4958AF9E.7070005@yahoo.com>
Reply-To: for.poige+linux@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

2008/12/29 Sitsofe Wheeler <sitsofe@yahoo.com>:
> Igor Podlesny wrote:
>>
>>        Yeah, I'll try to get backtraces, using null-modem cable, but alas,
>> I
>
> Have you tried compiling your kernel with extended checks
> (CONFIG_DEBUG_KERNEL in the Kernel hacking menu)? There are debug poisoning
> options too. Sometimes this can flush out problems before they become
> fatal...
>
2.6.28's:

# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_FS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set

	-- Nothing in dmesg; when it freezes or reboots, even if there're
some messages on console, they wouldn't be seen in graphics mode. As I
said, now my suspicion is netfilter's ipt_recent; I've turned it off
and now waiting. Another kernel I'm using now (2.6.24-ovz-006.5+) is
built with stack usage reporting; that's the latest stack depth
report:

[   54.312696] modprobe used greatest stack depth: 3904 bytes left

	Dunno whether it's rather low or ok.

-- 
End of message. Next message?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
