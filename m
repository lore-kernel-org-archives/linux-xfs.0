Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEOOlq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 10:41:46 -0400
Date: Wed, 15 May 2019 10:41:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190515144144.GD2898@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
 <20190510172446.GA18992@infradead.org>
 <20190513154433.GD61135@bfoster>
 <20190515075253.GG29211@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515075253.GG29211@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 12:52:53AM -0700, Christoph Hellwig wrote:
> On Mon, May 13, 2019 at 11:44:34AM -0400, Brian Foster wrote:
> > The only functional change was basically to check for ccur before using
> > it and initializing i to zero. It just seemed to make sense to clean up
> > the surrounding code while there, but I can either split out the
> > aesthetic cleanup or defer that stuff to the broader rework at the end
> > of the series (where the cursor stuff just gets ripped out anyways) if
> > either of those is cleaner..
> 
> Yeah, I noticed how trivial the actual change was.  That is why just
> doing the cleanup in pass 1 and applying the change in pass 2 might
> make it more readbale.  It might also be worth to throw in the use
> a goto label instead of long conditionals from your last patch into
> that cleanup prep patch.

Ok, I've lifted all of the small mode refactoring (from both this patch
and the last one) into an initial patch. Unless you indicate otherwise,
I've also retained your review tag(s), though you might want to take a
cursory look once the next version lands.

Brian
