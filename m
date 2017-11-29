Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61607 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751439AbdK2BXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:23:25 -0500
Date: Wed, 29 Nov 2017 12:19:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 02/17] Set up infastructure for deferred attribute
 operations
Message-ID: <20171129011912.GJ5858@dastard>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-3-git-send-email-allison.henderson@oracle.com>
 <20171128194547.GX21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128194547.GX21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 11:45:47AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2017 at 11:21:30AM -0700, Allison Henderson wrote:
> > +/*
> > + * This is the structure used to lay out an attr log item in the
> > + * log.
> > + */
> > +struct xfs_attr_log_format {
> > +	uint64_t	alf_id;		/* attri identifier */
> > +	xfs_ino_t       alf_ino;	/* the inode for this attr operation */
> > +	uint32_t        alf_op_flags;	/* marks the op as a set or remove */
> > +	uint32_t        alf_name_len;	/* attr name length */
> > +	uint32_t        alf_value_len;	/* attr value length */
> > +	uint32_t        alf_attr_flags;	/* attr flags */
> > +	uint16_t	alf_type;	/* attri log item type */
> > +	uint16_t	alf_size;	/* size of this item */
> 
> Type and size should go first so that the self-identification
> information ends up at the same byte offsets as the other log formats.
> This makes it much easier to dissect dirty log contents by hand if
> things get messy.

I'll point out this is not a "nice to have" feature but a
requirement of the on-disk log format structures.

That is, log recovery assumes that every log format item it finds in
the log has it's type and size as the first two 16 bit fields in the
log format item so it can validate that a) it's a known log format
type, and b) knows how big the log format structure it is about to
decode is supposed to be.

>From fs/xfs/xfs_log_recovery.c:

/*
 * The next region to add is the start of a new region.  It could be
 * a whole region or it could be the first part of a new region.  Because
 * of this, the assumption here is that the type and size fields of all
 * format structures fit into the first 32 bits of the structure.
 *
 * This works because all regions must be 32 bit aligned.  Therefore, we
 * either have both fields or we have neither field.  In the case we have
 * neither field, the data part of the region is zero length.  We only have
 * a log_op_header and can throw away the header since a new one will appear
 * later.  If we have at least 4 bytes, then we can determine how many regions
 * will appear in the current log item.
 */
STATIC int
xlog_recover_add_to_trans(
.....

Also, see the use of the ITEM_TYPE() macro in
fs/xfs/xfs_log_recovery.c as another example of assuming the type
field is the first 16 bits of the log format structures....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
