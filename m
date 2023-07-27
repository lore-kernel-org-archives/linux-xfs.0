Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44C5C00528
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 03:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjG0DGY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 23:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjG0DGX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 23:06:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1D2704
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 20:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690427137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IV5Fuz0exrsayUcAWrvryTIsZ8I3MNRA+ruSJGh8Zr4=;
        b=WsHmeXEcnoqfECuR740+0IoA2nq2967iPsihTuK5sY71tIGRnOw1If0WcY4lGju366hIbG
        /wL1/BMeESq6+fkYK4RROntHp9VkkCyTfv8ACZ4SwlrG36db9XKME8wirCpEj9mZLddSBD
        KEy2fhWYzIv2nAyR2MX/eoUTOjuR190=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-rzwhOmjWMJW2H-iWAMkJ1A-1; Wed, 26 Jul 2023 23:05:35 -0400
X-MC-Unique: rzwhOmjWMJW2H-iWAMkJ1A-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76c562323fbso74925485a.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 20:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690427135; x=1691031935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IV5Fuz0exrsayUcAWrvryTIsZ8I3MNRA+ruSJGh8Zr4=;
        b=jDanhLC4K7Qv3p3WmvrSTNVtOd0uEyZuvPmxsjclY/MABZM6oXXzmRidzWNCpWauKb
         YlJCgrGqZio3tLuQkWMhWRvtaeLLuRWGCCAg0MlVDexyRowerJLj/ywRA1UMzN1QrDpA
         ALSFb172d4l3CsAVzl8DAdAcy5tngV4n7VKnNXjXriIkZ0Dxnv/tmW3bPXsI24+MAU3Z
         mTYyBHOTPIe7Z4LGikyvaMEABXxiDhFbt/rgzsraIDm0Nq3NME/YOQ3vrI6noucKixfv
         QWOmNExKW7Kg4WaxR4wE8Q7tv6+Gd8tWpQd5BKuxc877kBgg2Hld3T3KRpHz34ca+OEi
         U7jw==
X-Gm-Message-State: ABy/qLbiZe865lwYxeIvhYn9e1Msdy3A0Z4zevDJcf6c4HAqHDtS5UWt
        UbAe0e58J56EHI553yWGtCEoomkI9cUNcU34OU06yk5E1yYiK4HCoD/ZY9/uGBRRcffxpM2WZXb
        eUQppUde5dLLw6cIXXUsd
X-Received: by 2002:a05:620a:25d2:b0:765:7957:1aff with SMTP id y18-20020a05620a25d200b0076579571affmr4332452qko.74.1690427134831;
        Wed, 26 Jul 2023 20:05:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFaFxvs4/OpJgBv+vgayUqAGtDhJATx28JVvUI0sAXr7SGdwvHoS6g9g+BuLEw8pUhpCJtfGA==
X-Received: by 2002:a05:620a:25d2:b0:765:7957:1aff with SMTP id y18-20020a05620a25d200b0076579571affmr4332434qko.74.1690427134520;
        Wed, 26 Jul 2023 20:05:34 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k5-20020aa78205000000b00682a0184742sm312309pfi.148.2023.07.26.20.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 20:05:34 -0700 (PDT)
Date:   Thu, 27 Jul 2023 11:05:29 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: provides smoketest template
Message-ID: <20230727030529.r4ivp6dmtrht5zo2@zlang-mailbox>
References: <20230726200327.239085-1-zlang@kernel.org>
 <20230727015148.GI11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727015148.GI11340@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 06:51:48PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 27, 2023 at 04:03:27AM +0800, Zorro Lang wrote:
> > Darrick suggests that fstests can provide a simple smoketest, by running
> > several generic filesystem smoke testing for five minutes apiece. Since
> > there are only five smoke tests, this is effectively a 16min super-quick
> > test.
> > 
> > With gcov enabled, running these tests yields about ~75% coverage for
> > iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
> > btrfs.  Coverage was about ~65% for the pagecache.
> > 
> > To implement that, this patch add a new "-t" option to ./check, and a
> > new directory "template" under xfstests/, then we can have smoketest
> > template, also can have more other testing templates.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > This patch uses another way to achieve the smoketest requirement[1]. When
> > I reviewed the patch from Darrick [2], I thought "smoketest" might not be
> > the last one requirement likes that. I don't want to give each kind of
> > tests a separated option. But we might can leave a hook for more fs-devel
> > who have good testing templates for fstests.
> > 
> > Although we have test groups, but those group names are too complex for
> > the users who not always use fstests. So I'm thinking about providing
> > some simple templates to run fstests, these templates base on test groups
> > and some fstests global parameters, help users to know what kind of
> > test they can do.
> > 
> > Feel free to discuss, and if most of you prefer the original patch [2],
> > I'll also think about merging the original one :)
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > https://lore.kernel.org/fstests/20230726145441.lbzzokwigrztimyq@zlang-mailbox/T/#mabc0de98699f1b877c87caccb13809c9283c0606
> > [2]
> > https://lore.kernel.org/fstests/169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs/T/#u
> > 
> > 
> >  check               |  8 ++++++++
> >  doc/group-names.txt |  1 +
> >  templates/smoketest | 16 ++++++++++++++++
> >  tests/generic/475   |  2 +-
> >  tests/generic/476   |  2 +-
> >  tests/generic/521   |  2 +-
> >  tests/generic/522   |  2 +-
> >  tests/generic/642   |  2 +-
> >  8 files changed, 30 insertions(+), 5 deletions(-)
> >  create mode 100644 templates/smoketest
> > 
> > diff --git a/check b/check
> > index 89e7e7bf..7100aae4 100755
> > --- a/check
> > +++ b/check
> > @@ -335,6 +335,14 @@ while [ $# -gt 0 ]; do
> >  		;;
> >  	-i)	iterations=$2; shift ;;
> >  	-I) 	iterations=$2; istop=true; shift ;;
> > +	-t)
> > +		source templates/$2
> > +		if [ $? -ne 0 ];then
> > +			echo "Cannot import the templates/$2"
> > +			exit 1
> > +		fi
> > +		shift
> > +		;;
> >  	-T)	timestamp=true ;;
> >  	-d)	DUMP_OUTPUT=true ;;
> >  	-b)	brief_test_summary=true;;
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index 1c35a394..c3dcca37 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -118,6 +118,7 @@ selftest		tests with fixed results, used to validate testing setup
> >  send			btrfs send/receive
> >  shrinkfs		decreasing the size of a filesystem
> >  shutdown		FS_IOC_SHUTDOWN ioctl
> > +smoketest		Simple smoke tests
> >  snapshot		btrfs snapshots
> >  soak			long running soak tests whose runtime can be controlled
> >                          directly by setting the SOAK_DURATION variable
> > diff --git a/templates/smoketest b/templates/smoketest
> > new file mode 100644
> > index 00000000..40a0104b
> > --- /dev/null
> > +++ b/templates/smoketest
> > @@ -0,0 +1,16 @@
> > +##/bin/bash
> > +# For infrequent filesystem developers who simply want to run a quick test
> > +# of the most commonly used filesystem functionality, use this command:
> > +#
> > +#     ./check -t smoketest <other config options>
> > +#
> > +# This template helps fstests to run several tests to exercise the file I/O,
> > +# metadata, and crash recovery exercisers for four minutes apiece.  This
> > +# should complete in approximately 20 minutes.
> > +
> > +echo "**********************"
> > +echo "* A Quick Smoke Test *"
> > +echo "**********************"
> > +
> > +[ -z "$SOAK_DURATION" ] && SOAK_DURATION="4m"
> > +GROUP_LIST="smoketest"
> 
> Why not simply put
> 
> SOAK_DURATION=4m
> GROUP_LIST=smoketest
> 
> in configs/smoketest.config and tell people to run
> 
> HOST_OPTIONS=configs/smoketest.config ./check
> 
> ?

Hmm... I think if replace the HOST_OPTIONS, we need to write all TEST_DEV,
TEST_DIR, SCRATCH_DEV .... into the new HOST_OPTIONS to, to replace the default
local.config :

# HOST_OPTIONS=templates/smoketest ./check
Warning: need to define parameters for host hp-dl380pg8-01
       or set variables:
        TEST_DIR TEST_DEV

We can't provide a common test template with known device names, fs type, and mkfs
or mount options and so on, due to these things are prepared and specified by users.
But we can recommend known test groups and some general parameters.

Thanks,
Zorro



> 
> --D
> 
> > diff --git a/tests/generic/475 b/tests/generic/475
> > index 0cbf5131..ce7fe013 100755
> > --- a/tests/generic/475
> > +++ b/tests/generic/475
> > @@ -12,7 +12,7 @@
> >  # testing efforts.
> >  #
> >  . ./common/preamble
> > -_begin_fstest shutdown auto log metadata eio recoveryloop
> > +_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
> >  
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/476 b/tests/generic/476
> > index 8e93b734..b1ae4df4 100755
> > --- a/tests/generic/476
> > +++ b/tests/generic/476
> > @@ -8,7 +8,7 @@
> >  # bugs in the write path.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto rw long_rw stress soak
> > +_begin_fstest auto rw long_rw stress soak smoketest
> >  
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/521 b/tests/generic/521
> > index 22dd31a8..0956e501 100755
> > --- a/tests/generic/521
> > +++ b/tests/generic/521
> > @@ -7,7 +7,7 @@
> >  # Long-soak directio fsx test
> >  #
> >  . ./common/preamble
> > -_begin_fstest soak long_rw
> > +_begin_fstest soak long_rw smoketest
> >  
> >  # Import common functions.
> >  . ./common/filter
> > diff --git a/tests/generic/522 b/tests/generic/522
> > index f0cbcb24..0e4e6009 100755
> > --- a/tests/generic/522
> > +++ b/tests/generic/522
> > @@ -7,7 +7,7 @@
> >  # Long-soak buffered fsx test
> >  #
> >  . ./common/preamble
> > -_begin_fstest soak long_rw
> > +_begin_fstest soak long_rw smoketest
> >  
> >  # Import common functions.
> >  . ./common/filter
> > diff --git a/tests/generic/642 b/tests/generic/642
> > index eba90903..e6a475a8 100755
> > --- a/tests/generic/642
> > +++ b/tests/generic/642
> > @@ -8,7 +8,7 @@
> >  # bugs in the xattr code.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto soak attr long_rw stress
> > +_begin_fstest auto soak attr long_rw stress smoketest
> >  
> >  _cleanup()
> >  {
> > -- 
> > 2.40.1
> > 
> 

