Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 14:41:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m39Lf05f032597
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 14:41:04 -0700
Date: Thu, 10 Apr 2008 07:41:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 979087 - Test 091 fails on sector size != 512 bytes
Message-ID: <20080409214106.GF108924158@sgi.com>
References: <20080408022933.170C258C4C0F@chook.melbourne.sgi.com> <20080409191518.GA18486@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409191518.GA18486@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 09, 2008 at 03:15:18PM -0400, Christoph Hellwig wrote:
> On Tue, Apr 08, 2008 at 12:29:32PM +1000, David Chinner wrote:
> > Test 091 fails on sector size != 512 bytes
> > 
> > Test 091 assumes a direct I/O alignment of 512 bytes,
> > a hold over from 2.4 kernels. On 2.6. kernels, direct
> > I/O needs to be aligned to the sector size the filesystem
> > was mkfs'd with.
> 
> Actually this makes 091 fail in my kvm test setup now:
> 
> 091 49s ... - output mismatch (see 091.out.bad)
> 1a2,7
> > meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > data     = bsize=XXX blocks=XXX, imaxpct=PCT
> >          = sunit=XXX swidth=XXX, unwritten=X
> > naming   =VERN bsize=XXX
> > log      =LDEV bsize=XXX blocks=XXX
> > realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX

Looks like a redirect issue. My bad.

(stems from 091 failing later on 64k page size, and the
above output not appearing in any of the output files when
a test failure occurs.)

Patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 xfstests/091 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs-cmds/xfstests/091
===================================================================
--- xfs-cmds.orig/xfstests/091	2008-04-08 12:25:08.000000000 +1000
+++ xfs-cmds/xfstests/091	2008-04-10 07:33:10.674694972 +1000
@@ -50,7 +50,7 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*
 
 # 2.6 Linux kernels support sector aligned direct I/O only
 if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
-	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info
+	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info > /dev/null
 	if [ $? -eq 0 ]; then
 		source $tmp.info
 		bsize=$sectsz
