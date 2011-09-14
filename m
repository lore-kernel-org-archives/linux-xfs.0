Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EG63W7149399 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 11:06:04 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 854461C0FB19
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 09:06:01 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id YEcBGIqfPq2ffZbd
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 09:06:01 -0700 (PDT)
Message-ID: <4E70D0E8.4000708@profihost.ag>
Date: Wed, 14 Sep 2011 18:06:00 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
In-Reply-To: <20110914143005.GA28496@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

Hi,

Am 14.09.2011 16:30, schrieb Christoph Hellwig:
> On Wed, Sep 14, 2011 at 09:48:18AM +0200, Stefan Priebe - Profihost AG wrote:
>> #0: (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [] do_last+0x287/0x693
>
> This means you are running your heavy load with lockdep enabled.  I
> can't see how it directly causes your issues, but it will slow anything
> down to almost a grinding halt on systems with more than say two cores.
>
> Can you run with CONFIG_DEBUG_LOCK_ALLOC / and CONFIG_PROVE_LOCKING
> disabled/  It might be worth if you have other really heavy debugging
> options enabled, too.

i just enabled it while trying to find out the cause of my problems.

My actual config has:
# grep -i 'DEBUG' .config|egrep -v "^# "
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_RODATA=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y


my original config had:
# grep -i 'DEBUG' .config_stillnotworking|egrep -v "^# "
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_RODATA=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y

With both configs i'm seeing the SAME symptoms after a while.

Which options should i disable?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
