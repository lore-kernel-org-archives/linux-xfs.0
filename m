Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbdDCVFT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 17:05:19 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170403163910.GD10881@birch.djwong.org>
References: <20170403163910.GD10881@birch.djwong.org> <149122078093.24821.17192375733082382807.stgit@warthog.procyon.org.uk> <149122081486.24821.15266397607503484126.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #3]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9633.1491253516.1@warthog.procyon.org.uk>
Date: Mon, 03 Apr 2017 22:05:16 +0100
Message-ID: <9634.1491253516@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> > +# We can turn on and off append (a), compressed (c), immutable (i) and
> > +# no-dump (d)
> > +for a in +a -a
> > +do
> > +    for c in +c -c
> 
> Does this test fail for any fs that doesn't support compressed files?
> 
> If so, perhaps there should be separate tests for each of the 4 attrs.

They should also be tested in combination.  Hmmm...

David
