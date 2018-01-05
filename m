Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbeAEIC5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jan 2018 03:02:57 -0500
Date: Fri, 5 Jan 2018 16:02:55 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/8] common/rc: report kmemleak errors
Message-ID: <20180105080255.GH5123@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314499847.18893.9855359031542704591.stgit@magnolia>
 <20171214093718.GH2749@eguan.usersys.redhat.com>
 <20171214181508.GJ6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214181508.GJ6896@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Dec 14, 2017 at 10:15:08AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 14, 2017 at 05:37:18PM +0800, Eryu Guan wrote:
> > On Tue, Dec 12, 2017 at 10:03:18PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If kmemleak is enabled, scan and report memory leaks after every test.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  check     |    2 ++
> > >  common/rc |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 54 insertions(+)
> > > 
> > > 
> > > diff --git a/check b/check
> > > index b2d251a..469188e 100755
> > > --- a/check
> > > +++ b/check
> > > @@ -497,6 +497,7 @@ _check_filesystems()
> > >  	fi
> > >  }
> > >  
> > > +_init_kmemleak
> > >  _prepare_test_list
> > >  
> > >  if $OPTIONS_HAVE_SECTIONS; then
> > > @@ -793,6 +794,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> > >  		    n_try=`expr $n_try + 1`
> > >  		    _check_filesystems
> > >  		    _check_dmesg || err=true
> > > +		    _check_kmemleak || err=true
> > >  		fi
> > >  
> > >  	    fi
> > > diff --git a/common/rc b/common/rc
> > > index cb83918..a2bed36 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -3339,6 +3339,58 @@ _check_dmesg()
> > >  	fi
> > >  }
> > >  
> > > +# capture the kmemleak report
> > > +_capture_kmemleak()
> > > +{
> > > +	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
> > > +	local _leak_file="$1"
> > > +
> > > +	# Tell the kernel to scan for memory leaks.  Apparently the write
> > > +	# returns before the scan is complete, so do it twice in the hopes
> > > +	# that twice is enough to capture all the leaks.
> > > +	echo "scan" > "${_kern_knob}"
> > > +	cat "${_kern_knob}" > /dev/null
> > > +	echo "scan" > "${_kern_knob}"
> > > +	cat "${_kern_knob}" > "${_leak_file}"
> > > +	echo "clear" > "${_kern_knob}"
> > 
> > Hmm, two scans seem not enough either, I could see false positive easily
> > in a 'quick' group run, because some leaks are not reported immediately
> > after the test but after next test or next few tests. e.g. I saw
> > generic/008 (tested on XFS) being reported as leaking memory, and from
> > 008.kmemleak I saw:
> > 
> > unreferenced object 0xffff880277679800 (size 512):
> >   comm "nametest", pid 25007, jiffies 4300176958 (age 9.854s)
> > ...
> > 
> > But "nametest" is only used in generic/007, the leak should be triggered
> > by generic/007 too, but 007 was reported as PASS in my case.
> > 
> > Not sure what's the best way to deal with these false positive, adding
> > more scans seem to work, but that's ugly and requires more test time..
> > What do you think?
> 
> I'm not sure either -- the brief scan I made of mm/kmemleak.c didn't
> reveal anything obvious that would explain the behavior we see.  It
> might just take a while for determine positively that an item isn't
> gray.

Seems so, I did read similar statements elsewhere, but I can't remember
now..

> 
> We could change the message to state that found leaks might have
> resulted from the previous test?  That's rather unsatisfying, but I
> don't know what else to do.

Seems like a reasonable way to go at this stage. I also noticed some
leaks probably were not from the test we ran nor fs-related, but other
processes on the system, e.g. 

unreferenced object 0xffff8801768be3c0 (size 256):
  comm "softirq", pid 0, jiffies 4299031078 (age 14.234s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 03 00 00 00 00 03 00 00  ................
    b7 fd 01 00 00 00 00 00 d8 f6 1f 79 02 88 ff ff  ...........y....
  backtrace:
    [<ffffffffa077cae8>] init_conntrack+0x4a8/0x4c0 [nf_conntrack]
    [<ffffffffa077d2c4>] nf_conntrack_in+0x494/0x510 [nf_conntrack]
    [<ffffffff815f32d7>] nf_hook_slow+0x37/0xb0
    [<ffffffff815fd6a0>] ip_rcv+0x2f0/0x3c0
    [<ffffffff815b5833>] __netif_receive_skb_core+0x3d3/0xaa0
    [<ffffffff815b8154>] netif_receive_skb_internal+0x34/0xc0
    [<ffffffffa0356654>] br_pass_frame_up+0xb4/0x140 [bridge]
    [<ffffffffa03568eb>] br_handle_frame_finish+0x20b/0x3f0 [bridge]
    [<ffffffffa0356c7b>] br_handle_frame+0x16b/0x2c0 [bridge]
    [<ffffffff815b5651>] __netif_receive_skb_core+0x1f1/0xaa0
    [<ffffffff815b8154>] netif_receive_skb_internal+0x34/0xc0
    [<ffffffff815b8dbc>] napi_gro_receive+0xbc/0xe0
    [<ffffffffa004f64c>] bnx2_poll_work+0x8fc/0x1190 [bnx2]
    [<ffffffffa004ff13>] bnx2_poll_msix+0x33/0xb0 [bnx2]
    [<ffffffff815b868e>] net_rx_action+0x26e/0x3a0
    [<ffffffff816e8778>] __do_softirq+0xc8/0x26c

Perhaps we can mark the kmemleak check as "experimental" or so? By
adding some kind of "disclaimer" in the beginning of $seqres.kmemleak
file? So people could have the right expectation on these kmemleak
failures.

> 
> Or maybe a sleep 1 in between scans to see if that makes it more likely
> to attribute a leak to the correct test?  I don't anticipate running
> xfstests with kmemleak=on too terribly often, so the extra ~700s won't
> bother me too much.

This doesn't improve anything to me, 7 of the first 8 tests failed due
to kmemleak check after adding 'sleep 1' between scans.

Thanks,
Eryu
