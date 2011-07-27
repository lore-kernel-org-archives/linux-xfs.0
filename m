Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RCMrpQ195010 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 07:22:54 -0500
Received: from mail.tuxonice.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 284289B90B
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 05:22:52 -0700 (PDT)
Received: from mail.tuxonice.net (tuxonice.net [74.207.252.127]) by
	cuda.sgi.com with ESMTP id Ae0T8WdgaH7XA6Mj for
	<xfs@oss.sgi.com>; Wed, 27 Jul 2011 05:22:52 -0700 (PDT)
Message-ID: <4E300317.7090108@tuxonice.net>
Date: Wed, 27 Jul 2011 22:22:47 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
MIME-Version: 1.0
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
References: <4E1C70AD.1010101@u-club.de> <201107262228.12099.rjw@sisk.pl>
	<20110727004543.GE8048@dastard> <201107271135.13297.rjw@sisk.pl>
	<20110727103308.GA20805@infradead.org>
In-Reply-To: <20110727103308.GA20805@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph <cr2005@u-club.de>, xfs@oss.sgi.com, "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>

Hi.

On 27/07/11 20:33, Christoph Hellwig wrote:
> On Wed, Jul 27, 2011 at 11:35:13AM +0200, Rafael J. Wysocki wrote:
>> The Pavel's objection, if I remember it correctly, was that some
>> (or the majority of?) filesystems didn't implement the freezing operation,
>> so they would be more vulnerable to data loss in case of a failing hibernation
>> after this change.  However, that's better than actively causing pain to XFS
>> users.
> 
> The objection never made sense and only means he never read the code.
> freeze_super (or freeze_bdev back then) always does a sync_filesystem
> before even checking if we have a freeze method, and sync_filesystem is
> what we iterate over for each superblock in sync().

I've had freezing supers in TOI for a couple of years now and it has
only ever helped. To be honest, if you have a ton of dirty pages, it
does result in a big delay, but that's the worst of it.

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
