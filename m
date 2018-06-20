Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33198 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbeFTAhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 20:37:55 -0400
Date: Tue, 19 Jun 2018 17:37:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/24] xfs: remove xfs_map_cow
Message-ID: <20180620003736.GE9426@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-12-hch@lst.de>
 <20180618173837.GA40796@bfoster>
 <20180619053537.GT8128@magnolia>
 <20180619165303.GB18348@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619165303.GB18348@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 19, 2018 at 06:53:03PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 18, 2018 at 10:35:37PM -0700, Darrick J. Wong wrote:
> > > A comment would be nice here just so the purpose of the logic is clear
> > > at a glance. E.g:
> > > 
> > >                 /*
> > >                  * COW fork blocks can overlap data fork blocks even if the
> > >                  * blocks aren't shared. COW I/O always takes precedent, so we
> > >                  * must always check for overlap on reflink inodes unless the
> > >                  * mapping is already COW.
> > >                  */
> > > 
> > > With something like that, this now looks pretty good to me:
> > > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > I concur, it would help to have a comment to remind everyone that we
> > sometimes upgrade to a cow write even when it's not strictly required.
> > :)
> > 
> > With that comment added in,
> 
> Do you just want to throw it after the series?  Or should I or Brian
> resend it on top of the series?

I just stuck it in the patch and had it follow the code in the
subsequent reorganizations.  Testing is running now...

--D
