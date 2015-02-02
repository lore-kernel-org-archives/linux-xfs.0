Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29AF97FFE
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:48:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15A5E8F8052
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:48:27 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id 9ACchkDnLAwoq8WD for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:48:26 -0800 (PST)
Date: Mon, 2 Feb 2015 14:48:26 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150202194826.GG22301@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de> <20150202192404.GI6282@dastard>
	<20150202194300.GN6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202194300.GN6282@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Feb 03, 2015 at 06:43:00AM +1100, Dave Chinner wrote:
> On Tue, Feb 03, 2015 at 06:24:04AM +1100, Dave Chinner wrote:
> > On Mon, Feb 02, 2015 at 08:30:24AM +0100, Christoph Hellwig wrote:
> > > On Thu, Jan 29, 2015 at 03:52:32PM -0500, J. Bruce Fields wrote:
> > > > Who can give us ACKs on these last five fs/xfs patches?  (And is it
> > > > going to cause trouble if they go in through the nfsd tree?)
> > > 
> > > 
> > > We'd need ACKs from Dave.  He already has pulled in two patches so
> > > we might run into some conflicts.  Maybe the best idea is to add the
> > > exportfs patch to both the XFS and nfsd trees, so each of them can
> > > pull in the rest?  Or we could commit the two XFS preparation patches
> > > to both tree and get something that compiles and works in the nfsd
> > > tree.
> > 
> > This patch has already been committed to the XFS repo.
> 
> And it looks like I missed the sync transaction on growfs patch,
> too, so I'll commit that one later today.
> 
> As to the pNFSD specific changes, I haven't really looked them over
> in any great detail yet. My main concern is that there are no
> specific regression tests for this yet, I'm not sure how we go about
> verifying it actually works properly and we don't inadvertantly
> break it in the future. Christoph?

Previously: http://lkml.kernel.org/r/20150106175611.GA16413@lst.de

	>       - any advice on testing?  Is there was some simple
	>       virtual setup that would allow any loser with no special
	>       hardware (e.g., me) to check whether they've broken the
	>       block server?

	Run two kvm VMs that share the same disk.  Create an XFS
	filesystem on the MDS, and export it.  If the client has blkmapd
	running (on Debian it needs to be started manually) it will use
	pNFS for accessing the filesystem.  Verify that using the
	per-operation counters in /proc/self/mounstats.  Repeat with
	additional clients as nessecary.

	Alternatively set up a simple iSCSI target using tgt or lio and
	connect to it from multiple clients.

Which sounds reasonable to me, but I haven't tried to incorporate this
into my regression testing yet.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
