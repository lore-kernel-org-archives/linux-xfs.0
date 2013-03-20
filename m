Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA7DB7F37
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 05:47:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C4F5AC004
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 03:47:47 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qxkGrHy8yxey1x8s for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 03:47:45 -0700 (PDT)
Date: Wed, 20 Mar 2013 11:47:44 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: Count journal size in test 289
Message-ID: <20130320104744.GA13294@quack.suse.cz>
References: <1363710082-11371-1-git-send-email-jack@suse.cz>
	<51489ACE.1010205@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51489ACE.1010205@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 19-03-13 12:05:18, Eric Sandeen wrote:
> On 3/19/13 11:21 AM, Jan Kara wrote:
> > Test 289 ignored the fact that historically journal is not accounted as
> > fs overhead. For larger filesystems it is hidden in 1% tolerance but for
> > filesystems smaller than 12G the test fails. So make the counting
> > precise to work everywhere.
> 
> Thanks.
> 
> 0875a2b448fcaba67010850cf9649293a5ef653d ext4: include journal blocks in df overhead calcs
  Bah, I missed that. But ext3 definitely needs this (and I'm not sure we
want to change that behavior after so many years - it's mostly cosmetic
anyway so the possibility of breaking some userspace seems a bad tradeoff).

> changed this again, right - so will this change work in both cases?
  No, it will now fail for small ext4 filesystems instead of small ext3
filesystems :).  So we will count journal blocks only for ext3, ok?

> Also: is using "Journal length: " any simpler?
  It would be, but older versions of dumpe2fs don't have that (it happened
somewhere between 1.41.9 and 1.41.11) so I figured I will use a more
generic approach (too lazy to fix my test machine ;).

								Honza

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  289           |   12 ++++++++----
> >  common.filter |   15 +++++++++++++++
> >  2 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/289 b/289
> > index b057c20..9bba144 100755
> > --- a/289
> > +++ b/289
> > @@ -59,10 +59,14 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> >  FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> >  		| awk '/Free blocks:/{print $3}'`
> >  
> > -# nb: kernels today don't count journal blocks  as overhead, but should.
> > -# For most filesystems this will still be within tolerance.
> > -# Overhead is all the blocks (already) used by the fs itself:
> > -OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
> > +JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> > +		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
> > +BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> > +		| awk '/Block size:/{print $3}'`
> > +JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
> > +
> > +# kernels today don't count journal blocks as overhead, but should.
> > +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))
> >  
> >  #  bsddf|minixdf
> >  #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
> > diff --git a/common.filter b/common.filter
> > index f0f6076..fcd7589 100644
> > --- a/common.filter
> > +++ b/common.filter
> > @@ -229,5 +229,20 @@ _filter_spaces()
> >         sed -e 's/ [ ]*/ /g'
> >  }
> >  
> > +# Convert string read from stdin like 128K to bytes and print it to stdout
> > +_filter_size_to_bytes()
> > +{
> > +	read size
> > +	suffix=${size:${#size}-1}
> > +	mul=1
> > +	case $suffix in
> > +		K) mul=1024 ;;
> > +		M) mul=$((1024*1024)) ;;
> > +		G) mul=$((1024*1024*1024)) ;;
> > +		T) mul=$((1024*1024*1024*1024)) ;;
> > +	esac
> > +	echo $((${size:0:${#size}-1}*$mul))
> > +}
> > +
> >  # make sure this script returns success
> >  /bin/true
> > 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
