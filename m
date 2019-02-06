Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfBFRHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 12:07:00 -0500
Date: Wed, 6 Feb 2019 09:06:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] common: fix kmemleak to work with sections
Message-ID: <20190206170654.GC29630@magnolia>
References: <154877863279.9277.4463697450629081138.stgit@magnolia>
 <154877864538.9277.6249607598508212314.stgit@magnolia>
 <20190203091049.GN2713@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190203091049.GN2713@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Feb 03, 2019 at 05:10:49PM +0800, Eryu Guan wrote:
> On Tue, Jan 29, 2019 at 08:17:25AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the kmemleak code to work correctly with sections.  This
> 
> Thanks for the fix!
> 
> > requires changing the report location to use RESULT_DIR instead of
> > RESULT_BASE, and clarifying which functions get used when.
> 
> But I didn't see any RESULT_DIR related changes in this patch.

I forgot to update the commit log. :(

> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  check     |    4 ++--
> >  common/rc |   32 ++++++++++++++++++++++----------
> >  2 files changed, 24 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/check b/check
> > index c0eee0aa..b9eb86cb 100755
> > --- a/check
> > +++ b/check
> > @@ -509,7 +509,7 @@ _expunge_test()
> >  	return 0
> >  }
> >  
> > -_init_kmemleak
> > +_detect_kmemleak
> >  _prepare_test_list
> >  
> >  if $OPTIONS_HAVE_SECTIONS; then
> > @@ -793,8 +793,8 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >  			# and log messages that shouldn't be there.
> >  			_check_filesystems
> >  			_check_dmesg || err=true
> > -			_check_kmemleak || err=true
> >  		fi
> > +		_check_kmemleak || err=true
> 
> So we check for kmemleak after each test even when the test already
> failed, better to have some comments here to explain why this is
> necessary.

I'll add this in the next version:

	# Scan for memory leaks after every test so that associating
	# a leak to a particular test will be as accurate as possible.

> >  
> >  		# test ends after all checks are done.
> >  		$timestamp && _timestamp
> > diff --git a/common/rc b/common/rc
> > index 19e947df..75771f31 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3514,7 +3514,7 @@ _check_dmesg()
> >  # capture the kmemleak report
> >  _capture_kmemleak()
> >  {
> > -	local kern_knob="${DEBUGFS_MNT}/kmemleak"
> > +	local kern_knob="$DEBUGFS_MNT/kmemleak"
> 
> Just wondering why the "{}" are removed in this patch?

Making the variable dereferencing consistent with the rest of fstests.

> >  	local leak_file="$1"
> >  
> >  	# Tell the kernel to scan for memory leaks.  Apparently the write
> > @@ -3535,17 +3535,20 @@ ENDL
> >  	echo "clear" > "$kern_knob"
> >  }
> >  
> > -# set up kmemleak
> > -_init_kmemleak()
> > +# Figure out if the running kernel supports kmemleak; if it does, clear out
> > +# anything that leaked before we even started testing.  The leak checker only
> > +# needs to be primed like this once per ./check invocation.
> > +_detect_kmemleak()
> >  {
> > -	local kern_knob="${DEBUGFS_MNT}/kmemleak"
> > +	local kern_knob="$DEBUGFS_MNT/kmemleak"
> > +	KMEMLEAK_CHECK_FILE="/tmp/check_kmemleak"
> 
> So we're checking the "/tmp/check_kmemleak" file instead of

Right.

> ${RESULT_BASE}/check_kmemleak now, but from the commit log it seems that
> it should be ${RESULT_DIR}/check_kmemleak?

Er... oops.  I'll update the changelog. :)

> >  
> >  	# Since kernel v4.19-rc3, the kmemleak knob exists even if kmemleak is
> >  	# disabled, but returns EBUSY on write. So instead of relying on
> >  	# existance of writable knob file, we use a test file to indicate that
> >  	# _check_kmemleak() is enabled only if we actually managed to write to
> >  	# the knob file.
> > -	rm -f ${RESULT_BASE}/check_kmemleak
> > +	rm -f "$KMEMLEAK_CHECK_FILE"
> >  
> >  	if [ ! -w "$kern_knob" ]; then
> >  		return 0
> > @@ -3555,17 +3558,26 @@ _init_kmemleak()
> >  	# then dump all the leaks recorded so far.
> >  	if echo "scan=off" > "$kern_knob" 2>/dev/null; then
> >  		_capture_kmemleak /dev/null
> > -		touch ${RESULT_BASE}/check_kmemleak
> > +		touch "$KMEMLEAK_CHECK_FILE"
> >  	fi
> >  }
> >  
> > -# check kmemleak log
> > +# Kick the kmemleak checker to scan for leaks.  Background leak scan mode is
> > +# not enabled, so we must call the kernel to ask for a scan and deal with the
> > +# results appropriately.  This we do after every test completes, whether or not
> > +# it was successful.
> >  _check_kmemleak()
> >  {
> > -	local kern_knob="${DEBUGFS_MNT}/kmemleak"
> > -	local leak_file="${seqres}.kmemleak"
> > +	local kern_knob="$DEBUGFS_MNT/kmemleak"
> > +	local leak_file="$seqres.kmemleak"
> >  
> > -	if [ ! -f ${RESULT_BASE}/check_kmemleak ]; then
> > +	if [ ! -f "$KMEMLEAK_CHECK_FILE" ]; then
> > +		return 0
> > +	fi
> > +
> > +	# Not enabled, so discard any report of leaks found.
> > +	if [ "$USE_KMEMLEAK" != "yes" ]; then
> > +		_capture_kmemleak /dev/null
> 
> New knob requires new documentation in README :)

Will do.  Happy New Year, by the way!

--D

> Thanks,
> Eryu
> 
> >  		return 0
> >  	fi
> >  
> > 
