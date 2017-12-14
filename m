Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdLNJhV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 04:37:21 -0500
Date: Thu, 14 Dec 2017 17:37:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/8] common/rc: report kmemleak errors
Message-ID: <20171214093718.GH2749@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314499847.18893.9855359031542704591.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314499847.18893.9855359031542704591.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 12, 2017 at 10:03:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If kmemleak is enabled, scan and report memory leaks after every test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  check     |    2 ++
>  common/rc |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> 
> diff --git a/check b/check
> index b2d251a..469188e 100755
> --- a/check
> +++ b/check
> @@ -497,6 +497,7 @@ _check_filesystems()
>  	fi
>  }
>  
> +_init_kmemleak
>  _prepare_test_list
>  
>  if $OPTIONS_HAVE_SECTIONS; then
> @@ -793,6 +794,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
>  		    n_try=`expr $n_try + 1`
>  		    _check_filesystems
>  		    _check_dmesg || err=true
> +		    _check_kmemleak || err=true
>  		fi
>  
>  	    fi
> diff --git a/common/rc b/common/rc
> index cb83918..a2bed36 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3339,6 +3339,58 @@ _check_dmesg()
>  	fi
>  }
>  
> +# capture the kmemleak report
> +_capture_kmemleak()
> +{
> +	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
> +	local _leak_file="$1"
> +
> +	# Tell the kernel to scan for memory leaks.  Apparently the write
> +	# returns before the scan is complete, so do it twice in the hopes
> +	# that twice is enough to capture all the leaks.
> +	echo "scan" > "${_kern_knob}"
> +	cat "${_kern_knob}" > /dev/null
> +	echo "scan" > "${_kern_knob}"
> +	cat "${_kern_knob}" > "${_leak_file}"
> +	echo "clear" > "${_kern_knob}"

Hmm, two scans seem not enough either, I could see false positive easily
in a 'quick' group run, because some leaks are not reported immediately
after the test but after next test or next few tests. e.g. I saw
generic/008 (tested on XFS) being reported as leaking memory, and from
008.kmemleak I saw:

unreferenced object 0xffff880277679800 (size 512):
  comm "nametest", pid 25007, jiffies 4300176958 (age 9.854s)
...

But "nametest" is only used in generic/007, the leak should be triggered
by generic/007 too, but 007 was reported as PASS in my case.

Not sure what's the best way to deal with these false positive, adding
more scans seem to work, but that's ugly and requires more test time..
What do you think?

Otherwise the whole check kmemleak framework looks fine to me.

Thanks,
Eryu

> +}
> +
> +# set up kmemleak
> +_init_kmemleak()
> +{
> +	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
> +
> +	if [ ! -w "${_kern_knob}" ]; then
> +		return 0
> +	fi
> +
> +	# Disable the automatic scan so that we can control it completely,
> +	# then dump all the leaks recorded so far.
> +	echo "scan=off" > "${_kern_knob}"
> +	_capture_kmemleak /dev/null
> +}
> +
> +# check kmemleak log
> +_check_kmemleak()
> +{
> +	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
> +	local _leak_file="${seqres}.kmemleak"
> +
> +	if [ ! -w "${_kern_knob}" ]; then
> +		return 0
> +	fi
> +
> +	# Capture and report any leaks
> +	_capture_kmemleak "${_leak_file}"
> +	if [ -s "${_leak_file}" ]; then
> +		_dump_err "_check_kmemleak: something found in kmemleak (see ${_leak_file})"
> +		return 1
> +	else
> +		rm -f "${_leak_file}"
> +		return 0
> +	fi
> +}
> +
>  # don't check dmesg log after test
>  _disable_dmesg_check()
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
