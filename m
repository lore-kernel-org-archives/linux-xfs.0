Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbeLRUbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:31:14 -0500
Date: Tue, 18 Dec 2018 12:31:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: stringify scrub types in ftrace output
Message-ID: <20181218203108.GJ27208@magnolia>
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344776951.4341.14323367177195315854.stgit@magnolia>
 <32a11dec-500d-1b18-49fa-86aa8c45f0f7@sandeen.net>
 <20181218184141.GE27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218184141.GE27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 10:41:41AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 18, 2018 at 11:30:16AM -0600, Eric Sandeen wrote:
> > On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Use __print_symbolic to print the scrub type in ftrace output.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/trace.h |  103 +++++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 77 insertions(+), 26 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > > index 0141eb1ac091..3c83e8b3b39c 100644
> > > --- a/fs/xfs/scrub/trace.h
> > > +++ b/fs/xfs/scrub/trace.h
> > > @@ -26,6 +26,57 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
> > >  TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
> > >  TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
> > >  
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PROBE);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SB);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGF);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGFL);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGI);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BNOBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_CNTBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INOBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FINOBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RMAPBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_REFCNTBT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INODE);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTD);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTA);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTC);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIR);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_XATTR);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SYMLINK);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PARENT);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTBITMAP);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTSUM);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
> > > +
> > > +#define XFS_SCRUB_TYPE_STRINGS \
> > 
> > Hm I thought you just moved these sorts of #defines /out/ of the trace files
> > and adjacent to their type definitions in core header files; why not this one?

Forgot to answer the original question: Because I really don't want
ftrace stringification junk ending up in the xfs_fs.h that we ship in
xfslibs-dev.

> [paraphrasing a conversation on irc]
> 
> So I'm becoming more convinced that these stringify things should all
> just move to xfs_trace.h and scrub/trace.h.  The /only/ users are the
> tracepoints, but (according to Dave, I think?) the reason for putting
> them next to the enum definition is so that we don't forget to update
> the string list when we update the enums.
> 
> However, now that we know we have to maintain this TRACE_DEFINE_ENUM
> hugpile (and it has to be in the trace header file) we might as well
> move the stringify crap to the trace headers and leave a comment in
> xfs_format.h.

Unfortunately... this also means we can't share the stringifier between
xfs and xfs_scrub's tracepoints.  Soooo ... I think I'm going to leave
things as they are here and get on with other things.

(Not thrilled to have spent three hours analyzing where to put stringify
macros, tbh...)

--D

> --D
> 
> > > +	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
> > > +	{ XFS_SCRUB_TYPE_SB,		"sb" }, \
> > > +	{ XFS_SCRUB_TYPE_AGF,		"agf" }, \
> > > +	{ XFS_SCRUB_TYPE_AGFL,		"agfl" }, \
> > > +	{ XFS_SCRUB_TYPE_AGI,		"agi" }, \
> > > +	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
> > 
> > -Eric
