Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 09B5F7F59
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 15:21:11 -0500 (CDT)
Date: Fri, 30 Aug 2013 15:21:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
Message-ID: <20130830202106.GK1935@sgi.com>
References: <4F75DE2B.7030807@redhat.com> <20130823201146.GW5262@sgi.com>
	<44DD3D7C-C7C8-483C-BA6D-DFF31E6363ED@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <44DD3D7C-C7C8-483C-BA6D-DFF31E6363ED@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 23, 2013 at 04:17:07PM -0400, Eric Sandeen wrote:
> On Aug 23, 2013, at 3:11 PM, Ben Myers <bpm@sgi.com> wrote:
> 
> > Hey Eric,
> > 
> > On Fri, Mar 30, 2012 at 11:24:11AM -0500, Eric Sandeen wrote:
> >> This ASSERT is testing an if_flags flag value against
> >> a di_aformat enum value.  di_aformat is never assigned
> >> XFS_IFINLINE.
> >> 
> >> This happens to work for now, because XFS_IFINLINE has
> >> the same value as XFS_DINODE_FMT_LOCAL, and that's tested
> >> just before we call this function.
> >> 
> >> However, I think the intention is to assert that we have
> >> read in the data, i.e. XFS_IFINLINE on if_flags, before
> >> we use if_data.  This is done in other places through the
> >> code as well.
> >> 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Looks like this one fell through the cracks.  You still interested in merging
> > it?
> > 
> Yep - it's fallen out of my brain by mow but if it was correct then I think it's correct now...

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
