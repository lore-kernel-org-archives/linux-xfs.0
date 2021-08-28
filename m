Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AC3C432BE
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 03:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB65060F44
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 03:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhH1D7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:59:19 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:43001 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1D7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 23:59:16 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 953D261C22;
        Sat, 28 Aug 2021 13:58:24 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 7FiPiu3NTOtI; Sat, 28 Aug 2021 13:58:24 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 6731261BEF;
        Sat, 28 Aug 2021 13:58:24 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 4F405680468; Sat, 28 Aug 2021 13:58:24 +1000 (AEST)
Date:   Sat, 28 Aug 2021 13:58:24 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC [was: XFS fallocate implementation incorrectly
 reports ENOSPC]
Message-ID: <20210828035824.GA3654894@onthe.net.au>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210828002137.GA3642069@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 28, 2021 at 10:21:37AM +1000, Chris Dunlop wrote:
> On Sat, Aug 28, 2021 at 08:03:43AM +1000, Dave Chinner wrote:
>> commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
>> Author: Brian Foster <bfoster@redhat.com>
>> Date:   Wed Apr 28 15:06:05 2021 -0700
>>
>>   xfs: set aside allocation btree blocks from block reservation
>
> Oh wow. Yes, sounds like a candidate. Is there same easy(-ish?) way of 
> seeing if this fs is likely to be suffering from this particular issue 
> or is it a matter of installing an appropriate kernel and seeing if 
> the problem goes away?

Is this sufficient to tell us that this filesystem probably isn't suffering 
from that issue?

$ sudo xfs_db -r -c 'freesp -s' /dev/mapper/vg00-chroot
    from      to extents  blocks    pct
       1       1   74943   74943   0.00
       2       3   71266  179032   0.01
       4       7  155670  855072   0.04
       8      15  304838 3512336   0.17
      16      31  613606 14459417   0.72
      32      63 1043230 47413004   2.35
      64     127 1130921 106646418   5.29
     128     255 1043683 188291054   9.34
     256     511  576818 200011819   9.93
     512    1023  328790 230908212  11.46
    1024    2047  194784 276975084  13.75
    2048    4095  119242 341977975  16.97
    4096    8191   72903 406955899  20.20 
    8192   16383    5991 67763286   3.36
   16384   32767    1431 31354803   1.56
   32768   65535     310 14366959   0.71 
   65536  131071     122 10838153   0.54 
  131072  262143      87 15901152   0.79
  262144  524287      44 17822179   0.88
  524288 1048575      16 12482310   0.62
1048576 2097151      14 20897049   1.04
4194304 8388607       1 5213142   0.26
total free extents 5738710
total free blocks 2014899298
average free extent size 351.107

Or from:

How to tell how fragmented the free space is on an XFS filesystem?
https://www.suse.com/support/kb/doc/?id=000018219

Based on xfs_info "agcount=32":

$ {
   for AGNO in {0..31}; do
     sudo /usr/sbin/xfs_db -r -c "freesp -s -a $AGNO" /dev/mapper/vg00-chroot > /tmp/ag${AGNO}.txt
   done
   grep -h '^average free extent size' /tmp/ag*.txt | sort -k5n | head -n5
   echo --
   grep -h '^average free extent size' /tmp/ag*.txt | sort -k5n | tail -n5
}
average free extent size 66.7806
average free extent size 79.201
average free extent size 80.221
average free extent size 87.595
average free extent size 103.079
--
average free extent size 898.962
average free extent size 906.709
average free extent size 1001.18
average free extent size 1849.23
average free extent size 2782.75

Even those ags with the lowest average free extent size are higher than what 
the web page suggests is "an AG in fairly good shape".

Cheers,

Chris
