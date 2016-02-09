Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B49B87CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 02:16:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F9C3AC004
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 00:16:50 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id S359FaoFtFvLgskS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 00:16:49 -0800 (PST)
Date: Tue, 9 Feb 2016 00:16:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/23] xfs: more reflink tests
Message-ID: <20160209081644.GB6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011250.23099.50000.stgit@birch.djwong.org>
	<20160209073622.GI19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209073622.GI19486@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 06:36:22PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:12:50PM -0800, Darrick J. Wong wrote:
> > Create a couple of XFS-specific tests -- one to check that growing
> > and shrinking the refcount btree works and a second one to check
> > what happens when we hit maximum refcount.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_scratch_reflink
> > +_require_cp_reflink
> ....
> > +
> > +test -x "$here/src/punch-alternating" || _notrun "punch-alternating not built"
> 
> I suspect we need a _require rule for checking that something in
> the test src directory has been built.

Crapola, we also need punch-alternating, which doesn't appear until the next
patch.  Guess I'll go move it out of the next patch (or swap the order of
these two I guess.)

I added _require_test_program() which complains if src/$1 isn't built.

> > +echo "Check scratch fs"
> > +umount "$SCRATCH_MNT"
> > +echo "check refcount after removing all files" >> "$seqres.full"
> > +"$XFS_DB_PROG" -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' "$SCRATCH_DEV" >> "$seqres.full"
> > +"$XFS_REPAIR_PROG" -o force_geometry -n "$SCRATCH_DEV" >> "$seqres.full" 2>&1
> > +res=$?
> > +if [ $res -eq 0 ]; then
> > +	# If repair succeeds then format the device so that the post-test
> > +	# check doesn't fail due to the single AG.
> > +	_scratch_mkfs >> "$seqres.full" 2>&1
> > +else
> > +	_fail "xfs_repair fails"
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> 
> This is what _require_scratch_nocheck avoids.
> 
> i.e. do this instead:
> 
> _require_scratch_nocheck
> .....
> 
> "$XFS_REPAIR_PROG" -o force_geometry -n "$SCRATCH_DEV" >> "$seqres.full" 2>&1 
> status=$?
> exit

Ok.

> Also, we really don't need the quotes around these global
> variables.  They are just noise and lots of stuff will break if
> those variables are set to something that requires them to be
> quoted.

<nod>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
