Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42112 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966676AbeFSQnF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:43:05 -0400
Date: Tue, 19 Jun 2018 18:52:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/24] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180619165207.GA18348@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-14-hch@lst.de> <20180619054325.GV8128@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619054325.GV8128@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Mon, Jun 18, 2018 at 10:43:25PM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * Walk the blocks on the page, and we we run off then end of the
> > +	 * current map or find the current map invalid, grab a new one.
> 
> Will rework this comment to read:
> 
> "...and if we run off the end of the current map or..."

Ok.
