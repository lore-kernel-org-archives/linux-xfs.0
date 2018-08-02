Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbeHBJA3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 05:00:29 -0400
Date: Thu, 2 Aug 2018 15:10:40 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs/288: _notrun if xfs_db can't write values
 into dir or attr
Message-ID: <20180802071039.GT4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
References: <20180731054119.13539-1-zlang@redhat.com>
 <20180731054119.13539-2-zlang@redhat.com>
 <20180802004634.GB4211@magnolia>
 <20180802014941.GS4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
 <20180802051452.GO30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180802051452.GO30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, yangx.jy@cn.fujitsu.com

On Wed, Aug 01, 2018 at 10:14:52PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 02, 2018 at 09:49:41AM +0800, Zorro Lang wrote:
> > On Wed, Aug 01, 2018 at 05:46:34PM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 31, 2018 at 01:41:19PM +0800, Zorro Lang wrote:
> > > > Commit b3cf8b72334fd35ef961869506e5a72ab398bc82 help xfs/288 to
> > > > support v5 filesystems testing, but there're still some old
> > > > distributions don't support xfs_db write '-d' option, or can't
> > > > write values into dir/attr of v5 filesystems.
> > > > 
> > > > For compatible with older versions, skip this test on v5 xfs
> > > > if xfs_db write can't write v5 XFS dir/attr.
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > Xiao found v1 can't work well on xfsprogs-4.9, due to 'write -d' can't
> > > > write vaules into dir/attr of v5 filesystems before xfsprogs-4.13.
> > > > 
> > > > Only check "if write command has -d option" is not enough. So I write
> > > > a function _require_xfs_db_write_da() to make sure current xfs_db
> > > > can write dir/attr (not only on v5, but especially for v5).
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > >  common/xfs    | 28 ++++++++++++++++++++++++++++
> > > >  tests/xfs/288 |  1 +
> > > >  2 files changed, 29 insertions(+)
> > > > 
> > > > diff --git a/common/xfs b/common/xfs
> > > > index d971b4a8..95dcfd59 100644
> > > > --- a/common/xfs
> > > > +++ b/common/xfs
> > > > @@ -720,6 +720,34 @@ _require_xfs_db_write_array()
> > > >  	[ $supported -eq 0 ] && _notrun "xfs_db write can't support array"
> > > >  }
> > > >  
> > > > +# Before xfsprogs commit 89baf918(xfs_db: write values into dir/attr blocks and
> > > > +# recalculate CRCs), xfs_db write command can't write invalid data into dir/attr
> > > > +# field of v5 filesystems. For some cases need to write dir/attr (especially crc
> > > > +# enabled), use this _require at first.
> > > > +_require_xfs_db_write_da()
> > > > +{
> > > > +	local inum
> > > > +	local count
> > > > +
> > > > +	_require_scratch
> > > > +
> > > > +	_scratch_mkfs > /dev/null 2>&1
> > > > +	_scratch_mount
> > > > +	mkdir $SCRATCH_MNT/$seq.dir
> > > > +	inum=$(stat -c '%i' $SCRATCH_MNT/$seq.dir)
> > > > +	$SETFATTR_PROG -n "user.testda" \
> > > > +		       -v "$(perl -e "print 'v' x 65536;")" \
> > > > +		       $SCRATCH_MNT/$seq.dir
> > > > +	_scratch_unmount
> > > > +	_scratch_xfs_set_metadata_field "hdr.count" "0" \
> > > 
> > > Just FYI an upcoming change to the attr block verifier in 4.19 will
> > > break this because it rejects hdr.count == 0.  Can you please set this
> > > to 1 instead of 0?
> > > 
> > > > +					"inode $inum" "ablock 0" >/dev/null 2>&1
> > > > +	count=$(_scratch_xfs_get_metadata_field "hdr.count" \
> > > > +						"inode $inum" "ablock 0")
> > > > +	if [ "$count" != "0" ]; then
> > > 
> > > And update the test here?
> > 
> > Sure, I can change the 0 to 1. BTW, does it affect xfs/288? Because xfs/288 set
> > hdr.count to 0 too.
> 
> IIUC, xfs/288 deliberately sets hdr.count to 0 to test how the code
> handles the (corrupt) attr header, so that use is fine.

Hmm... sorry I'm confused now, can you show me the patch which will
"rejects hdr.count == 0"?

xfs/288 trys to check how xfs_repair deal with hdr.count=0. If
"write (-d) hdr.count 0" will be rejected directly, that's another issue.
If it won't affect xfs_db "write", why I can't write 0 in this patch?

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > +		_notrun "xfs_db write can't write values into dir/attr blocks"
> > > > +	fi
> > > > +}
> > > > +
> > > >  _require_xfs_spaceman_command()
> > > >  {
> > > >  	if [ -z "$1" ]; then
> > > > diff --git a/tests/xfs/288 b/tests/xfs/288
> > > > index f4165b6c..e9589fd5 100755
> > > > --- a/tests/xfs/288
> > > > +++ b/tests/xfs/288
> > > > @@ -35,6 +35,7 @@ _supported_fs xfs
> > > >  _supported_os Linux
> > > >  _require_scratch
> > > >  _require_attrs
> > > > +_require_xfs_db_write_da
> > > >  
> > > >  # get block size ($dbsize) from the mkfs output
> > > >  _scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > > > -- 
> > > > 2.14.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
