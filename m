Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D8277F59
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 17:36:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E8788F8033
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 15:36:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XouhuFOGSgIqb5ey for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 15:36:47 -0800 (PST)
Date: Mon, 2 Nov 2015 10:36:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Message-ID: <20151101233632.GG10656@dastard>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4haGNytokPfgL3m-qOEw=BO4QF5dO3woLSYZDCRmL-YWg@mail.gmail.com>
	<20151030194300.GA22670@linux.intel.com>
	<CAPcyv4jnEF2g+tUs+ZZxzmdgacWhU=KepKQvXLfFVHri=Pj+Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jnEF2g+tUs+ZZxzmdgacWhU=KepKQvXLfFVHri=Pj+Jg@mail.gmail.com>
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
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Oct 30, 2015 at 12:51:40PM -0700, Dan Williams wrote:
> On Fri, Oct 30, 2015 at 12:43 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Fri, Oct 30, 2015 at 11:34:07AM -0700, Dan Williams wrote:
> >> This is great to have when the flush-the-world solution ends up
> >> killing performance.  However, there are a couple mitigating options
> >> for workloads that dirty small amounts and flush often that we need to
> >> collect data on:
> >>
> >> 1/ Using cache management and pcommit from userspace to skip calls to
> >> msync / fsync.  Although, this does not eliminate all calls to
> >> blkdev_issue_flush as the fs may invoke it for other reasons.  I
> >> suspect turning on REQ_FUA support eliminates a number of those
> >> invocations, and pmem already satisfies REQ_FUA semantics by default.
> >
> > Sure, I'll turn on REQ_FUA in addition to REQ_FLUSH - I agree that PMEM
> > already handles the requirements of REQ_FUA, but I didn't realize that it
> > might reduce the number of REQ_FLUSH bios we receive.
> 
> I'll let Dave chime in, but a lot of the flush requirements come from
> guaranteeing the state of the metadata, if metadata updates can be
> done with REQ_FUA then there is no subsequent need to flush.

No need for cache flushes in this case, but we still need the IO
scheduler to order such operations correctly.

> >> 2/ Turn off DAX and use the page cache.  As Dave mentions [1] we
> >> should enable this control on a per-inode basis.  I'm folding in this
> >> capability as a blkdev_ioctl for the next version of the raw block DAX
> >> support patch.
> >
> > Umm...I think you just said "the way to avoid this delay is to just not use
> > DAX".  :)  I don't think this is where we want to go - we are trying to make
> > DAX better, not abandon it.
> 
> That's a bit of an exaggeration.  Avoiding DAX where it is not
> necessary is not "abandoning DAX", it's using the right tool for the
> job.  Page cache is fine for many cases.

Think btrfs - any file that uses COW can't use DAX for write.
Everything has to be buffered, unless the nodatacow flag is set, and
then DAX can be used. Indeed, on ext4 if you are using file
encryption you can't use DAX.

IOWs, we already know that we have to support mixed DAX/non-DAX
access within the same filesystem, so I'm with Dan here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
