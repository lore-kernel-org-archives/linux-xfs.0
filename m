Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BBCDF7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:54:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2E50304032
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 14:54:59 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	03ZnJlwYR3vY5eJx for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 14:54:57 -0700 (PDT)
Date: Thu, 23 May 2013 07:54:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522215454.GL29466@dastard>
References: <20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522055147.GI29466@dastard>
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

On Wed, May 22, 2013 at 03:51:47PM +1000, Dave Chinner wrote:
> On Wed, May 22, 2013 at 01:29:38AM -0400, Dave Jones wrote:
> > On Wed, May 22, 2013 at 03:12:43PM +1000, Dave Chinner wrote:
> > 
> >  > > [   36.339105] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffb8\xffffffd3-\xffffff88\xffffffff\xffffffff
> >  > 
> >  > So, still the same strange mask. That just doesn't seem right.
> > 
> > any idea what I screwed up in the filename printing part ?
> 
> Nope.
> 
> Right now, I have nothing for you but disappointment....
> 
> >  > > [   36.350823] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
> >  > > [   36.359459] ------------[ cut here ]------------
> >  > > [   36.365247] kernel BUG at fs/xfs/xfs_message.c:108!
> >  > > [   36.371360] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >  > > [   36.379091] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd soundcore pps_core
> >  > > [   36.405431] CPU: 1 PID: 2887 Comm: cc1 Not tainted 3.10.0-rc2+ #4
> >  > 
> >  > Your compiler is triggering this? That doesn't seem likely...
> > 
> > yeah, though it seems pretty much anything that writes to that partition will cause it.
> > Here's fsx, which died instantly...
> > 
> > [   34.938367] XFS (sda2): xfs_setattr_size: mask 0x2068 mismatch on file 
> > 
> > (Note, different mask this time)
> 
> Which has ATTR_FORCE set but not ATTR_KILL_SUID or ATTR_KILL_SGID.
> And that, AFAICT, is impossible.

Gah, I've got not idea what the hell I was smoking yesterday
afternoon. 0x2000 is actually ATTR_FILE, and 0x8000 is ATTR_OPEN.

So a mask of 0xa068 is correct and valid from the open path, and
0x2068 is just file from the truncate path.

But, neither of those should trigger that assert. indeed, on a test
kernel (3.10-rc2 based):

# echo I need a new drug > /mnt/scr/bah/blah/black/sheep/foo
[  296.742990] XFS (vdb): xfs_setattr_size: mask 0xa068, masked # 0x0 ii 0xffff88003e6297c0, d 0xffff88003e5b9cb0 path /bah/blah/black/sheep/foo
#

And there's not assert failure. Indeed, the "masked # 0x0" is what
the assert is checking.

And yeah, path output works. Trick for anyone who doesn't read the
code closely - the buffer is filled from the end backwards, and the
start of the path is the return variable. So, the above code is:

	{
		struct dentry *d = d_find_alias(VFS_I(ip));
		char buf[MAXPATHLEN];
		char *ptr;

		memset(buf, 0, MAXPATHLEN);
		ptr = dentry_path(d, buf, MAXPATHLEN);
		xfs_warn(mp, "%s: mask 0x%x, masked 0x%x ii 0x%p, d 0x%p path %s",
			__func__, mask,
	(mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
			ATTR_KILL_PRIV|ATTR_TIMES_SET)),
			ip, d, ptr);
		dput(d);
	}

Which I put just before the assert that is firing on your machine.

And, obviously, it isn't firing on mine and obviously shouldn't be firing on a
mask of 0xa068.

Gah, what a mess. Sorry for the run-around, Dave, my brain clearly
wasn't working yesterday afternoon.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
