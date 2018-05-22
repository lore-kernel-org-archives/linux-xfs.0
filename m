Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbeEVGlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 02:41:21 -0400
Date: Mon, 21 May 2018 23:41:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Message-ID: <20180522064118.GA18704@infradead.org>
References: <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
 <20180521173724.GG11495@kmo-pixel>
 <20180521182427.GA20013@redhat.com>
 <20180521233855.GI11495@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521233855.GI11495@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Mon, May 21, 2018 at 07:38:55PM -0400, Kent Overstreet wrote:
> On Mon, May 21, 2018 at 02:24:32PM -0400, Mike Snitzer wrote:
> > Every single data structure change in this series should be reviewed for
> > unforeseen alignment consequences.  Jens seemed to say that is
> > worthwhile.  Not sure if he'll do it or we divide it up.  If we divide
> > it up a temp topic branch should be published for others to inspect.
> > 
> > Could be alignment hasn't been a historic concern for a bunch of the
> > data structures changed in this series.. if so then all we can do is fix
> > up any obvious potential for false sharing.
> 
> Honestly, I almost never worry about alignment... the very few times I do care,
> I use __cacheline_aligned_in_smp.

And that generally is the right stratgey.  If Mike really doesn't want
a change we can just open code the kmalloc for the bio set there, the
important point is that we should not keep the old API around for no
good reason.
