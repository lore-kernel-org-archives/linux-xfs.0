Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727475AbeKNClc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 21:41:32 -0500
Date: Tue, 13 Nov 2018 08:42:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] xfs: save buffer offset when verifiers fail
Message-ID: <20181113164232.GH4235@magnolia>
References: <f2695097-0728-e525-43a5-d9f183ecba3e@sandeen.net>
 <20181107192900.GB50224@bfoster>
 <b976998f-d1a9-e8d5-e9d2-41ec730fd8e5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b976998f-d1a9-e8d5-e9d2-41ec730fd8e5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 07, 2018 at 01:59:39PM -0600, Eric Sandeen wrote:
> On 11/7/18 1:29 PM, Brian Foster wrote:
> > On Wed, Nov 07, 2018 at 11:49:31AM -0600, Eric Sandeen wrote:
> >> I'd like to propose an addition to our current metadata verifier error reporting that I believe will allow us to more quickly identify, and more efficiently classify, metadata validation errors when they occur.
> ...
> 
> >> 3) It would allow us to ensure that the hexdump actually contains the
> >>    region where the corruption was discovered.
> >>
> > 
> > Yep, though I still think the "first 64 bytes" or whatever of a
> > particular buffer is useful to help establish sanity (i.e., is the magic
> > sane? is the whole buffer zeroed out? etc.).
> 
> Yeah I think we should always print the beginning as well.
>  
> ...
> 
>  
> > Did we consider some kind of error context structure in the past? I
> > don't recall if there were unrelated issues with that, but that seems
> > slightly more elegant than an xfs_buf field. Otherwise, the high level
> > approach seems reasonable.
> 
> Darrick made the same suggestion, and it's a good one thanks.
> 
> ...
> 
> >> We /could/ even go so far as to macrify tests like this, and do:
> >>
> >>         XFS_VALIDATE_EQ(agf, agf_magicnum, XFS_AGF_MAGIC);
> >>         if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
> >>                 XFS_VERIFIER_FAIL_RETURN(struct xfs_agf, agf_versionnum);
> >>         XFS_VALIDATE_EQ(agf, agf_versionnum, XFS_AGF_VERSION);
> >>         ...
> >>
> > 
> > This one makes my eyes cross a bit. ;) Though I think it's because now I
> > have to wonder a bit about what each macro does. I wouldn't be against
> > something like this if we could condense it into something more generic
> > and straightforward. For example:
> > 
> > 	XFS_VERIFY(agf->agf_magicnum == XFS_AGF_MAGIC,
> > 		   offsetof(struct xfs_agf, agf_magicnum));
> > 	XFS_VERIFY(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)),
> > 		   offsetof(struct xfs_agf, agf_versionnum));
> > 	...
> > 
> > I guess you'd need to stick the buffer or whatever stores the bad offset
> > value in there somewhere as well, but seeing the explicit logic makes
> > this easier to read than following it into a macro. Just my .02.
> 
> hah, yeah, that's much better.  Thanks.

<nod> To reiterate a conversation we had on IRC:

I tried the "one giant macro to test, record error state, and return"
strategy for xfs_scrub and was shot down hiding control flow in
something that looks like a "regular" function call.  TBH I wouldn't
necessarily be able to tell that XFS_VERIFY() actually *returns* from
the function just by looking at the call sites.

So what I propose instead is something sort of like what I did for
scrub.  In some header file you have:

static inline xfs_failaddr_t
xfs_buf_record_error(
	struct xfs_buf		*bp,
	unsigned int		offset,
	xfs_failaddr_t		fa,
	int			error)
{
	bp->b_bad_offset = offset;
	bp->b_error = error;
	return fa;
}

and then in xfs_alloc.c you have:

static xfs_failaddr_t
xfs_agf_verify(
	struct xfs_buf	*bp)
{
	struct xfs_agf	*agfp = XFS_BUF_TO_AGF(bp);

#define XFS_AGF_CORRUPT(bp, field) \
	xfs_buf_record_error((bp), offsetof(struct xfs_agf, (field)), \
			__this_address, -EFSCORRUPTED)

	if (agf->agf_magicnum != cpu_to_be32(XFS_AGF_MAGIC))
		return XFS_AGF_CORRUPT(bp, agf_magicnum);

	if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
		return XFS_AGF_CORRUPT(bp, agf_versionnum);
	...

#undef XFS_AGFL_ERROR
}

--D

> -Eric
