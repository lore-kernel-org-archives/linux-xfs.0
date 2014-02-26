Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB4FC7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 19:50:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49E6DAC005
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:50:05 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	Fe0C58Kfhr0CAbb6 for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 17:50:03 -0800 (PST)
Date: Tue, 25 Feb 2014 17:52:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-Id: <20140225175216.0f0c10f9.akpm@linux-foundation.org>
In-Reply-To: <20140226013426.GM13647@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
	<20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
	<20140225041346.GA29907@dastard>
	<alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
	<20140225154128.947a2de83a2d0dc21763ccf9@linux-foundation.org>
	<20140226013426.GM13647@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>, Namjae Jeon <namjae.jeon@samsung.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Wed, 26 Feb 2014 12:34:26 +1100 Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Feb 25, 2014 at 03:41:28PM -0800, Andrew Morton wrote:
> > On Tue, 25 Feb 2014 15:23:35 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:
> > > On Tue, 25 Feb 2014, Dave Chinner wrote:
> > > > On Tue, Feb 25, 2014 at 02:16:01PM +1100, Stephen Rothwell wrote:
> > > > > On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
> > > FALLOC_FL_COLLAPSE_RANGE: I'm a little sad at the name COLLAPSE,
> > > but probably seven months too late to object.  It surprises me that
> > > you're doing all this work to deflate a part of the file, without
> > > the obvious complementary work to inflate it - presumably all those
> > > advertisers whose ads you're cutting out, will come back to us soon
> > > to ask for inflation, so that they have somewhere to reinsert them ;)
> > 
> > Yes, I was wondering that.  Why not simply "move these blocks from here
> > to there".
> 
> And open a completely unnecessary can of worms to do with
> behavioural and implementation corner cases?

But it's general.

> Do you allow it to destroy data by default? Or only allow moves into
> holes?

Overwrite.

> What do you do with range the data is moved out of? Does it just
> become a hole? What happens if the range overlaps EOF - does that
> change the file size?

Truncate.

> What if you want to move the range beyond EOF?

Extend.

> What if the source and destination ranges overlap?

Don't screw it up.

> What happens when you move the block at EOF into the middle of a
> file - do you end up with zeros padding the block and the file size
> having to be adjusted accordingly? Or do we have to *copy* all the
> data in high blocks down to fill the hole in the block?

I don't understand that.  Move the block(s) and truncate to the new
length.

> What behaviour should we expect if the filesystem can't implement
> the entire move atomically and we crash in the middle of the move?

What does collapse_range do now?

If it's a journaled filesystem, it shouldn't screw up.  If it isn't, fsck.

> I can keep going, but I'll stop here - you get the idea.

None of this seems like rocket science.

> In comparison, collapse range as a file data manipulation has very
> specific requirements and from that we can define a simple, specific
> API that allows filesystems to accelerate that operation by extent
> manipulation rather than read/memcpy/write that the applications are
> currently doing for this operation....  IOWs, collapse range is a
> simple operation, "move arbitrary blocks from here to there" is a
> nightmare both from the specification and the implementation points
> of view.

collapse_range seems weird, arbitrary and half-assed.  "Why didn't they
go all the way and do it properly".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
