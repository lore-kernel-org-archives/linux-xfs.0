Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02C817F3F
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:21:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C517AC005
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 19:21:52 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HNqta4quPv1JJQ0R for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 19:21:50 -0800 (PST)
Date: Thu, 21 Nov 2013 14:21:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use correct size value in generic/273
Message-ID: <20131121032138.GD6188@dastard>
References: <1384970070-58732-1-git-send-email-bfoster@redhat.com>
	<20131121024605.GB6188@dastard> <528D76F7.5060505@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528D76F7.5060505@sandeen.net>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Nov 20, 2013 at 08:59:03PM -0600, Eric Sandeen wrote:
> On 11/20/13, 8:46 PM, Dave Chinner wrote:
> > On Wed, Nov 20, 2013 at 12:54:30PM -0500, Brian Foster wrote:
> >> generic/273 factors the "space available" output from df into the
> >> calculation for the size of the origin data set. Recent commit
> >>
> >>   bfdd1e72b358 xfstests: added -P option to $DF_PROG
> >>
> >> ... converted the use of 'df' to $DF_PROG. This implicitly adds the
> >> -T parameter to add the fs type column, shifts the available space
> >> column over by one and unintentionally causes 273 to look at "used
> >> space" and create too small of a data set for a useful test.
> >> Realign to the to the available space value.
> >>
> >> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >> ---
> >>  tests/generic/273 | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tests/generic/273 b/tests/generic/273
> >> index 63bbf9b..2d54493 100755
> >> --- a/tests/generic/273
> >> +++ b/tests/generic/273
> >> @@ -68,7 +68,7 @@ _file_create()
> >>  
> >>  	cd $SCRATCH_MNT/origin
> >>  
> >> -	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
> >> +	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 4]; break}}}'`
> >>  	_disksize=$(($_disksize / 3))
> >>  	_num=$(($_disksize / $count / $threads / 4096))
> >>  	_count=$count
> > 
> > Just what is this bunch of unmaintainable line noise actually doing?
> > 
> > $ df -T -P --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 4]; break}}}'
> > 5282562048
> > $
> > 
> > Ok, someone didn't know about --output:
> 
> I sure didn't.  Not in my manpage or in my df --help output...  Is it new?

It must be - I noticed it a while back when I upgraded a 5 year old
coreutils package to 8.21, so it's sometime in the past 5 years it
was added ;)

> presumably from long lvm devicenames.
> 
> # df --block-size=1 /dev/mapper/vg_bp05-lv_home
> Filesystem           1B-blocks      Used Available Use% Mounted on
> /dev/mapper/vg_bp05-lv_home
>                      437264879616 254143942656 183120936960  59% /home

The "-P" option prevents that from occurring - from the info page:

`-P'
`--portability'
     Use the POSIX output format.  This is like the default format
     except for the following:

       1. The information about each file system is always printed on
          exactly one line; a mount device is never put on a line by
          itself.  This means that if the mount device name is more
          than 20 characters long (e.g., for some network mounts), the
          columns are misaligned.

So that's no longer an issue when we use $DF_PROG....

> > $ df -T -P --block-size=1 $SCRATCH_DEV | tail -1 | awk '// { print $5 }'
> > 5282562048
> > $
> > 
> > Looks a little easier to understand, yes?
> 
> yeah, and I guess it does work:
> 
> # df -T -P --block-size=1 /dev/mapper/vg_bp05-lv_home | tail -1 | awk '// { print $5 }'
> 183120936960

Great!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
