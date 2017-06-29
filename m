Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751837AbdF2LyM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 07:54:12 -0400
Date: Thu, 29 Jun 2017 07:54:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs/141: use new errortag knob for crc error injection
Message-ID: <20170629115409.GA3291@bfoster.bfoster>
References: <20170628114450.9670-1-bfoster@redhat.com>
 <20170629044000.GA5871@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629044000.GA5871@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 28, 2017 at 09:40:00PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 28, 2017 at 07:44:50AM -0400, Brian Foster wrote:
> > Update the test to use the newly available sysfs errortag injection
> > knobs. The errortag knob has replaced the previous custom knob in
> > the kernel. Create a local helper to support the old knob for
> > backwards compatibility.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This updates xfs/141 to use the new error injection tag sysfs knob that
> > has replaced log_badcrc_factor in the latest XFS for-next tree.
> 
> Hmmm... for xfstests, I was thinking of rewriting the common/inject helpers:
> 
> # Requires that xfs_io inject command knows about this error type
> _require_xfs_io_error_injection()
> {
> 	type="$1"
> 
> 	shortdev=$(_short_dev $TEST_DEV)
> 	tagfile=/sys/fs/xfs/$shortdev/errortag/$type
> 	test -w $tagfile && return
> 
> 	_require_error_injection
> 
> 	if [ "$type" = "log_bad_crc" ]; then
> 		tagfile=/sys/fs/xfs/$shortdev/log/log_badcrc_factor
> 		test -w $tagfile && return
> 		_notrun "Cannot find log_badcrc_factor"
> 	fi
> 
> 	# NOTE: We can't actually test error injection here because xfs
> 	# hasn't always range checked the argument to xfs_errortag_add.
> 	# We also don't want to trip an error before we're ready to deal
> 	# with it.
> 
> 	$XFS_IO_PROG -x -c 'inject' $TEST_DIR | grep -q "$type" || \
> 		_notrun "XFS error injection $type unknown."
> }
> 
> # Inject an error into the scratch fs
> _scratch_inject_error()
> {
> 	type="$1"
> 	value="$2"
> 
> 	shortdev=$(_short_dev $SCRATCH_DEV)
> 	tagfile=/sys/fs/xfs/$shortdev/errortag/$type
> 	if [ -w $tagfile ]; then
> 		echo "$value" > $tagfile
> 		return
> 	fi
> 
> 	if [ "$type" = "log_bad_crc" ]; then
> 		tagfile=/sys/fs/xfs/$shortdev/log/log_badcrc_factor
> 		if [ -w $tagfile ]; then
> 			echo "$value" > $tagfile
> 			return
> 		fi
> 		_notrun "cannot inject error $type value $value"
> 	elif [ -z "$value" ] || [ "$value" = "default" ]; then
> 		$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
> 	else
> 		_notrun "cannot inject error $type value $value"
> 	fi
> }
> 
> ...that way we can just change xfs/141 to do:
> 
> _require_xfs_io_error_injection "log_bad_crc"
> ...
> for i in $(seq 1 5); do
>  	# Enable error injection. Use a random bad crc factor up to 100
>  	# (increase this value to run fsstress longer).
>  	factor=$((RANDOM % 100 + 1))
> 	...
> 	_scratch_inject_error "log_bad_crc" "$factor"
> 	...
> done
> 
> Therefore we can move all the other error injection knob tests (looking
> at you, drop_writes) to a standard helper function that will cover all
> the errortag knobs we're moving to sysfs.  Unfortunately we pay for that
> uniformity by uglifying the helper functions to handle the old knobs,
> but oh well.
> 

That all looks pretty good to me. There's only a couple or so old knobs
being killed off, so it doesn't seem like that big of a deal.

Are you planning to send a patch for the above? If so, we can just drop
this one (and I'll update the tail overwrite test as well).

> I do wonder about the old xfs_io command, though -- while it's tempting
> to rewrite it to do all the parsing required to get to sysfs, I'm not so
> enthused about doing in C what can be done much more easily in bash.
> 

Not sure I follow... are you contemplating rewriting 'xfs_io -c inject
...' to actually use sysfs rather than the ioctl()? That seems like it
would get kind of ugly, at first thought. If we really wanted the
ability to set the frequency through xfs_io, I think the right approach
is probably to define a new ioctl() that takes a frequency param (but
I'm not really convinced there is a need).

Brian

> --D
> 
> > 
> > Brian
> > 
> >  tests/xfs/141 | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tests/xfs/141 b/tests/xfs/141
> > index 56ff14e..ea4f558 100755
> > --- a/tests/xfs/141
> > +++ b/tests/xfs/141
> > @@ -43,6 +43,21 @@ _cleanup()
> >  	wait > /dev/null 2>&1
> >  }
> >  
> > +# require either the current error tag or the old custom log record crc error
> > +# injection knob
> > +_setup_bad_crc()
> > +{
> > +	if [ -e /sys/fs/xfs/$1/errortag/log_bad_crc ]; then
> > +		badcrc_attr=/sys/fs/xfs/$1/errortag/log_bad_crc
> > +		return
> > +	fi
> > +	if [ -e /sys/fs/xfs/$1/log/log_badcrc_factor ]; then
> > +		badcrc_attr=/sys/fs/xfs/$1/log/log_badcrc_factor
> > +		return
> > +	fi
> > +	_notrun "bad crc sysfs attribute not supported"
> > +}
> > +
> >  rm -f $seqres.full
> >  
> >  # get standard environment, filters and checks
> > @@ -53,7 +68,6 @@ rm -f $seqres.full
> >  # Modify as appropriate.
> >  _supported_fs xfs
> >  _supported_os Linux
> > -_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_badcrc_factor
> >  _require_scratch
> >  _require_command "$KILLALL_PROG" killall
> >  
> > @@ -62,14 +76,14 @@ echo "Silence is golden."
> >  _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> >  _scratch_mount
> >  
> > -sdev=$(_short_dev $SCRATCH_DEV)
> > +_setup_bad_crc $(_short_dev $SCRATCH_DEV)
> >  
> >  for i in $(seq 1 5); do
> >  	# Enable error injection. Use a random bad crc factor up to 100
> >  	# (increase this value to run fsstress longer).
> >  	factor=$((RANDOM % 100 + 1))
> > -	echo iteration $i log_badcrc_factor: $factor >> $seqres.full 2>&1
> > -	echo $factor > /sys/fs/xfs/$sdev/log/log_badcrc_factor
> > +	echo iteration $i bad crc factor: $factor >> $seqres.full 2>&1
> > +	echo $factor > $badcrc_attr
> >  
> >  	# Run fsstress until the filesystem shuts down. It will shut down
> >  	# automatically when error injection triggers.
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
