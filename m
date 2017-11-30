Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20658 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdK3VLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 16:11:40 -0500
Date: Thu, 30 Nov 2017 13:11:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 17/17] Add parent pointer ioctl
Message-ID: <20171130211134.GK21412@magnolia>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-18-git-send-email-allison.henderson@oracle.com>
 <20171128203537.GZ21412@magnolia>
 <20171129213746.GK5858@dastard>
 <3865fc6e-b496-0581-b9d4-7427fa69c825@oracle.com>
 <20171130000251.GL5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130000251.GL5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 11:02:51AM +1100, Dave Chinner wrote:
> On Wed, Nov 29, 2017 at 03:48:50PM -0700, Allison Henderson wrote:
> > 
> > 
> > On 11/29/2017 02:37 PM, Dave Chinner wrote:
> > >On Tue, Nov 28, 2017 at 12:35:37PM -0800, Darrick J. Wong wrote:
> > >>On Fri, Nov 17, 2017 at 11:21:45AM -0700, Allison Henderson wrote:
> > >>>This patch adds a new file ioctl to retrieve the parent
> > >>>pointer of a given inode
> > >>
> > >>(Yes, it's time to start talking about actual use cases...)
> > >>
> > >>At a bare minimum, this is what I pictured for the "return parents of
> > >>the open file" ioctl:
> > >>
> > >>#define XFS_PPTR_MAXNAMELEN		255
> > >>
> > >>struct xfs_pptr {
> > >>	u64				pp_ino;
> > >>	u32				pp_gen;
> > >>	u8				pp_namelen;
> > >>	u8				pp_name[XFS_PPTR_MAXNAMELEN];
> > >>};
> > >
> > >That's going to be a different size on 32bit and 64 bit platforms
> > >as the structure size is a multiple of 4 bytes, not 8 bytes.
> > >That will cause problems and need complex comapt ioctl translation.
> > >Better to make pp_namelen a u32 and that will make the structure
> > >64 bit aligned and sized on all platforms.
> > >
> > >I'd allow more than u8 for the namelen. Yes, while we currently
> > >allow on 255 bytes for a name, it would make more sense to
> > >use a u32 here so that the structure size is a multiple of it's
> > >alignment rather than having a 4 byte hole in the array we don't
> > >fill out....

Maybe this ought to get padded up to the nearest 8-byte boundary too.

> > >
> > >>
> > >>/* return parents of the handle, instead of the open fd */
> > >>#define XFS_PPTR_FLAG_HANDLE		(1u << 0)
> > >>
> > >>struct xfs_pptr_info {
> > >>	struct xfs_fsop_handlereq	pi_handle;
> > >>	struct xfs_attrlist_cursor	pi_cursor;
> > >>	u32				pi_flags;
> > >>	u32				pi_reserved;
> > >>	u32				pi_ptrs_size;
> > >>	u32				pi_ptrs_used;
> > >>	u64				pi_reserved2[6];
> > >>	struct xfs_pptr			pi_ptrs[0];
> > >>};
> > >
> > >I thought gcc had started doing weird things with variable size
> > >array declarations like this (i.e. pi_ptrs[0]) because the exact
> > >behaviour is not defined in the C standard. i.e. we need to avoid
> > >adding new declarations that do this...
> > 
> > Oh, I think there's a few places in the set where I have
> > declarations like that.
> 
> Yup, there are quite a few, but IIRC we can't rely on them working
> as they do right now in future compilers. So I'm pretty sure we need
> to avoid these sorts of constructs if we can. Doing something like
> this:

If gcc starts bungling them, there's going to be a lot of stuff in
include/uapi/ that breaks.  FIEMAP, FSMAP, the weird vfs dedupe ioctl...

I think it'll be fine so long as we keep an eye on the structure size
in xfs_ondisk.h.  If the structure size mutates we'll know because the
ioctl will stop working with old userspace and/or we fail the build.

Oh but we don't keep an eye on that stuff.  Sigh.

> struct xfs_pptr_info {
> 	struct xfs_fsop_handlereq	pi_handle;
> 	struct xfs_attrlist_cursor	pi_cursor;
> 	u32				pi_flags;
> 	u32				pi_reserved;
> 	u32				pi_ptrs_size;
> 	u32				pi_ptrs_used;
> 	u64				pi_reserved2[6];
> 
> 	/*
> 	 * An array of struct xfs_pptr follows the header
> 	 * information. Use XFS_PPINFO_TO_PP() to access the
> 	 * parent pointer array entries.
> 	 */
> };
> 
> And providing an accessor function:
> 
> #define XFS_PPINFO_TO_PP(info, idx)	\
> 	(&(((struct xfs_pptr *)((char *)(info) + sizeof(*(info))))[(idx)]))

Eww, macros. :)

static inline struct xfs_pptr *
xfs_ppinfo_to_pp(
	struct xfs_pptr_info	*info,
	unsigned int		idx)
{
	return (struct xfs_pptr *)((char *)(info + 1)) + (idx * sizeof(struct xfs_pptr));
}

> Will solve the problem.
> 
> > Should they be some_array[1]; instead?
> 
> That has problems, too. See, for example, commit ffeecc521302 ("xfs:
> Fix xfs_attr_leafblock definition"), where gcc completely mangled
> the code because it thought it could optimise away bits of the
> structure and code that "weren't used".

Especially no on the some_array[1], that bit us with the v5 AGFL...

> > >>#define XFS_PPTR_INFO_SIZEOF(ptrs)	(sizeof(struct xfs_pptr_info) + \
> > >>					((ptrs) * sizeof(struct xfs_pptr)));
> > >>static inline struct xfs_pptr_info *
> > >>xfs_pptr_alloc(
> > >>	size_t			nr_ptrs)
> > >>{
> > >>	struct xfs_pptr_info	*ppi;
> > >>
> > >>	ppi = malloc(XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> > >>	if (!ppi)
> > >>		return NULL;
> > >>	memset(ppi, 0, XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> > >>	ppi->pi_ptrs_size = nr_ptrs;
> > >>	return ppi;
> > >>}
> > >>
> > >>With the following example userspace program (that does no checking
> > >>whatsoever):
> > >>
> > >>int main(int argc, char *argv[])
> > >>{
> > >>	struct xfs_pptr_info	*ppi;
> > >>	struct xfs_pptr		*pp;
> > >>	int			fd;
> > >>
> > >>	fd = open(argv[1], O_RDONLY);
> > >>	ppi = xfs_pptr_alloc(32);
> > >>
> > >>	while (ioctl(fd, XFS_IOC_GETPPOINTER, ppi) == 0 && ppi->pi_ptrs_used) {
> > >>		for (i = 0; i < ppi->pi_ptrs_used; i++) {
> > >>			printf("%llu:%u -> %s\n",
> > >>					ppi->pi_ptrs[i].pp_ino,
> > >>					ppi->pi_ptrs[i].pp_gen,
> > >>					ppi->pi_ptrs[i].pp_name);
> 
> And this becomes:
> 
> 		for (i = 0; i < ppi->pi_ptrs_used; i++) {
> 			pp = XFS_PPINFO_TO_PP(ppi, i);
> 			printf("%llu:%u -> %s\n", pp->pp_ino, pp->pp_gen,
> 						  pp->pp_name);
> 		}

Funnily enough I've added more bits to this, maybe I should just send a
real RFC patch to the list.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
