Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66DWLDt121805 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 08:32:21 -0500
Subject: Re: [PATCH 00/27] patch queue for Linux 3.1, V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110706064209.GB4508@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<1309927217.3381.65.camel@doink> <20110706064209.GB4508@infradead.org>
Date: Wed, 6 Jul 2011 08:32:17 -0500
Message-ID: <1309959137.1931.1.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-07-06 at 02:42 -0400, Christoph Hellwig wrote:
> On Tue, Jul 05, 2011 at 11:40:17PM -0500, Alex Elder wrote:
> > On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > > This is my current patch queue for Linux 3.1.  Compared to the last
> > > posting all review comments were incorporated and two additional trivial
> > > patches were added.  The ->writepages implementation was dropped for now,
> > > given the bad situation of kswap-originating writeback, but I'll repost
> > > the fixed version separately to get feedback on the updated version.
> > 
> > I mentioned a bunch of fairly minor issues with
> > this series; I don't believe I found anything
> > that was actually incorrect.  Quite a few of
> > them consist of small but good cleanups.
> > 
> > I'll give you a chance to re-post them (or
> > point me at a repository to pull from).  At
> > this point I trust you'll do the right thing
> > so I'm ready to use what you give me.
> > 
> > For now I'm testing overnight with this
> > latest version of the patches.
> 
> I'll redo the series after going through your and Daves comments.

No unexpected errors overnight.  I'm going to try
to fit Dave's for-3.0 patch(es) in before committing
these, but whenever you've got your updates done (today
preferably) I'll take them.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
