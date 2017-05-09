Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46902 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbdEIVS7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 17:18:59 -0400
Date: Tue, 9 May 2017 23:18:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove XFS_HSIZE
Message-ID: <20170509211857.GA2295@lst.de>
References: <20170509090018.30094-1-hch@lst.de> <ba048d82-a8b9-863f-121e-a1319fdef0f3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba048d82-a8b9-863f-121e-a1319fdef0f3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, May 09, 2017 at 10:40:31AM -0500, Eric Sandeen wrote:
> > -
> > -		hsize = XFS_HSIZE(handle);
> > +		hsize = sizeof(xfs_handle_t);
> 
> at this point, no need to have the hsize assignment in if { } as well as else { }, right?
> 

In the other branch hsize is smaller, it only covers the fsid.
