Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 16:23:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB30NjaP020779
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 16:23:48 -0800
Date: Mon, 3 Dec 2007 11:23:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: ACL limit
Message-ID: <20071203002349.GV119954183@sgi.com>
References: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr> <20071202223105.GS119954183@sgi.com> <475343FB.3060902@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475343FB.3060902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Dec 03, 2007 at 10:47:07AM +1100, Timothy Shimmin wrote:
> David Chinner wrote:
> >On Fri, Nov 30, 2007 at 07:07:26PM +0100, Jan Engelhardt wrote:
> >>Hi,
> >>
> >>
> >>is there any way to raise the number of ACLs that can be stored? The 
> >>current limit of 25 is quite tight, where ext3 allows 124 and jfs 8192.
> >>Would increasing XFS_ACL_MAX_ENTRIES work (yes, using potentially more 
> >>memory), i.e. not interfering with the on-disk format?
> >
> >It would be an on disk format change - older kernels would error out
> >(-EINVAL) on > 25 ACLs and not check any of them. Hence we'd
> >probably need a superblock feature bit to indicate that >25 ACEs are
> >supported in a given ACL.
> >
> >But we can work around that (superblock feature bit) and should
> >be able to extend this out to ~8190 entries. We're doing an ACL
> >rework ATM, so > 25 entry support should fall out of that....
> 
> Yeah, it's just an array of entries in an EA value.
> The EA value is limited to 64K so it's a question of how
> many entries you can fit into that.
> (64K - 4)/12 = 5461

Confused - I thought the ACE was 8 bytes:

struct posix_acl_entry {
        short                   e_tag;
	unsigned short          e_perm;
	unsigned int            e_id;
};

Also, JFS only allows 64k for the xattr as well (jfs_xattr.h):

/* Macros for defining maxiumum number of bytes supported for EAs */
#define MAXEASIZE       65535
#define MAXEALISTSIZE   MAXEASIZE

And (64k - 4)/8 = 8191 which is what JFS supports.

Oh:

typedef __uint16_t      xfs_acl_perm_t;
typedef __int32_t       xfs_acl_type_t;
typedef __int32_t       xfs_acl_tag_t;
typedef __int32_t       xfs_acl_id_t;

#define XFS_ACL_MAX_ENTRIES 25
#define XFS_ACL_NOT_PRESENT (-1)

typedef struct xfs_acl_entry {
        xfs_acl_tag_t   ae_tag;
        xfs_acl_id_t    ae_id;
        xfs_acl_perm_t  ae_perm;
} xfs_acl_entry_t;

typedef struct xfs_acl {
        __int32_t       acl_cnt;
        xfs_acl_entry_t acl_entry[XFS_ACL_MAX_ENTRIES];
} xfs_acl_t;

An *XFS* ACE is 12 bytes and hence can't be passed directly to the
generic code. Tim - are we adding a translation layer or storing
the generic posix acl format on disk?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
