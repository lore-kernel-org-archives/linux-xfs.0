Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37210 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbeEUXjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 19:39:00 -0400
Date: Mon, 21 May 2018 19:38:55 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Message-ID: <20180521233855.GI11495@kmo-pixel>
References: <2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
 <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
 <20180521173724.GG11495@kmo-pixel>
 <20180521182427.GA20013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521182427.GA20013@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On Mon, May 21, 2018 at 02:24:32PM -0400, Mike Snitzer wrote:
> Every single data structure change in this series should be reviewed for
> unforeseen alignment consequences.  Jens seemed to say that is
> worthwhile.  Not sure if he'll do it or we divide it up.  If we divide
> it up a temp topic branch should be published for others to inspect.
> 
> Could be alignment hasn't been a historic concern for a bunch of the
> data structures changed in this series.. if so then all we can do is fix
> up any obvious potential for false sharing.

Honestly, I almost never worry about alignment... the very few times I do care,
I use __cacheline_aligned_in_smp.

If alignment is a concern in any of those structs, there really ought to be a
comment indicating it. I very much doubt anything I touched was performance
sensitive enough for it to be an issue, though. And if there is a performance
impact, it should be oughtweighed by the reduced pointer chasing.

If you disagree, I don't mind leaving the device mapper patch out, it really
makes no difference to me. I could glance over for alignment issues but I feel
like my analysis would not be terribly valuable to you considering I've already
said my position on alignment is "meh, don't care" :)
