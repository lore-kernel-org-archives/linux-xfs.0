Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38420 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752465AbeFFPci (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Jun 2018 11:32:38 -0400
Date: Wed, 6 Jun 2018 17:39:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap preparations for GFS2
Message-ID: <20180606153955.GA24356@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <CAHc6FU458f9xkr2ru2B2L8_FC+=vm5CLDUixBjCZSq5YZZC8=w@mail.gmail.com> <CAHpGcMJC01-RVceZajprnLtFP7JS+SrUJ+N_RESgGJyAkj=KJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcMJC01-RVceZajprnLtFP7JS+SrUJ+N_RESgGJyAkj=KJA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On Wed, Jun 06, 2018 at 05:31:25PM +0200, Andreas Grünbacher wrote:
> 2018-06-06 13:38 GMT+02:00 Andreas Gruenbacher <agruenba@redhat.com>:
> > On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
> >> Hi all,
> >>
> >> this is a slight rework of the patches from Andreas to prepare for gfs2
> >> using the iomap code.  I'd like to start with an immutable branch for
> >> iomap patches in either the XFS tree or a tree of mine own with something
> >> like this so that we can have a nice common base for both the major
> >> iomap changes for XFS and the GFS2 work.
> 
> When do you want to push this upstream? We've got the gfs2 patches
> that depend on it, and we cannot make progress with those before this
> set is pushed.

As soon as we have 4.18r-c1 can start work for the next merge
window.
