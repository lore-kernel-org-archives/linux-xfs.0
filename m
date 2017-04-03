Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbdDCVRJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 17:17:09 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <9634.1491253516@warthog.procyon.org.uk>
References: <9634.1491253516@warthog.procyon.org.uk> <20170403163910.GD10881@birch.djwong.org> <149122078093.24821.17192375733082382807.stgit@warthog.procyon.org.uk> <149122081486.24821.15266397607503484126.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #3]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9782.1491254227.1@warthog.procyon.org.uk>
Date: Mon, 03 Apr 2017 22:17:07 +0100
Message-ID: <9783.1491254227@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> ...
> > If so, perhaps there should be separate tests for each of the 4 attrs.
>
> They should also be tested in combination.  Hmmm...

Hmmm...  It appears that that would require 16 separate test files, each with
the appropriate combination of "_require_chattr <letter>".

David
