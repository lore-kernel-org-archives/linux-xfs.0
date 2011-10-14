Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EEqafZ007113
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 09:52:38 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E273E1472C94
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 08:00:08 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id OY371PJ6lQ5JGLbI for <linux-xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 08:00:08 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1REj7i-0002sE-8u
	for linux-xfs@oss.sgi.com; Fri, 14 Oct 2011 16:52:34 +0200
Received: from ip-89-176-6-41.net.upcbroadband.cz ([89.176.6.41])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 16:52:34 +0200
Received: from zkaspar82 by ip-89-176-6-41.net.upcbroadband.cz with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 16:52:34 +0200
From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: Advanced Format drive - sectsz question
Date: Fri, 14 Oct 2011 16:51:39 +0200
Message-ID: <4E984C7B.3060201@gmail.com>
References: <j783rh$gn7$1@dough.gmane.org>
	<20111014132019.GA4711@infradead.org>
Mime-Version: 1.0
In-Reply-To: <20111014132019.GA4711@infradead.org>
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
To: linux-xfs@oss.sgi.com

Dne 14.10.2011 15:20, Christoph Hellwig napsal(a):
> On Fri, Oct 14, 2011 at 03:38:14AM +0200, Zdenek Kaspar wrote:
>> Hello list, I have hard drive which reports:
>>
>> logical_block_size  ->  512
>> physical_block_size -> 4096
>>
>> Default mkfs.xfs sets sectsz to 512.
>>
>> kernel-2.6.32-131.17.1.el6.x86_64
>> xfsprogs-3.1.1-4.el6.x86_64
>>
>> Is mkfs.xfs -s size=4096 the right way?
> 
> Yes, we probably should default to 4096 bytes sector size for these
> drivers, but still allow 512 byte sector sized filesystems if explicitly
> requested.

Makes sense, thanks for clarification Christoph.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
