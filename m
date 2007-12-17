Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 23:14:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH7ER7t004104
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 23:14:31 -0800
Date: Mon, 17 Dec 2007 07:14:27 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20071217071426.GA11462@infradead.org>
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765F444.8010705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>, gnb@sgi.com

On Mon, Dec 17, 2007 at 03:00:04PM +1100, Lachlan McIlroy wrote:
> Hey hold on there buddy!  We may need to reactivate this code to fix some
> performance issues.  I've acttually got this code working and proven that
> it is one way to fix some of the NAS/NFS issues we have.
>
> The little comment that reads "reference cache not needed for NFS in 2.6"
> is wrong - we do need it or something like it.

Not in XFS, though.  This thing needs to be done genericly in NFSD.
Greg has been working on an open files cache in nfsd which should be
helping this.

Adding a cache like this back into XFS will get my veto (at least for
mainline where I have a bit of a say :))
