Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n754W25j215766 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 23:32:03 -0500
Received: from mail.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F6F913A9F1B
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 21:32:52 -0700 (PDT)
Received: from mail.vpac.org (mail.vpac.org [202.158.218.6]) by cuda.sgi.com
	with ESMTP id iqgNeoADYEVqJe63 for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2009 21:32:52 -0700 (PDT)
Date: Wed, 5 Aug 2009 14:32:44 +1000 (EST)
From: Chris Samuel <csamuel@vpac.org>
Message-ID: <1485133780.793941249446764456.JavaMail.root@mail.vpac.org>
In-Reply-To: <4A790A09.8050502@sandeen.net>
Subject: Re: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

Hi Eric,

Thanks for the speedy response!

> I'll take a look. [...]

Thanks for that.

> Is there any chance you could instrument xfs_rename so that for every
> goto abort_return and goto error_return you add a printk so we know
> which one you hit?

Happy to do that, though we won't be able to reboot into it
until another crash fails (the impact on the HPC jobs is too
large I'm afraid :-( ).

> Maybe something like:
> 
> printk("line %s error %d\n", __LINE__, error);
> 
> just before each goto, with appropriate braces {} sprinkled in as
> necessary?
> 
> I can send a patch if that helps.

If you could that would be great, we'd really appreciate it
(I'm about to disappear into an afternoon of meetings now).

> Sorry for the brute-force debugging but not at all sure
> yet what this may be.

No worries, quite understand!

All the best,
Chris
-- 
Christopher Samuel - (03) 9925 4751 - Systems Manager
 The Victorian Partnership for Advanced Computing
 P.O. Box 201, Carlton South, VIC 3053, Australia
VPAC is a not-for-profit Registered Research Agency

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
