Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395B2C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 05:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiHDFhT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 01:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiHDFhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 01:37:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587B44D4F5;
        Wed,  3 Aug 2022 22:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B64CB82490;
        Thu,  4 Aug 2022 05:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D79C433C1;
        Thu,  4 Aug 2022 05:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659591433;
        bh=OLTXgDNxkUUH1IRA/1/dTaDpagJ9+qnj5TnxAOsQ3PA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AWULd3MMqpCy5CUnY+w6GclJvvt16DOUr0yD2C5Y+b6yzYhArYjw3OUcpLA3G7mXG
         wv1CoZVxRI0tW2h8+6LoxuJ003ngY/sLn1okBR1blpwidGinfhxtx75zbjMT4fi8S+
         C+D9w/V6Oa38+cIRpdo5t+wcK2Vbyira/U5zk+fJoZrm8c/ctkaMVj8UOuDTNXxg/X
         5kP3qC35GYiQxF8uuGfefFuNQEM2yY0Kd+StnSMVKgtwduktFqMkUIPoNVa0wZhqK/
         Am+2bb9EKLXUNJOVetnV/C0IZEYFwooevPysJ6a/7lnAw6xbAlGtj35RvPM9hCSjFK
         YXzcF6nuxgkUw==
Date:   Wed, 3 Aug 2022 22:37:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 3/3] xfs/533: fix golden output for this test
Message-ID: <YutbCTah6t8i6VUy@magnolia>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950049724.198815.5496412458825635633.stgit@magnolia>
 <4094bf3b-9be0-c629-648a-b78999e3ec83@fujitsu.com>
 <YutTyPjPlKp3icSz@magnolia>
 <YutV4sN+C4GZ5Yq6@magnolia>
 <ca9c2726-56d4-16c0-cdcb-e7dc93df43c6@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9c2726-56d4-16c0-cdcb-e7dc93df43c6@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 05:31:01AM +0000, xuyang2018.jy@fujitsu.com wrote:
> 
> 
> on  2022/08/04 13:15, Darrick J. Wong wrote:
> > On Wed, Aug 03, 2022 at 10:06:16PM -0700, Darrick J. Wong wrote:
> >> On Thu, Aug 04, 2022 at 01:53:31AM +0000, xuyang2018.jy@fujitsu.com wrote:
> >>> on 2022/08/03 12:21, Darrick J. Wong wrote:
> >>>> From: Darrick J. Wong <djwong@kernel.org>
> >>>>
> >>>> Not sure what's up with this new test, but the golden output isn't right
> >>>> for upstream xfsprogs for-next.  Change it to pass there...
> >>>
> >>> It failed becuase libxfs code validates v5 feature fields.
> >>>
> >>> b12d5ae5d ("xfs: validate v5 feature fields")
> >>>>
> >>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >>>> ---
> >>>>    tests/xfs/533.out |    2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>>
> >>>> diff --git a/tests/xfs/533.out b/tests/xfs/533.out
> >>>> index 7deb78a3..439fb16e 100644
> >>>> --- a/tests/xfs/533.out
> >>>> +++ b/tests/xfs/533.out
> >>>> @@ -1,5 +1,5 @@
> >>>>    QA output created by 533
> >>>>    Allowing write of corrupted data with good CRC
> >>>>    magicnum = 0
> >>>> -bad magic number
> >>
> >> Ohhh, so this is a V4 output.
> >>
> >>>> +Superblock has bad magic number 0x0. Not an XFS filesystem?
> >>>
> >>> Since this case is designed to detect xfs_db bug, should we filter the
> >>> output?
> >>
> >> Yep.  I'll rework this patch to handle V4 and V5.  Well, thanks for
> >> keeping me on my toes! ;)
> > 
> > Hmm, V4 produces this:
> > 
> > --- /tmp/fstests/tests/xfs/533.out      2022-08-02 19:02:12.876335795 -0700
> > +++ /var/tmp/fstests/xfs/533.out.bad    2022-08-03 22:12:43.596000000 -0700
> > @@ -1,5 +1,3 @@
> >   QA output created by 533
> > -Allowing write of corrupted data with good CRC
> >   magicnum = 0
> > -Superblock has bad magic number 0x0. Not an XFS filesystem?
> >   0
> > 
> > So I guess this isn't a V4 output.  Which version of xfsprogs and what
> > MKFS_OPTIONS did you use to make this to produce 'bad magic number'?
> 
> I remember I used xfsprogs master branch and I don't add any special 
> MKFS_OPTIONS.
> 
> meta-data=/dev/sda7              isize=512    agcount=4, agsize=3276800 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>           =                       reflink=1    bigtime=1 inobtcount=1
> data     =                       bsize=4096   blocks=13107200, imaxpct=25
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> local.config
> MODULAR=0
> export TEST_DIR=/mnt/xfstests/test
> export TEST_DEV=/dev/sda6
> export SCRATCH_MNT=/mnt/xfstests/scratch
> export SCRATCH_DEV=/dev/sda7
> 
> I have mentioned that xfsprogs commit b12d5ae5d ("xfs: validate v5 
> feature fields")  will change output to "-Superblock has bad magic 
> number 0x0. Not an XFS filesystem". And this commit is belong to 
> for-next branch that is why I write this case doesn't find this because 
> I use master branch that time.

Ah, sorry, I missed your mention of this commit.  Ok, so the test was
based on master (aka xfsprogs 5.18) and my corrections are based on
for-next (future xfsprogs 5.19).

Yes, I think the correct fix here is to filter the new output to match
the old.  I might throw in a _require_scratch_xfs_crc so this test
doesn't fail on (deprecated) V4 setups.

--D

> Best Regards
> Yang Xu
> > 
> > --D
> > 
> >> --D
> >>
> >>> Best Regards
> >>> Yang Xu
> >>>>    0
> >>>>
