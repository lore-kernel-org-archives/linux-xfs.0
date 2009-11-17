Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAHLmDmp076621 for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 15:48:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BCDFD53790
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 13:48:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	BkTRz0yZiIH2V8NK for <xfs@oss.sgi.com>;
	Tue, 17 Nov 2009 13:48:32 -0800 (PST)
Date: Wed, 18 Nov 2009 08:48:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: copy li_lsn before dropping AIL lock
Message-ID: <20091117214828.GJ9467@discord.disaster>
References: <4B01AD54.3030008@houseofnate.net>
	<20091117151318.GA19893@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091117151318.GA19893@infradead.org>
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
Cc: "Nathaniel W. Turner" <nate@houseofnate.net>, xfs@oss.sgi.com

On Tue, Nov 17, 2009 at 10:13:18AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 16, 2009 at 02:51:48PM -0500, Nathaniel W. Turner wrote:
> > Access to log items on the AIL is generally protected by m_ail_lock;
> > this is particularly needed when we're getting or setting the 64-bit
> > li_lsn on a 32-bit platform.  This patch fixes a couple places where we
> > were accessing the log item after dropping the AIL lock on 32-bit
> > machines.
> >
> > This can result in a partially-zeroed log->l_tail_lsn if
> > xfs_trans_ail_delete is racing with xfs_trans_ail_update, and in at
> > least some cases, this can leave the l_tail_lsn with a zero cycle
> > number, which means xlog_space_left will think the log is full (unless
> > CONFIG_XFS_DEBUG is set, in which case we'll trip an ASSERT), leading to
> > processes stuck forever in xlog_grant_log_space.
> 
> Might this also cause this oops?
> 
> http://www.kerneloops.org/raw.php?rawid=944396&msgid=
> 
> It's been shoving up a few times recently.

I don't think so. That trace is in xfs_close_devices(), which is
called after xfs_unmountfs->xfs_log_unmount->xlog_dealloc, which
tends to imply that mp->m_log is NULL.

i.e. we have IO being flushed when no IO should be pending. Given
that there is a xfs->bdstrat_cb->xfs_bioerror trace in there, it
looks like the buffer could not be written because the system is in
a forced shutdown situation. I have no idea what that buffer might
be or why it wasn't issued and completed during the other flushes
and waits during the unmount process....

> Anyway, the patch looks good to me, but I wonder if we should abstract
> the li_lsn handling a bit more to avoid easily running into this kind of
> problems.

Worth considering, IMO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
