Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36786 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934198AbeFLWKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:10:30 -0400
Date: Tue, 12 Jun 2018 15:10:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] mkfs: move mkfs.xfs.8 to an .in file
Message-ID: <20180612221027.GO22045@magnolia>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-3-git-send-email-sandeen@sandeen.net>
 <c48879de-0704-8da8-da35-7b5a10fd0339@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c48879de-0704-8da8-da35-7b5a10fd0339@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 12, 2018 at 02:45:40PM -0500, Eric Sandeen wrote:
> On 6/12/18 2:31 PM, Eric Sandeen wrote:
> > Simple move with no changes, next patch will parameterize @sysconfdir@
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> > ---
> >  man/man8/Makefile      |    8 +-

/me thinks this ought to go in the next patch, since that's where the
parameterization gets used.

> >  man/man8/mkfs.xfs.8    | 1015 ------------------------------------------------
> >  man/man8/mkfs.xfs.8.in | 1015 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1022 insertions(+), 1016 deletions(-)
> >  delete mode 100644 man/man8/mkfs.xfs.8
> >  create mode 100644 man/man8/mkfs.xfs.8.in
> 
> Well crud the point of mv-with-no-changes was to make git detect the
> rename :/

Works for me, at least I don't have to go dig out your changes. :)

With that one thing moved,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
