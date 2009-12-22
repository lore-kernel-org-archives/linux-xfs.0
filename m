Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMCY6QU131351 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 06:34:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29ACC14FEBCE
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 04:34:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	8IYVnxNP8TBeYK8s for <xfs@oss.sgi.com>;
	Tue, 22 Dec 2009 04:34:46 -0800 (PST)
Date: Tue, 22 Dec 2009 23:34:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: utimensat fails to update ctime
Message-ID: <20091222123436.GC9611@discord.disaster>
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B304D04.6040501@byu.net>
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
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, xfs@oss.sgi.com

On Mon, Dec 21, 2009 at 09:37:24PM -0700, Eric Blake wrote:
> According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
> >> It may also be file-system dependent.  On the machine where I saw the
> >> original failure:
> >>> $ uname -a
> >>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
> >>> x86_64 GNU/Linux
> >> $ df -T .
> >> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> >> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
> > 
> > Thanks.
> > 
> > This is good point. This would be xfs issue or design. xfs seems to have
> > own special handling of ctime.

Yeah, it looks like the change to utimesat() back in 2.6.26 for
posix conformance made ATTR_CTIME appear outside inode truncation
and XFS wasn't updated for this change in behaviour at the VFS level.
Looks simple to fix, but I'm worried about introducing other
unintended ctime modifications - is there a test suite that checks
posix compliant atime/mtime/ctime behaviour around anywhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
