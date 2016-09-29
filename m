Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45429 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755310AbcI2TqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 15:46:11 -0400
Date: Thu, 29 Sep 2016 12:45:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 45/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20160929194536.GB14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503150585.30303.6967077248029323904.stgit@birch.djwong.org>
 <20160929170759.GJ4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929170759.GJ4546@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Sep 29, 2016 at 10:07:59AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 07:58:25PM -0700, Darrick J. Wong wrote:
> > Now that we have an fallocate flag to unshare a range of blocks, make
> > XFS actually implement it.
> 
> There is [no] unshared flag in here.

Drat!  I totally forgot to add the unshare flag back in!  We even had
a whole email thread about this months ago. :( :(

Ok, I'll put in a flag.

> Instead it performs an unshare without passing any flag, which will break
> existing users of fallocate like the NFS server.

> > v2: NFS doesn't pass around struct file pointers, which means that our
> > unshare functions all crash when filp == NULL.  We don't need filp
> > anyway, so remove all the parts where we pass filp around.
> 
> NFSD passes a file pointer just fine.  Note that it really should
> matter, but this comment confused me.

Yeah, it confused me as well, so I'll just go back to your original
changelog message.

--D
