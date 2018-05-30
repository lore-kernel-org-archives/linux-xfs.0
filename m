Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932191AbeE3ThJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 15:37:09 -0400
Date: Wed, 30 May 2018 15:37:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Message-ID: <20180530193707.GB6568@redhat.com>
References: <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
 <f9e3714c-b7c9-d5f6-4018-2a87dd5babb2@kernel.dk>
 <20180530133629.GC5157@redhat.com>
 <f654ad69-aa90-9580-4731-a05d0604f353@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f654ad69-aa90-9580-4731-a05d0604f353@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Wed, May 30 2018 at  2:55pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 5/30/18 7:36 AM, Mike Snitzer wrote:
> > So revisiting this patchset: are you inclined to take these changes (I
> > assume yes)?  If so, what would you need in order to get them staged for
> > 4.18?  I'll start with offering my review in reply to the DM patch.  I'd
> > much prefer to see this level of change go in sooner rather than later.
> 
> Yeah I'd like to take the changes, but we might have to wait for
> 4.19 at this point. It'd certainly help to have the dm bits reviewed,
> as they are some of the larger ones. The grunt of the others are mostly
> trivial and smaller in scope.

I _really_ would like to see this land for 4.18.  It'll avoid downstream
backport problems (due to all the churn in this patchset).

As I'm sure you've seen I reviewed and Acked-by the DM patch.

I mentioned I've been chatting with Kent, he is available if anything
needs a v2 for whatever reason.

Would you be OK adding a single sentence description to each driver's
patch header (rather than leaving empty like how Kent submitted)?  Or
should Kent resubmit the entire set with that boilerplate header for
each patch?
