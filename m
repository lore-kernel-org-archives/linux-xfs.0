Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfCOC7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 22:59:35 -0400
Date: Thu, 14 Mar 2019 19:59:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/36] xfs_scrub_all.timer: activate after most of the
 system is up
Message-ID: <20190315025931.GE4929@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259749738.31886.13894651790702916465.stgit@magnolia>
 <944e572a-dd6c-8cc2-d7e9-2a97f492191b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <944e572a-dd6c-8cc2-d7e9-2a97f492191b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:56:35PM -0500, Eric Sandeen wrote:
> 
> 
> On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We really don't want the xfs_scrub_all timer triggering while the system
> > is booting up because not all the mounts will have finished, networking
> > might not be up for reporting, and slowing down bootup annoys people.
> > Therefore, delay the xfs_scrub_all service's activation until after the
> > system has started all the big pieces it's going to start.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> <mumble handwave systemd mumble>
> 
> what happens if you state an After requirement for something that doesn't
> exist on the box?  Is it just ignored?

Yes, it's ignored, like everything else systemd's service file parser
doesn't understand FBOFW.

--D

> (he asks, after looking for what connman.service is and finds that it's not
> ubiquitous ...)
> 
> > ---
> >  scrub/xfs_scrub_all.service.in |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
> > index 66f82fc7..b1b80da4 100644
> > --- a/scrub/xfs_scrub_all.service.in
> > +++ b/scrub/xfs_scrub_all.service.in
> > @@ -2,6 +2,7 @@
> >  Description=Online XFS Metadata Check for All Filesystems
> >  ConditionACPower=true
> >  Documentation=man:xfs_scrub_all(8)
> > +After=paths.target multi-user.target network.target network-online.target systemd-networkd.service NetworkManager.service connman.service
> >  
> >  [Service]
> >  Type=oneshot
> > 
