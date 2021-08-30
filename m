Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60259C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 04:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3958060F6C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 04:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhH3EWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 00:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhH3EWL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Aug 2021 00:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8514560F57;
        Mon, 30 Aug 2021 04:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630297278;
        bh=7ktLlUP6FlGdEIcZK2Nwkhd1yT7yK7AXrlPdZTt5YO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d2MAVjV5SfSTBBngfJcZ+eGEVcmcIef130cELvfySI0B2lesw7Y37CPkhqnvOfc1F
         cwFxSmJERVzq/lDdM9PIaqxolv/TiiQGnQsIkMVGeSRnibGT/JIj6H6s4b9gMgFaAH
         2Nx63KFVQ5aB0dBk/QJRv+KmLOTFMCtFmbITpDLb7hsDEuTB9GvKOixekGTitDxTDM
         jZpyc9gwBeTJ89HiLdlJ9nqOzL6E3zf2ackWEceuMo0EsX2YHfIbeddQ2Tlc/6xNaz
         Udmka8bfUwLMOXMZPBh1YyxB/0RDc81Vi7tkgnMAPYyw2OABkhwY+TFmQ22bpDoSnC
         2CDWvdv7iBS6A==
Date:   Sun, 29 Aug 2021 21:21:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC [was: XFS fallocate implementation incorrectly
 reports ENOSPC]
Message-ID: <20210830042118.GQ12640@magnolia>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
 <20210828035824.GA3654894@onthe.net.au>
 <20210829220457.GR3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829220457.GR3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 30, 2021 at 08:04:57AM +1000, Dave Chinner wrote:
> On Sat, Aug 28, 2021 at 01:58:24PM +1000, Chris Dunlop wrote:
> > On Sat, Aug 28, 2021 at 10:21:37AM +1000, Chris Dunlop wrote:
> > > On Sat, Aug 28, 2021 at 08:03:43AM +1000, Dave Chinner wrote:
> > > > commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
> > > > Author: Brian Foster <bfoster@redhat.com>
> > > > Date:   Wed Apr 28 15:06:05 2021 -0700
> > > > 
> > > >   xfs: set aside allocation btree blocks from block reservation
> > > 
> > > Oh wow. Yes, sounds like a candidate. Is there same easy(-ish?) way of
> > > seeing if this fs is likely to be suffering from this particular issue
> > > or is it a matter of installing an appropriate kernel and seeing if the
> > > problem goes away?
> > 
> > Is this sufficient to tell us that this filesystem probably isn't suffering
> > from that issue?

Since you've formatted with rmapbt enabled, you probably have a new
enough xfsprogs that you can /also/ use this on a live fs:

$ xfs_spaceman -c 'freesp -g'  /
        AG    extents     blocks
         0       2225    1426437
         1       2201    1716114
         2       2635    1196409
         3       2307    1567751

And if you really want the per-AG histogram...

$ xfs_spaceman -c 'freesp -s -a 2'  /
   from      to extents  blocks    pct
      1       1     262     262   0.02
      2       3     240     551   0.05
      4       7     306    1740   0.15
      8      15     370    4194   0.35
     16      31     563   13286   1.11
     32      63     362   16926   1.41
     64     127     271   22729   1.90
    128     255     112   20234   1.69
    256     511      82   30446   2.54
    512    1023      36   26021   2.17
   1024    2047      20   29074   2.43
   2048    4095       5   13499   1.13
   4096    8191       2    9550   0.80
   8192   16383       1   14484   1.21
  16384   32767       2   50101   4.19
  65536  131071       1   68649   5.74
 524288 1048575       1  874663  73.11
total free extents 2636
total free blocks 1196409
average free extent size 453.873

--D

> IIRC, it's the per-ag histograms that are more important here
> because we are running out of space in an AG because of
> overcommitting the per-ag space. If there is an AG that is much more
> fragmented than others, then it will be consuming much more in way
> of freespace btree blocks than others...
> 
> FWIW, if you are using reflink heavily and you have rmap enabled (as
> you have), there's every chance that an AG has completely run out of
> space and so new rmap records for shared extents can't be allocated
> - that can give you spurious ENOSPC errors before the filesystem is
> 100% full, too.
> 
> i.e. every shared extent in the filesystem has a rmap record
> pointing back to each owner of the shared extent. That means for an
> extent shared 1000 times, there are 1000 rmap records for that
> shared extent. If you share it again, a new rmap record needs to be
> inserted into the rmapbt, and if the AG is completely out of space
> this can fail w/ ENOSPC. Hence you can get ENOSPC errors attempting
> to shared or unshare extents because there isn't space in the AG for
> the tracking metadata for the new extent record....
> 
> > $ sudo xfs_db -r -c 'freesp -s' /dev/mapper/vg00-chroot
> >    from      to extents  blocks    pct
> >       1       1   74943   74943   0.00
> >       2       3   71266  179032   0.01
> >       4       7  155670  855072   0.04
> >       8      15  304838 3512336   0.17
> >      16      31  613606 14459417   0.72
> >      32      63 1043230 47413004   2.35
> >      64     127 1130921 106646418   5.29
> >     128     255 1043683 188291054   9.34
> >     256     511  576818 200011819   9.93
> >     512    1023  328790 230908212  11.46
> >    1024    2047  194784 276975084  13.75
> >    2048    4095  119242 341977975  16.97
> >    4096    8191   72903 406955899  20.20    8192   16383    5991 67763286
> > 3.36
> >   16384   32767    1431 31354803   1.56
> >   32768   65535     310 14366959   0.71   65536  131071     122 10838153
> > 0.54  131072  262143      87 15901152   0.79
> >  262144  524287      44 17822179   0.88
> >  524288 1048575      16 12482310   0.62
> > 1048576 2097151      14 20897049   1.04
> > 4194304 8388607       1 5213142   0.26
> > total free extents 5738710
> > total free blocks 2014899298
> > average free extent size 351.107
> 
> So 5.7M freespace records. Assume perfect packing an thats roughly
> 500 records to a btree block so at least 10,000 freespace btree
> blocks in the filesytem. But we really need to see the per-ag
> histograms to be able to make any meaningful analysis of the free
> space layout in the filesystem....
> 
> > Or from:
> > 
> > How to tell how fragmented the free space is on an XFS filesystem?
> > https://www.suse.com/support/kb/doc/?id=000018219
> > 
> > Based on xfs_info "agcount=32":
> > 
> > $ {
> >   for AGNO in {0..31}; do
> >     sudo /usr/sbin/xfs_db -r -c "freesp -s -a $AGNO" /dev/mapper/vg00-chroot > /tmp/ag${AGNO}.txt
> >   done
> >   grep -h '^average free extent size' /tmp/ag*.txt | sort -k5n | head -n5
> >   echo --
> >   grep -h '^average free extent size' /tmp/ag*.txt | sort -k5n | tail -n5
> > }
> > average free extent size 66.7806
> 
> Average size by itself isn't actually useful for analysis. The
> histogram is what gives us all the necessary information. e.g. this
> could be a thousand single block extents and one 65000 block extent
> or it could be a million 64k extents. The former is pretty good, the
> latter is awful (indicates likely worst case 64kB extent
> fragmentation behaviour), because ....
> 
> > Even those ags with the lowest average free extent size are higher than what
> > the web page suggests is "an AG in fairly good shape".
> 
> ... the kb article completely glosses over the fact that we really
> have to consider the histogram those averages are dervied from
> before making a judgement on the state of the AG. It equates
> "average extent size" with "fragmented AG", when in reality there's
> a whole lot more to consider such as number of free extents, the
> size of the AG, the amount of free space being indexed, the nature
> of the workload and the allocations it requires, etc.
> 
> e.g. I'd consider the "AG greatly fragmented" case given in that KB
> article to be perfectly fine if the workload is random 4KB writes
> and hole punching to manage space in sparse files (perhaps, say,
> lots of raw VM image files and guests have -o discard enabled). In
> those cases, there's a huge number of viable allocation candidates
> in the free space that can be found quickly and efficiently as
> there's no possibility of large contiguous extents being formed for
> user data because the IO patterns are small random writes into
> sparse files...
> 
> Context is very important when trying to determine if free space
> fragmentation is an issue or not. Most of the time, it isn't an
> issue at all but people have generally been trained to think "all
> fragmentation is bad" rather than "only worry about fragmentation if
> there is a problem that is directly related to physical allocation
> patterns"...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
