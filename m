Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42115 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966514AbeFSQoB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:44:01 -0400
Date: Tue, 19 Jun 2018 18:53:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/24] xfs: remove xfs_map_cow
Message-ID: <20180619165303.GB18348@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-12-hch@lst.de> <20180618173837.GA40796@bfoster> <20180619053537.GT8128@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619053537.GT8128@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jun 18, 2018 at 10:35:37PM -0700, Darrick J. Wong wrote:
> > A comment would be nice here just so the purpose of the logic is clear
> > at a glance. E.g:
> > 
> >                 /*
> >                  * COW fork blocks can overlap data fork blocks even if the
> >                  * blocks aren't shared. COW I/O always takes precedent, so we
> >                  * must always check for overlap on reflink inodes unless the
> >                  * mapping is already COW.
> >                  */
> > 
> > With something like that, this now looks pretty good to me:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I concur, it would help to have a comment to remind everyone that we
> sometimes upgrade to a cow write even when it's not strictly required.
> :)
> 
> With that comment added in,

Do you just want to throw it after the series?  Or should I or Brian
resend it on top of the series?
