Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40CEC7CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 14:01:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 169178F8059
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 12:01:17 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	cK3cA1W0jo48OBsJ for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 12:01:10 -0800 (PST)
Date: Mon, 16 Nov 2015 13:01:02 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 00/11] DAX fsynx/msync support
Message-ID: <20151116200102.GA9737@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151116144130.GD3443@quack.suse.cz>
	<CAPcyv4gb8rh4Xkn-yzjbazftnXp8f6hr21LR5ZZehQBNLeNkZA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gb8rh4Xkn-yzjbazftnXp8f6hr21LR5ZZehQBNLeNkZA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Mon, Nov 16, 2015 at 08:58:11AM -0800, Dan Williams wrote:
> On Mon, Nov 16, 2015 at 6:41 AM, Jan Kara <jack@suse.cz> wrote:
> > On Fri 13-11-15 17:06:39, Ross Zwisler wrote:
> >> This patch series adds support for fsync/msync to DAX.
> >>
> >> Patches 1 through 7 add various utilities that the DAX code will eventually
> >> need, and the DAX code itself is added by patch 8.  Patches 9-11 update the
> >> three filesystems that currently support DAX, ext2, ext4 and XFS, to use
> >> the new DAX fsync/msync code.
> >>
> >> These patches build on the recent DAX locking changes from Dave Chinner,
> >> Jan Kara and myself.  Dave's changes for XFS and my changes for ext2 have
> >> been merged in the v4.4 window, but Jan's are still unmerged.  You can grab
> >> them here:
> >>
> >> http://www.spinics.net/lists/linux-ext4/msg49951.html
> >
> > I had a quick look and the patches look sane to me. I'll try to give them
> > more detailed look later this week. When thinking about the general design
> > I was wondering: When we have this infrastructure to track data potentially
> > lingering in CPU caches, would not it be a performance win to use standard
> > cached stores in dax_io() and mark corresponding pages as dirty in page
> > cache the same way as this patch set does it for mmaped writes? I have no
> > idea how costly are non-temporal stores compared to cached ones and how
> > would this compare to the cost of dirty tracking so this may be just
> > completely bogus...
> 
> Keep in mind that this approach will flush every virtual address that
> may be dirty.  For example, if you touch 1byte in a 2MB page we'll end
> up looping through the entire 2MB range.  At some point the dirty size
> becomes large enough that is cheaper to flush the entire cache, we
> have not measured where that crossover point is.

Yep, I expect there will be a crossover point where flushing the entire
processor cache will be beneficial.  I agree with Dan that we'll need to
figure this out via measurement, and that we'd similarly need measurements to
justify the decision to write dirty data at the DAX level without flushing and
mark entries as dirty for fsync/msync to clean up later.  It could turn out to
be great, but we'll have to see. :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
