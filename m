Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 840F77F37
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 14:52:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11B6FAC002
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 12:52:25 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ZSBiqgC3J6mBu1RA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 23 Jan 2016 12:52:23 -0800 (PST)
Date: Sat, 23 Jan 2016 12:52:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] reflink: fix off-by-one errors when iterating file
	blocks in a loop
Message-ID: <20160123205211.GB26408@birch.djwong.org>
References: <20160123003648.2666.37062.stgit@birch.djwong.org>
	<20160123003654.2666.17112.stgit@birch.djwong.org>
	<CAL3q7H7YwWgN0siD57CHd1od-drVxWuH_HDfmrVPB02O9XBNFw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H7YwWgN0siD57CHd1od-drVxWuH_HDfmrVPB02O9XBNFw@mail.gmail.com>
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
To: Filipe Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Jan 23, 2016 at 11:32:27AM +0000, Filipe Manana wrote:
> On Sat, Jan 23, 2016 at 12:36 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > When we're iterating file blocks in a loop (via seq), we have to
> > end at $nr-1, not $nr.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/183 |    2 +-
> >  tests/generic/185 |    2 +-
> >  tests/generic/186 |    2 +-
> >  tests/generic/187 |    2 +-
> >  tests/generic/194 |    2 +-
> >  tests/generic/195 |    2 +-
> >  tests/xfs/129     |    6 +++---
> >  tests/xfs/140     |    2 +-
> >  8 files changed, 10 insertions(+), 10 deletions(-)
> >
> >
> > diff --git a/tests/generic/183 b/tests/generic/183
> > index 5c65e9a..2cf9ce4 100755
> > --- a/tests/generic/183
> > +++ b/tests/generic/183
> > @@ -69,7 +69,7 @@ seq 0 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> 
> Just curious (and no bike shedding intended), why not make the loop in
> a much more simple and common way such as:
> 
> for ((i = 1; i < $NR; i += 2)); do
> ...
> done

Not that it matters here, but that's a bashism, isn't it?

> or  for i in `seq 1 2 $((NR - 1))`; do .... done

<shrug> No particular reason. :)

I suppose if NR is large then "seq | while read" avoids spraying a large number
of arguments into the command interpreter, though that clearly isn't the case
here.

--D

> 
> 
> 
> >         _reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/generic/185 b/tests/generic/185
> > index 384c9aa..55c54ac 100755
> > --- a/tests/generic/185
> > +++ b/tests/generic/185
> > @@ -69,7 +69,7 @@ seq 0 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/generic/186 b/tests/generic/186
> > index d84166d..f1c0e6b 100755
> > --- a/tests/generic/186
> > +++ b/tests/generic/186
> > @@ -112,7 +112,7 @@ seq 0 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/generic/187 b/tests/generic/187
> > index c85a0a9..ce35ec0 100755
> > --- a/tests/generic/187
> > +++ b/tests/generic/187
> > @@ -112,7 +112,7 @@ seq 0 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> >         _reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/generic/194 b/tests/generic/194
> > index a441aee..b88297e 100755
> > --- a/tests/generic/194
> > +++ b/tests/generic/194
> > @@ -79,7 +79,7 @@ md5sum "$TESTDIR/file3" | _filter_scratch
> >  md5sum "$TESTDIR/file3.chk" | _filter_scratch
> >
> >  echo "directio CoW across the transition"
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/generic/195 b/tests/generic/195
> > index 83e7b23..464a4d4 100755
> > --- a/tests/generic/195
> > +++ b/tests/generic/195
> > @@ -79,7 +79,7 @@ md5sum "$TESTDIR/file3" | _filter_scratch
> >  md5sum "$TESTDIR/file3.chk" | _filter_scratch
> >
> >  echo "CoW across the transition"
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR-1)) | while read f; do
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
> >         _pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
> >  done
> > diff --git a/tests/xfs/129 b/tests/xfs/129
> > index c8c47a2..3b7c59c 100755
> > --- a/tests/xfs/129
> > +++ b/tests/xfs/129
> > @@ -65,9 +65,9 @@ NR_BLKS=$((4 * BLKSZ / 12))
> >  _pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/file1" >> "$seqres.full"
> >
> >  echo "Reflink every other block"
> > -seq 1 $((NR_BLKS / 2)) | while read nr; do
> > -       _reflink_range  "$TESTDIR/file1" $((nr * 2 * BLKSZ)) \
> > -                       "$TESTDIR/file2" $((nr * 2 * BLKSZ)) $BLKSZ >> "$seqres.full"
> > +seq 1 2 $((NR_BLKS - 1)) | while read nr; do
> > +       _reflink_range  "$TESTDIR/file1" $((nr * BLKSZ)) \
> > +                       "$TESTDIR/file2" $((nr * BLKSZ)) $BLKSZ >> "$seqres.full"
> >  done
> >
> >  echo "Create metadump file"
> > diff --git a/tests/xfs/140 b/tests/xfs/140
> > index e20cd3f..45be9f4 100644
> > --- a/tests/xfs/140
> > +++ b/tests/xfs/140
> > @@ -70,7 +70,7 @@ cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 do not match"
> >  cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
> >
> >  echo "CoW every other block"
> > -seq 1 2 $NR | while read f; do
> > +seq 1 2 $((NR - 1)) | while read f; do
> >         _pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
> >         _pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
> >  done
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
