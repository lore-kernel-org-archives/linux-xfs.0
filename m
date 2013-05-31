Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 599557F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 03:10:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3845330404E
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 01:10:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Zd0693gwoKAAiT8v for <xfs@oss.sgi.com>;
	Fri, 31 May 2013 01:10:25 -0700 (PDT)
Date: Fri, 31 May 2013 10:10:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] 285: Fix test for ext4 in some configurations
Message-ID: <20130531081023.GA9269@quack.suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<20130530223000.GQ29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130530223000.GQ29466@dastard>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 31-05-13 08:30:00, Dave Chinner wrote:
> On Thu, May 30, 2013 at 02:45:37PM +0200, Jan Kara wrote:
> > In some configurations (e.g. 1 KB block size), ext4 can decide it is
> > better to zero out several blocks rather than splitting unwritten
> > extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> > test fails. Fix the problem by disabling the feature for this test.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  tests/generic/285 | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/tests/generic/285 b/tests/generic/285
> > index b700a15..8078b1c 100755
> > --- a/tests/generic/285
> > +++ b/tests/generic/285
> > @@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
> >  
> >  [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
> >  
> > +# Disable extent zeroing for ext4 as that change where holes are created
> > +if [ "$FSTYP" = "ext4" ]; then
> > +	DEV=`basename $TEST_DEV`
> > +	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> > +fi
> 
> would that be better going into _require_seek_data_hole so that 286
> also picks up this behaviour for ext4?
  Actually, thinking about it, test 286 doesn't need extent_max_zeroout_kb
set. It just compares file sizes / used blocks are the same and they really
should be regardless of extent_max_zeroout_kb setting. It is even desirable
to test this with the default extent_max_zeroout_kb setting...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
