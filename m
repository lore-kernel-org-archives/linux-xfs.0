Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26ABE29E03
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 00:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 945E7AC002
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 22:12:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	324kx6uFzlTq6zSi for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 22:12:46 -0700 (PDT)
Date: Wed, 22 May 2013 15:12:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522051243.GH29466@dastard>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522041521.GA1837@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 22, 2013 at 12:15:21AM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 02:03:18PM +1000, Dave Chinner wrote:
> 
>  > That doesn't make a whole lot of sense to me. What am I missing?
>  > Are you seeing this fire at all from notify_change()?
>  > 
>  > 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
> 
> No.
>  
>  > <Light Bulb>
>  > 
>  > What's wrong with this code in do_truncate()?
>  > 
>  >         /* Remove suid/sgid on truncate too */
>  >         ret = should_remove_suid(dentry);
>  >         if (ret)
>  >                 newattrs.ia_valid |= ret | ATTR_FORCE;
>  > 
>  >         mutex_lock(&dentry->d_inode->i_mutex);
>  >         ret = notify_change(dentry, &newattrs);
>  >         mutex_unlock(&dentry->d_inode->i_mutex);
>  > 
>  > Patch below to fix this.
>  > 
>  > However, it probably doesn't fix the fact that truncate can change
>  > the size and kill suid/sgid bits at the same time and XFS doesn't
>  > appear to handle that sanely right now. Can you run the patch below
>  > just so when it fails we can see that the mask is actually sane?
> 
> [   36.339105] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffb8\xffffffd3-\xffffff88\xffffffff\xffffffff

So, still the same strange mask. That just doesn't seem right.

> [   36.350823] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
> [   36.359459] ------------[ cut here ]------------
> [   36.365247] kernel BUG at fs/xfs/xfs_message.c:108!
> [   36.371360] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [   36.379091] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd soundcore pps_core
> [   36.405431] CPU: 1 PID: 2887 Comm: cc1 Not tainted 3.10.0-rc2+ #4

Your compiler is triggering this? That doesn't seem likely...

> [   36.578436] Call Trace:
> [   36.581514]  [<ffffffffa01bc3ef>] xfs_setattr_size+0x48f/0x630 [xfs]
> [   36.738533]  [<ffffffffa01bc5c6>] xfs_vn_setattr+0x36/0x40 [xfs]
> [   36.746047]  [<ffffffff811c8e2c>] notify_change+0x1dc/0x360
> [   36.753024]  [<ffffffff811a9d9d>] do_truncate+0x6d/0xa0
> [   36.759574]  [<ffffffffa01ae0a0>] ? xfs_extent_busy_ag_cmp+0x20/0x20 [xfs]
> [   36.768182]  [<ffffffff811bb4af>] do_last+0x54f/0xe40
> [   36.775319]  [<ffffffff811bbe53>] path_openat+0xb3/0x530
> [   36.782780]  [<ffffffff810b3951>] ? lock_release_holdtime.part.30+0xa1/0x170
> [   36.792408]  [<ffffffff811bc958>] do_filp_open+0x38/0x80
> [   36.799870]  [<ffffffff816ea961>] ? _raw_spin_unlock+0x31/0x60
> [   36.807981]  [<ffffffff811cb49f>] ? __alloc_fd+0xaf/0x200
> [   36.815544]  [<ffffffff811aae19>] do_sys_open+0xe9/0x1c0
> [   36.822989]  [<ffffffff811aaf0e>] SyS_open+0x1e/0x20

This has come through the open path via handle_truncate(), which
means that ATTR_MTIME|ATTR_CTIME|ATTR_OPEN|ATTR_FILE should also be
set in the mask. They aren't, and that says to me that something
else has been blottoed before XFS trips over this. Memory
corruption?

Can you print out the entire struct iattr? perhaps even hexdump it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
