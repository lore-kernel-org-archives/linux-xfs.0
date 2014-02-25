Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5EB97F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:41:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70522AC005
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:41:36 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	hEPSUBMBb80zY3Ls for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 15:41:34 -0800 (PST)
Date: Tue, 25 Feb 2014 15:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-Id: <20140225154128.947a2de83a2d0dc21763ccf9@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
	<20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
	<20140225041346.GA29907@dastard>
	<alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
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
To: Hugh Dickins <hughd@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Tue, 25 Feb 2014 15:23:35 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:

> On Tue, 25 Feb 2014, Dave Chinner wrote:
> > On Tue, Feb 25, 2014 at 02:16:01PM +1100, Stephen Rothwell wrote:
> > > On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > > Namjae Jeon (10):
> > > > >   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
> > > > >   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > > > 
> > > > I've pushed these to the following branch:
> > > > 
> > > > 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
> > > > 
> > > > And so they'll be in tomorrow's linux-next tree.
> > > > 
> > > > >   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > > > 
> > > > I've left this one alone for the ext4 guys to sort out.
> > > 
> > > So presumably that xfs tree branch is now completely stable and so Ted
> > > could just merge that branch into the ext4 tree as well and put the ext4
> > > part on top of that in his tree.
> > 
> > Well, for some definition of stable. Right now it's just a topic
> > branch that is merged into the for-next branch, so in theory it is
> > still just a set of pending changes in a branch in a repo that has
> > been pushed to linux-next for testing.
> > 
> > That said, I don't see that branch changing unless we find bugs in
> > the code or a problem with the API needs fixing, at which point I
> > would add more commits to it and rebase the for-next branch that you
> > are pulling into the linux-next tree.
> > 
> > Realistically, I'm waiting for Lukas to repost his other pending
> > fallocate changes (the zero range changes) so I can pull the VFS and
> > XFS bits of that into the XFS tree and I can test them together
> > before I'll call the xfs-collapse-range stable and ready to be
> > merged into some other tree...
>
> ...
>
> Emphasis on "might": I expect it's impossible, given your current
> approach, but something to be on guard against is unmap_mapping_range()
> failing to find and unmap a pte, because the page is mapped at the
> "wrong" place in the vma, resulting in BUG_ON(page_mapped(page))
> in __delete_from_page_cache().

It should be well tested with non-linear mappings please.  It *should*
be OK, but...

>
> ...
>
> FALLOC_FL_COLLAPSE_RANGE: I'm a little sad at the name COLLAPSE,
> but probably seven months too late to object.  It surprises me that
> you're doing all this work to deflate a part of the file, without
> the obvious complementary work to inflate it - presumably all those
> advertisers whose ads you're cutting out, will come back to us soon
> to ask for inflation, so that they have somewhere to reinsert them ;)

Yes, I was wondering that.  Why not simply "move these blocks from here
to there".


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
