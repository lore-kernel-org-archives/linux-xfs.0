Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F7B329DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:24:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DC43304066
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:24:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	374S6jSXBeIsK3Ua for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 17:24:47 -0800 (PST)
Date: Thu, 27 Feb 2014 12:24:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
Message-ID: <20140227012431.GW13647@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
	<20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
	<20140225041346.GA29907@dastard>
	<alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
	<20140226011347.GL13647@dastard>
	<alpine.LSU.2.11.1402251856060.1114@eggly.anvils>
	<20140226064224.GU13647@dastard>
	<alpine.LSU.2.11.1402261454270.2808@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402261454270.2808@eggly.anvils>
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
To: Hugh Dickins <hughd@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Wed, Feb 26, 2014 at 03:08:58PM -0800, Hugh Dickins wrote:
> On Wed, 26 Feb 2014, Dave Chinner wrote:
> > On Tue, Feb 25, 2014 at 08:45:15PM -0800, Hugh Dickins wrote:
> > > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > > > On Tue, Feb 25, 2014 at 03:23:35PM -0800, Hugh Dickins wrote:
> > > > 
> > > > > I should mention that when "we" implemented this thirty years ago,
> > > > > we had a strong conviction that the system call should be idempotent:
> > > > > that is, the len argument should indicate the final i_size, not the
> > > > > amount being removed from it.  Now, I don't remember the grounds for
> > > > > that conviction: maybe it was just an idealistic preference for how
> > > > > to design a good system call.  I can certainly see that defining it
> > > > > that way round would surprise many app programmers.  Just mentioning
> > > > > this in case anyone on these lists sees a practical advantage to
> > > > > doing it that way instead.
> > > > 
> > > > I don't see how specifying the end file size as an improvement. What
> > > > happens if you are collapse a range in a file that is still being
> > > > appended to by the application and so you race with a file size
> > > > update? IOWs, with such an API the range to be collapsed is
> > > > completely unpredictable, and IMO that's a fundamentally broken API.
> > > 
> > > That's fine if you don't see the idempotent API as an improvement,
> > > I just wanted to put it on the table in case someone does see an
> > > advantage to it.  But I think I'm missing something in your race
> > > example: I don't see a difference between the two APIs there.
> > 
> > 
> > Userspace can't sample the inode size via stat(2) and then use the value for a
> > syscall atomically. i.e. if you specify the offset you want to
> > collapse at, and the file size you want to have to define the region
> > to collapse, then the length you need to collapse is (current inode
> > size - end file size). If "current inode size" can change between
> > the stat(2) and fallocate() call (and it can), then the length being
> > collapsed is indeterminate....
> 
> Thanks for explaining more, I was just about to acknowledge what a good
> example that is.  Indeed, it seems not unreasonable to be editing the
> earlier part of a file while the later part of it is still streaming in.
> 
> But damn, it now occurs to me that there's still a problem at the
> streaming end: its file write offset won't be updated to reflect
> the collapse, so there would be a sparse hole at that end.  And
> collapse returns -EPERM if IS_APPEND(inode).

Well, we figure that most applications won't be using append only
inode flags for files that they know they want to edit at random
offsets later on. ;)

However, I can see how DVR apps would use open(O_APPEND) to obtain
the fd they write to because that sets the write position to the EOF
on every write() call (i.e. in generic_write_checks()). And collapse
range should behave sanely with this sort of usage.

e.g. XFS calls generic_write_checks() after it has taken the IO lock
to set the current write position to EOF. Hence it will be correctly
serialised against collapse range calls and so O_APPEND writes will
not leave sparse holes if collapse range calls are interleaved with
the write stream....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
