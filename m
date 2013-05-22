Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEBD429E03
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 00:51:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90BEE304043
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 22:51:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4P1gEcSB96dEJ5Rl for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 22:51:49 -0700 (PDT)
Date: Wed, 22 May 2013 15:51:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522055147.GI29466@dastard>
References: <20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522052938.GA2573@redhat.com>
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

On Wed, May 22, 2013 at 01:29:38AM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 03:12:43PM +1000, Dave Chinner wrote:
> 
>  > > [   36.339105] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffb8\xffffffd3-\xffffff88\xffffffff\xffffffff
>  > 
>  > So, still the same strange mask. That just doesn't seem right.
> 
> any idea what I screwed up in the filename printing part ?

Nope.

Right now, I have nothing for you but disappointment....

>  > > [   36.350823] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
>  > > [   36.359459] ------------[ cut here ]------------
>  > > [   36.365247] kernel BUG at fs/xfs/xfs_message.c:108!
>  > > [   36.371360] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  > > [   36.379091] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd soundcore pps_core
>  > > [   36.405431] CPU: 1 PID: 2887 Comm: cc1 Not tainted 3.10.0-rc2+ #4
>  > 
>  > Your compiler is triggering this? That doesn't seem likely...
> 
> yeah, though it seems pretty much anything that writes to that partition will cause it.
> Here's fsx, which died instantly...
> 
> [   34.938367] XFS (sda2): xfs_setattr_size: mask 0x2068 mismatch on file 
> 
> (Note, different mask this time)

Which has ATTR_FORCE set but not ATTR_KILL_SUID or ATTR_KILL_SGID.
And that, AFAICT, is impossible.

>  > This has come through the open path via handle_truncate(), which
>  > means that ATTR_MTIME|ATTR_CTIME|ATTR_OPEN|ATTR_FILE should also be
>  > set in the mask. They aren't, and that says to me that something
>  > else has been blottoed before XFS trips over this. Memory
>  > corruption?
>  >
>  > Can you print out the entire struct iattr? perhaps even hexdump it?
> 
> About to turn in for the night. If there's a shiny diff in my inbox in the morning,
> I'll try it.

I wouldn't lose sleep over it - I'm stumped at this point. I'll get
a working path print to you, at minimum...

> Tomorrow I'll also try running some older kernels with the same
> options to see if it's something new, or an older bug. This is a
> new machine, so it may be something that's been around for a
> while, and for whatever reason, my other machines don't hit
> this.

Another thing that just occurred to me - what compiler are you
using?  We had a report last week on #xfs that xfsdump was failing
with bad checksums because of link time optimisation (LTO) in
gcc-4.8.0. When they turned that off, everything worked fine. So if
you are using 4.8.0, perhaps trying a different compiler might be a
good idea, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
