Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC8E97F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:49:22 -0600 (CST)
Date: Tue, 29 Jan 2013 12:49:18 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
Message-ID: <20130129184918.GG27055@sgi.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
	<1359240032-11576-3-git-send-email-sandeen@redhat.com>
	<20130128003542.GB16727@disturbed.disaster>
	<FE50BC18-140F-43E6-848A-EE4C9B79C9FC@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <FE50BC18-140F-43E6-848A-EE4C9B79C9FC@redhat.com>
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
To: Eric Sandeen <esandeen@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hey,

On Sun, Jan 27, 2013 at 09:41:28PM -0500, Eric Sandeen wrote:
> On Jan 27, 2013, at 8:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Sat, Jan 26, 2013 at 04:40:26PM -0600, Eric Sandeen wrote:
> >> This is a merge-to-userspace of kernel commit a0041684
> >> xfs: zero allocation_args on the kernel stack
> >> 
> >> When calling xfs_alloc_vextent args.userdata was uninitialized,
> >> and if we had args.type==XFS_ALLOCTYPE_START_BNO, this uninit
> >> structure member got tested, leading to some random allocator
> >> behavior.
> > 
> > Got that as part of the kernel-user sync I sent out a couple of
> > weeks back.
> > 
> > BTW, perhaps we want to get that sync sorted out before shovelling
> > a bunch of stuff into xfsprogs that will require fixing conflicts in
> > that sync up?
> > 
> I have no problem with this going 2nd, I can fix up as needed.

We need to do another userspace release to resolve the backward compatability
issue for Fugazzi and missing source file in xfsprogs for Arkadiusz before
shovelling in that ueber patch.  If any of these patches are bug fixes
appropriate for a release within the next week or so, give a heads up.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
