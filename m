Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VJj3k5232379 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 14:45:03 -0500
Date: Wed, 31 Oct 2012 14:46:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsdump:fill in bs_forkoff
Message-ID: <20121031194654.GB9783@sgi.com>
References: <5080D0BD.3000304@redhat.com> <20121030194718.GD405@sgi.com>
	<50903075.6060600@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50903075.6060600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Eric,

On Tue, Oct 30, 2012 at 02:54:29PM -0500, Eric Sandeen wrote:
> On 10/30/12 2:47 PM, Ben Myers wrote:
> > Hey Eric,
> > 
> > On Thu, Oct 18, 2012 at 11:02:05PM -0500, Eric Sandeen wrote:
> >> Upstream, the structure containing bs_forkoff is actually zeroed
> >> prior to these functions, but when pulling the patch back to an
> >> older xfsdump, we got checksum errors due to an uninitialized
> >> bs_forkoff not matching in dump vs. restore.
> >>
> >> So even though forkoff won't be explicitly restored from
> >> a dump, do explicitly set it in these routines to keep checksums
> >> happy.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Would you say that this is appropriate for the upcoming release?
> 
> Hm.
> 
> The zeroing isn't in a really obvious spot, IIRC, so explicitly
> filling in all members leaves nothing to chance.
> 
> OTOH it's a member that (will/should) never get restored,
> so filling it in is a little confusing.  What do you think?
>
> I think it should be harmless to functionality either way.

It seemed like it could be an important bugfix but I wasn't really sure so I
asked.  Since it sounds like it's not a big deal, lets just hold off till after
the release...

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
