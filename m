Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26665 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdFWPeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2017 11:34:09 -0400
Date: Fri, 23 Jun 2017 08:34:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/8] common/populate: remember multi-device configurations
Message-ID: <20170623153403.GX4733@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170622062653.GF3787@birch.djwong.org>
 <20170623074902.GK23360@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623074902.GK23360@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jun 23, 2017 at 03:49:02PM +0800, Eryu Guan wrote:
> On Wed, Jun 21, 2017 at 11:26:53PM -0700, Darrick J. Wong wrote:
> > Record the external log and realtime device configurations when we
> > create a sample filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/populate |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index e99ce68..b59ed02 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -713,7 +713,15 @@ _scratch_populate_cached() {
> >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> >  
> >  	# Throw away cached image if it doesn't match our spec.
> > -	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ARGS $@"
> > +	case "${FSTYP}" in
> > +	"ext4")
> > +		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}";;
> > +	"xfs")
> > +		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
> > +	*)
> > +		extra_descr="";;
> > +	esac
> > +	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ${extra_descr} ARGS $@"
> 
> This works fine if "test without external log" then "test with external
> log" or vise-versa. But I just found that a second run with external log
> still cause scratch dev fail to mount. Seems it's because e2image
> doesn't take the external log dev into account when save/restore fs
> image, then mounting scratch dev failed with
> 
> [184952.642892] EXT4-fs (sdc2): journal UUID does not match

Ohhh... I just remembered that e2image (and xfs_metadump) don't capture
the external log in the dump.  ext4 chokes when the log device lacks the
header it needs and fails, though XFS is perfectly happy to complain
about the zero log and move on.

So either we can't use _scratch_populate cache in ext4 when
SCRATCH_LOGDEV is set, or I need to fix it to extract the expected
logdev uuid from the restored fs and reformat that onto the log device.

I'll work on that and resubmit.

--D

> 
> Thanks,
> Eryu
> 
> >  	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
> >  
> >  	# Do we have a cached image?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
