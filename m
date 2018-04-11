Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57384 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbeDKBuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 21:50:03 -0400
Date: Tue, 10 Apr 2018 18:49:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/14] xfs_scrub: disable private /tmp for scrub service
Message-ID: <20180411014953.GV7500@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160365430.8288.18072489901853791592.stgit@magnolia>
 <de647355-57bd-75e5-d10c-22dc99cb20c0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de647355-57bd-75e5-d10c-22dc99cb20c0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Apr 10, 2018 at 08:45:23PM -0500, Eric Sandeen wrote:
> 
> 
> On 3/20/18 10:40 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't make /tmp private when invoking xfs_scrub as a service, because
> > /tmp might contain or itself be an xfs filesystem mountpoint.
> 
> Could you please add a comment to this so that future security analysts
> don't change it back?  :)

# Disable private /tmp just in case %i is a path under /tmp.

--D

> # xfs_scrub doesn't even use /tmp but <this is why we do this here>
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/xfs_scrub@.service.in |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
> > index c14f813..9e6206a 100644
> > --- a/scrub/xfs_scrub@.service.in
> > +++ b/scrub/xfs_scrub@.service.in
> > @@ -9,7 +9,7 @@ WorkingDirectory=%I
> >  PrivateNetwork=true
> >  ProtectSystem=full
> >  ProtectHome=read-only
> > -PrivateTmp=yes
> > +PrivateTmp=no
> >  AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
> >  NoNewPrivileges=yes
> >  User=nobody
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
