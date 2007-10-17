Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 14:09:03 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HL8t6X014530
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 14:08:58 -0700
Date: Wed, 17 Oct 2007 13:50:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc1
Message-Id: <20071017135034.0f8cc3bf.akpm@linux-foundation.org>
In-Reply-To: <20071017203658.GA22073@infradead.org>
References: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
	<20071017203658.GA22073@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: tes@sgi.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 17 Oct 2007 21:36:58 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Oct 17, 2007 at 09:03:39PM +1000, Tim Shimmin wrote:
> > Hi Linus,
> > 
> > Please pull from the for-linus branch:
> >     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> > 
> > These include changes we have had scheduled for 2.6.24.
> > In particular they include Christoph's (hch's) behavior removal patches.
> 
> Can you please send my '[PATCH] cleanup fid types mess' to Linus aswell?
> I have a stack of 15 patches reworking the nfs exporting code waiting
> in -mm to get in in this merge window that depend on this cleanup to
> free struct fid for generic useage.
> 
> Also getting the makefile cleanup into mainline to reduce spurious difference
> would help a lot.

argh, -mm's *new-export*.patch has a dependency upon git-xfs's
ef6567a363c5f301c0bc885068d93cd9b3c05cc9.  I never knew that, but I would
have found out later today...

Tim, if you want I can just steal that diff out of the xfs tree and send it
in separately.
