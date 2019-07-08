Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34715 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388273AbfGHQDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 12:03:54 -0400
Date: Mon, 8 Jul 2019 18:03:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: RFC: use the iomap writepage path in gfs2
Message-ID: <20190708160351.GA9871@lst.de>
References: <20190701215439.19162-1-hch@lst.de> <CAHc6FU5MHCdXENW_Y++hO_qhtCh4XtAHYOaTLzk+1KU=JNpPww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU5MHCdXENW_Y++hO_qhtCh4XtAHYOaTLzk+1KU=JNpPww@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>

On Thu, Jul 04, 2019 at 12:35:41AM +0200, Andreas Gruenbacher wrote:
> Patch "gfs2: implement gfs2_block_zero_range using iomap_zero_range"
> isn't quite ready: the gfs2 iomap operations don't handle IOMAP_ZERO
> correctly so far, and that needs to be fixed first.

What is the issue with IOMAP_ZERO on gfs2?  Zeroing never does block
allocations except when on COW extents, which gfs2 doesn't support,
so there shouldn't really be any need for additional handling.

> Some of the tests assume that the filesystem supports unwritten
> extents, trusted xattrs, the usrquota / grpquota / prjquota mount
> options. There shouldn't be a huge number of failing tests beyond
> that, but I know things aren't perfect.

In general xfstests is supposed to have tests for that and not run
the tests if not supported.  In most cases this is automatic, but
in case a feature can't be autodetect we have a few manual overrides.
