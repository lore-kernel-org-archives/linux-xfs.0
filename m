Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAHFCvEA041745 for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 09:13:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5641114E0EEA
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 07:13:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IfxH0WPEBpoAjwBI for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2009 07:13:19 -0800 (PST)
Date: Tue, 17 Nov 2009 10:13:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: copy li_lsn before dropping AIL lock
Message-ID: <20091117151318.GA19893@infradead.org>
References: <4B01AD54.3030008@houseofnate.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B01AD54.3030008@houseofnate.net>
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
To: "Nathaniel W. Turner" <nate@houseofnate.net>
Cc: xfs@oss.sgi.com

On Mon, Nov 16, 2009 at 02:51:48PM -0500, Nathaniel W. Turner wrote:
> Access to log items on the AIL is generally protected by m_ail_lock;
> this is particularly needed when we're getting or setting the 64-bit
> li_lsn on a 32-bit platform.  This patch fixes a couple places where we
> were accessing the log item after dropping the AIL lock on 32-bit
> machines.
>
> This can result in a partially-zeroed log->l_tail_lsn if
> xfs_trans_ail_delete is racing with xfs_trans_ail_update, and in at
> least some cases, this can leave the l_tail_lsn with a zero cycle
> number, which means xlog_space_left will think the log is full (unless
> CONFIG_XFS_DEBUG is set, in which case we'll trip an ASSERT), leading to
> processes stuck forever in xlog_grant_log_space.

Might this also cause this oops?

http://www.kerneloops.org/raw.php?rawid=944396&msgid=

It's been shoving up a few times recently.

Anyway, the patch looks good to me, but I wonder if we should abstract
the li_lsn handling a bit more to avoid easily running into this kind of
problems.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
