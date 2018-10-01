Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeJAXrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:47:14 -0400
Date: Mon, 1 Oct 2018 10:08:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub_all warning
Message-ID: <20181001170823.GA5883@magnolia>
References: <974f65da-60f9-55aa-2e27-3fe9abb64f97@bodenbinder.de>
 <20180831164535.GA4355@magnolia>
 <14ac54ca-4f2d-c3a2-9157-93ae7e274f47@bodenbinder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14ac54ca-4f2d-c3a2-9157-93ae7e274f47@bodenbinder.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthias Bodenbinder <matthias@bodenbinder.de>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sat, Sep 01, 2018 at 12:45:54PM +0200, Matthias Bodenbinder wrote:
> Am 31.08.18 um 18:45 schrieb Darrick J. Wong:
> > I think so.  If you remove the lines:
> > 
> > 	if '-' not in path:
> > 		return path
> > 
> > from systemd_escape() in /sbin/xfs_scrub_all, do the warnings go away?
> > Does scrub still work afterwards?
> 
> That does work:
>  
> 8# ./my-xfs_scrub_all
> Scrubbing /home...
> Failed to add filter for units: No data available
> Scrubbing /home done, (err=0)
> 
> 
> But what is this "Failed to add filter..." message about?

I /think/ that's journalctl failing to construct a filter for
'xfs_scrub@*' to display whatever output comes out of running the
xfs_scrub jobs.  I'll look further into it, but for now I've posted the
fix to xfs_scrub_all to shut up the escaping complaints.

--D

> Thanks for your help
> Matthias
> 
