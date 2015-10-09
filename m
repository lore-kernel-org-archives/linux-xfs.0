Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C14A57F7B
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 13:58:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B5A0AC010
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 11:58:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CfVJBlMwoAmAwrYr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 11:58:10 -0700 (PDT)
Date: Fri, 9 Oct 2015 11:58:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
Message-ID: <20151009185802.GF10397@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<9163f8156b2742a0b003ba9fa0a26258@nebula-exfe-01.nebula.local>
	<1444307639.4004.17.camel@ari-lenovo>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444307639.4004.17.camel@ari-lenovo>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ari Sundholm <ari@tuxera.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Oct 08, 2015 at 03:33:59PM +0300, Ari Sundholm wrote:
> On Wed, 2015-10-07 at 05:13 +0000, Darrick J. Wong wrote:
> > Modify the reflink tests to support xfs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc         |   37 +++++++++++++++++++++++++++++++++++++
> >  tests/generic/800 |    2 +-
> >  tests/generic/801 |    2 +-
> >  tests/generic/802 |    2 +-
> >  4 files changed, 40 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 3e97060..7e2f140 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1429,6 +1429,43 @@ _require_scratch_xfs_crc()
> >  	umount $SCRATCH_MNT
> >  }
> >  
> > +# this test requires the test fs support reflink...
> > +#
> > +_require_test_reflink()
> > +{
> > +    case $FSTYP in
> > +    xfs)
> > +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +	;;
> > +    btrfs)
> > +        true
> > +        ;;
> > +    *)
> > +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +        ;;
> > +    esac
> > +}
> > +
> > +# this test requires the scratch fs support reflink...
> > +#
> > +_require_scratch_reflink()
> > +{
> > +    case $FSTYP in
> > +    xfs)
> > +	_scratch_mkfs > /dev/null 2>&1
> > +	_scratch_mount
> > +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "$FSTYP does not support reflink"
> 
> ${SCRATCH_MNT}?

Oops!  Thank you for catching this. :)

--D

> 
> > +	_scratch_unmount
> > +	;;
> > +    btrfs)
> > +        true
> > +        ;;
> > +    *)
> > +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +        ;;
> > +    esac
> > +}
> > +
> >  # this test requires the bigalloc feature to be available in mkfs.ext4
> >  #
> >  _require_ext4_mkfs_bigalloc()
> > diff --git a/tests/generic/800 b/tests/generic/800
> > index a71f11a..954f39d 100755
> > --- a/tests/generic/800
> > +++ b/tests/generic/800
> > @@ -45,7 +45,7 @@ _cleanup()
> >  . common/filter
> >  
> >  # real QA test starts here
> > -_supported_fs btrfs
> > +_require_test_reflink
> >  _supported_os Linux
> >  
> >  _require_xfs_io_command "fiemap"
> > diff --git a/tests/generic/801 b/tests/generic/801
> > index b21c44b..aedb6e9 100755
> > --- a/tests/generic/801
> > +++ b/tests/generic/801
> > @@ -45,7 +45,7 @@ _cleanup()
> >  . common/filter
> >  
> >  # real QA test starts here
> > -_supported_fs btrfs
> > +_require_test_reflink
> >  _supported_os Linux
> >  
> >  _require_xfs_io_command "fiemap"
> > diff --git a/tests/generic/802 b/tests/generic/802
> > index afd8513..51d3414 100755
> > --- a/tests/generic/802
> > +++ b/tests/generic/802
> > @@ -43,7 +43,7 @@ _cleanup()
> >  . ./common/filter
> >  
> >  # real QA test starts here
> > -_supported_fs btrfs
> > +_require_test_reflink
> >  _supported_os Linux
> >  
> >  _require_xfs_io_command "fiemap"
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
