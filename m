Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH2RUeQ157933 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 20:27:32 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0453E1C4C93D
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 18:29:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RfHuGpuJE85zLp7d for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 18:29:03 -0800 (PST)
Date: Tue, 16 Nov 2010 21:28:14 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101117022814.GB5618@dhcp231-156.rdu.redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
	<20101116114346.GB4757@quack.suse.cz>
	<20101116125249.GB31957@dhcp231-156.rdu.redhat.com>
	<20101116131451.GH4757@quack.suse.cz>
	<18ACAA85-8847-4B12-9839-F99FB6C7B3E4@dilger.ca>
	<20101117021150.GL22876@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101117021150.GL22876@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Nov 17, 2010 at 01:11:50PM +1100, Dave Chinner wrote:
> On Tue, Nov 16, 2010 at 06:22:47PM -0600, Andreas Dilger wrote:
> > On 2010-11-16, at 07:14, Jan Kara wrote:
> > >> Yeah I went back and forth on this.  KEEP_SIZE won't change the
> > >> behavior of PUNCH_HOLE since PUNCH_HOLE implicitly means keep
> > >> the size.  I figured since its "mode" and not "flags" it would
> > >> be ok to make either way accepted, but if you prefer PUNCH_HOLE
> > >> means you have to have KEEP_SIZE set then I'm cool with that,
> > >> just let me know one way or the other.
> > > 
> > > So we call it "mode" but speak about "flags"? Seems a bit
> > > inconsistent.  I'd maybe lean a bit at the "flags" side and just
> > > make sure that only one of FALLOC_FL_KEEP_SIZE,
> > > FALLOC_FL_PUNCH_HOLE is set (interpreting FALLOC_FL_KEEP_SIZE as
> > > allocate blocks beyond i_size). But I'm not sure what others
> > > think.
> > 
> > IMHO, it makes more sense for consistency and "get what users
> > expect" that these be treated as flags.  Some users will want
> > KEEP_SIZE, but in other cases it may make sense that a hole punch
> > at the end of a file should shrink the file (i.e. the opposite of
> > an append).
> 
> What's wrong with ftruncate() for this?
> 
> There's plenty of open questions about the interface if we allow
> hole punching to change the file size. e.g. where do we set the EOF
> (offset or offset+len)?  What do we do with the rest of the blocks
> that are now beyond EOF?  We weren't asked to punch them out, so do
> we leave them behind? What if we are leaving written blocks beyond
> EOF - does any filesystem other than XFS support that (i.e. are we
> introducing different behaviour on different filesystems)?  And what
> happens if the offset is beyond EOF? Do we extend the file, and if
> so why wouldn't you just use ftruncate() instead?
> 
> IMO, allowing hole punching to change the file size makes it much
> more complicated and hence less likely to simply do what the user
> expects. It also is harder to implement and testing becomes much
> more intricate. From that perspective, it does not seem desirable to
> me...
> 

FWIW I agree with Dave, the only question at this point is do we force users to
specify KEEP_SIZE with PUNCH_HOLE?  On one hand it makes the interface a bit
more consistent, on the other hand it makes the documentation a little weird

"We have mode here, but if you want to use PUNCH_HOLE you also have to specify
KEEP_SIZE, so really it's like a flags field it's just named poorly"

I have no strong opinions the other way so if nobody else does then I'll just do
it Jan's way.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
