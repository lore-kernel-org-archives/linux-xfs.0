Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F8ojrj024061 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 02:50:46 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66F251801B5A
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 00:50:43 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id VzHXrEi2oLLWP61Y
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 00:50:43 -0800 (PST)
Date: Thu, 15 Jan 2009 19:50:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
Message-ID: <20090115085040.GE8071@disturbed>
References: <8604545CB7815D419F5FF108D3E434BA017C6427@emss04m05.us.lmco.com>
	<20081020230802.GA18495@disturbed>
	<8604545CB7815D419F5FF108D3E434BA01D4939D@emss04m05.us.lmco.com>
	<20081104060558.GA24242@disturbed>
	<8604545CB7815D419F5FF108D3E434BA037C7555@emss04m05.us.lmco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8604545CB7815D419F5FF108D3E434BA037C7555@emss04m05.us.lmco.com>
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
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
Cc: v9fs-developer@lists.sourceforge.net, "Johnson, Je" <je.johnson@lmco.com>, xfs@oss.sgi.com

On Wed, Jan 14, 2009 at 06:50:24PM -0500, Ngo, Andrew wrote:
> Dave,
> 
> From time to time I am still experiencing the stale mount.  From this
> last email, you want me to issue the 'echo t > /proc/sysrq-trigger'
> command to show all the processes in the machine.  Here is the capture
> of the /var/log/messages when I run the command. Please let me know what
> you find out.  Thanks...

> Jan 14 18:19:00 4003a6 kernel: date          R  running task        0 16073  24960
> Jan 14 18:19:00 4003a6 kernel:  ffff8101eb0f3d28 ffff8101eb0f3d6c 0000000000000000 ffff8101eb0f3d70
> Jan 14 18:19:00 4003a6 kernel:  0000000000000001 ffffffff802f7ba5 000000018020c228 0000000000001000
> Jan 14 18:19:00 4003a6 kernel:  0000000000000292 ffff8101eb0f3dc8 0000000000000005 ffff8101eb0f3de8
> Jan 14 18:19:00 4003a6 kernel: Call Trace:
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff802f7ba5>] xfs_bmap_search_extents+0x5b/0xe6
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff802fdfa9>] xfs_bmapi+0x26e/0xf89
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff803702f3>] __up_read+0x19/0x7f
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff80314887>] xfs_iunlock+0x57/0x79
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff8032ce6c>] xfs_free_eofblocks+0xb2/0x213
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff8029bc3a>] dput+0x26/0xd5
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff8028a033>] filp_close+0x5d/0x65
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff804c5581>] _write_lock_irq+0xf/0x10
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff80235e93>] do_exit+0x307/0x67a
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff80236275>] do_group_exit+0x6f/0x8a
> Jan 14 18:19:00 4003a6 kernel:  [<ffffffff8020bc9b>] system_call_after_swapgs+0x7b/0x80

That's the only stack trace that has any XFS references in it.
Do you have a 'date' process stuck on your machine or was this just
a "lucky" occurrence?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
