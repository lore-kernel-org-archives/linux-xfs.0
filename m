Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756235AbeFOVwB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 17:52:01 -0400
Date: Fri, 15 Jun 2018 23:52:00 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] libxfs: detect zoned disks and prevent their raw use
Message-ID: <20180615215200.GR5527@wotan.suse.de>
References: <20180615205011.7728-1-mcgrof@kernel.org>
 <5fbcde14-fdb8-9a4f-e578-4ad7c4ef6315@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fbcde14-fdb8-9a4f-e578-4ad7c4ef6315@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, snitzer@redhat.com, hare@suse.de, axboe@kernel.dk, mwilck@suse.com, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

On Fri, Jun 15, 2018 at 04:48:29PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/15/18 3:50 PM, Luis R. Rodriguez wrote:
> > +	if (ret == 1) {
> > +		fprintf(stderr,
> > +_("%s: zoned disk detected, refer to dm-zoned-tools for how to use with XFS\n"),
> > +			path);
> > +		exit(1);
> 
> Sorry for not sending this before V2, but is "dm-zoned-tools" established enough
> in the ecosystem at this point to embed it in help text of utilities like this?
> 
> (It's not in debian or in fedora, so that message might lead to some head-scratching,
> I think)

It *should*, I'll help up clean that project up a bit now with some meta crap which
Debian police may want, but yeah not sure. You're call. Whatever you wish to
print I'm fine with.

AFAICT dmzadm *should* be packaged at least. Long term perhaps lvm2 may re-implement
it, but I can't see why folks should wait for such lofty vaporware.

  Luis
