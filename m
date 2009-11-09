Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA9LgBDS225565
	for <linux-xfs@oss.sgi.com>; Mon, 9 Nov 2009 15:42:11 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71F0F70BB6
	for <linux-xfs@oss.sgi.com>; Mon,  9 Nov 2009 13:42:27 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id PGzDOI9TOJ3Xmbet for <linux-xfs@oss.sgi.com>;
	Mon, 09 Nov 2009 13:42:27 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1N7c0C-000808-VQ
	for linux-xfs@oss.sgi.com; Mon, 09 Nov 2009 22:42:20 +0100
Received: from adsl-068-016-104-079.sip.asm.bellsouth.net ([68.16.104.79])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 09 Nov 2009 22:42:20 +0100
Received: from ecashin by adsl-068-016-104-079.sip.asm.bellsouth.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 09 Nov 2009 22:42:20 +0100
From: Ed Cashin <ecashin@coraid.com>
Subject: Re: NULL mp->m_log in 2.6.31 xfs_log_move_tail
Date: Mon, 09 Nov 2009 16:41:58 -0500
Message-ID: <87fx8n8jfd.fsf@coraid.com>
References: <87ws1z8mbf.fsf@coraid.com> <20091109211620.GA22777@infradead.org>
Mime-Version: 1.0
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
Cc: ecashin@coraid.com

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Nov 09, 2009 at 03:39:32PM -0500, Ed Cashin wrote:
>> A colleague has seen oopses in 2.6.31 when an XFS is mounted on an AoE
>> target that becomes unresponsive and is marked as "down" by the aoe
>> driver.  The aoe driver starts failing all new I/O requests after
>> failing all current requests when the device is down.
>> 
>> I looked at the trace (included below) and put in the following check:
>
> Given that you seem to be able to reproduce it can you see if the patch
> below helps:
>
> Index: linux-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_log.c	2009-11-09 22:09:08.858026060 +0100
> +++ linux-2.6/fs/xfs/xfs_log.c	2009-11-09 22:13:13.958255857 +0100
> @@ -1602,6 +1602,8 @@ xlog_dealloc_log(xlog_t *log)
>  	xlog_in_core_t	*iclog, *next_iclog;
>  	int		i;
>  
> +	xfs_flush_buftarg(log->l_mp->m_logdev_targp, 1);
> +
>  	iclog = log->l_iclog;
>  	for (i=0; i<log->l_iclog_bufs; i++) {
>  		sv_destroy(&iclog->ic_force_wait);
>

Thanks.  I am not sure when we'll be able to try it, because the one
who discovered this issue is not currently available, but I'll try to
fit it in one way or another.  A lot of folks using AoE use XFS.

-- 
  Ed Cashin <ecashin@coraid.com>
  http://www.coraid.com/
  http://noserose.net/e/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
