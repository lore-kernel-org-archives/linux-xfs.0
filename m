Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfCZVV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 17:21:27 -0400
Date: Tue, 26 Mar 2019 14:21:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/36] xfs_repair: fix uninitialized variable warnings
Message-ID: <20190326212120.GY1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259758358.31886.2042156413647033104.stgit@magnolia>
 <86dce7d4-e637-8a94-e210-cdc804c6f0dc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86dce7d4-e637-8a94-e210-cdc804c6f0dc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:56:02PM -0500, Eric Sandeen wrote:
> On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix some uninitialized variable warnings because ASSERT disappears if
> > DEBUG is not defined.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fixes: commit 5857dce9e ("xfs_repair: check and repair quota metadata")
> 
> which was mine ;)
> 
> But, I wonder if we should really just happily carry on w/ an invalid
> quota type 0 on a non-debug build.  I don't know how that will end.
> 
> Maybe we should just switch it to a hard assert(0) because it really
> can only happen on a programming error today.

Yeah, we ought to be more defensive about that, since in theory we could
introduce a subtle bug some day where we validate a corrupt dquot with
flags == 0.

/me kinda wonders why we define away the asserts for repair, since it's
not like continuing under invalid premises in a repair tool is a good
idea.

--D

> 
> > ---
> >  repair/dinode.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index f670bf87..c0a56daa 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -1176,8 +1176,8 @@ process_quota_inode(
> >  	struct xfs_buf		*bp;
> >  	xfs_filblks_t		dqchunklen;
> >  	uint			dqperchunk;
> > -	int			quota_type;
> > -	char			*quota_string;
> > +	int			quota_type = 0;
> > +	char			*quota_string = NULL;
> >  	xfs_dqid_t		dqid;
> >  	xfs_fileoff_t		qbno;
> >  	int			i;
> > 
