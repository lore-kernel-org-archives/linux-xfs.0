Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2878C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 16:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiEFQot (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 12:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443842AbiEFQos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 12:44:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05542340FE
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651855261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fZUces+zA6WgdL55pJ8YMk5usBQXjKQqk3NZA43fgs8=;
        b=fj6/Euv2p1ebPi6bjJvFSCTm98CAYhe2Pp06lXgARwaVEqFYhHHfw+vHnVgEelaXT9GUag
        jDckVz8IWahEKitxt2ZLLESPvOJGkTJcG6mTQhUTQeHn3z8dCjGw90D/v+4mCirdsAVROP
        RaOX5xNsvGumDCv6/uql5NZpE58sRmM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-iA3rfIk-Pv6YKQs4V5i6QQ-1; Fri, 06 May 2022 12:40:59 -0400
X-MC-Unique: iA3rfIk-Pv6YKQs4V5i6QQ-1
Received: by mail-qv1-f72.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso6350342qvb.15
        for <linux-xfs@vger.kernel.org>; Fri, 06 May 2022 09:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=fZUces+zA6WgdL55pJ8YMk5usBQXjKQqk3NZA43fgs8=;
        b=Rs4XIjfApvYdkwOu5G527uwkAVah83C9Fj/r5Ai61/yCJnlTuo4QVGBKyKL4jXNnMk
         IDK8WvFLrSLh3FOFN/F171Nbf71mumMaXpcwKp/7Lpiwh6BNK3WchyMzt33zWMtsb7yA
         o5gnv5aCq40H4x7RqXJZP34SMA/Tc4ZR3McCHXYFWZ6hQYBoXeBBBoq8ou+OZMO/Cs7B
         9CCQ2W8oGno9nw+a0x20A+cUAGrEh2aicvInhTr9q0QL6xF8tXLiSG2EYwaZaiQ7ZlCz
         RjaRbkEzTw5vcGBl9M607KvlWfO3H7eGvokb/ZTtcIOZ5MEst2Zddj6lsqB7V5/VURxZ
         msqw==
X-Gm-Message-State: AOAM533qcSkfFgTt4e0vcAQbGtZCCuYI4Tqhpy0q3I+tFdVFkg/+j4R7
        Aye43ezGx7UemlXFPzRdcDABUvUNe79CfepPYq06mLlOgompK/W35tj1+g4/D/zCdpJ+CsrOhFA
        km5M7v8LRmtwzemCxQTiG
X-Received: by 2002:a05:622a:194:b0:2f3:b922:97c6 with SMTP id s20-20020a05622a019400b002f3b92297c6mr3627246qtw.116.1651855258658;
        Fri, 06 May 2022 09:40:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiByRDKoH+epHwt3XKxZjJxJG1MwDcgaM+wRl31pPBwrgGlZCTJ4hpy7i3HxIAtNeYCaCkjQ==
X-Received: by 2002:a05:622a:194:b0:2f3:b922:97c6 with SMTP id s20-20020a05622a019400b002f3b92297c6mr3627221qtw.116.1651855258311;
        Fri, 06 May 2022 09:40:58 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x13-20020ac86b4d000000b002f39b99f69asm2825250qts.52.2022.05.06.09.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 09:40:57 -0700 (PDT)
Date:   Sat, 7 May 2022 00:40:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/larp: Make test failures debuggable
Message-ID: <20220506164051.pjccaapyytnt4iic@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
 <20220506075141.GH1949718@dread.disaster.area>
 <20220506161442.GP27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506161442.GP27195@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 09:14:42AM -0700, Darrick J. Wong wrote:
> On Fri, May 06, 2022 at 05:51:41PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Md5sum output for attributes created combined program output and
> > attribute values. This adds variable path names to the md5sum, so
> > there's no way to tell if the md5sum is actually correct for the
> > given attribute value that is returned as it's not constant from
> > test to test. Hence we can't actually say that the output is correct
> > because we can't reproduce exactly what we are hashing easily.
> > 
> > Indeed, the last attr test in series (node w/ replace) had an
> > invalid md5sum. The attr value being produced after recovery was
> > correct, but the md5sum output match was failing. Golden output
> > appears to be wrong.
> > 
> > Fix this issue by seperately dumping all the attributes on the inode
> > via a list operation to indicate their size, then dump the value of
> > the test attribute directly to md5sum. This means the md5sum for
> > the attributes using the same fixed values are all identical, so
> > it's easy to tell if the md5sum for a given test is correct. We also
> > check that all attributes that should be present after recovery are
> > still there (e.g. checks recovery didn't trash innocent bystanders).
> > 
> > Further, the attribute replace tests replace an attribute with an
> > identical value, hence there is no way to tell if recovery has
> > resulted in the original being left behind or the new attribute
> > being fully recovered because both have the same name and value.
> > When replacing the attribute value, use a different sized value so
> > it is trivial to determine that we've recovered the new attribute
> > value correctly.
> > 
> > Also, the test runs on the scratch device - there is no need to
> > remove the testdir in _cleanup. Doing so prevents post-mortem
> > failure analysis because it burns the dead, broken corpse to ash and
> > leaves no way of to determine cause of death.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> > 
> > Hi Catherine,
> > 
> > These are all the mods I needed to make to be able to understand the
> > test failures I was getting as I debugged the new LARP recovery
> > algorithm I've written.  You'll need to massage the test number in
> > this patch to apply it on top of your patch.
> > 
> > I haven't added any new test cases yet, nor have I done anything to
> > manage the larp sysfs knob, but we'll need to do those in the near
> > future.
> > 
> > Zorro, can you consider merging this test in the near future?  We're
> > right at the point of merging the upstream kernel code and so really
> > need to start growing the test coverage of this feature, and this
> > test should simply not-run on kernels that don't have the feature
> > enabled....
> > 
> > Cheers,
> > 
> > Dave.
> > ---
> > 
> >  tests/xfs/600     |  20 +++++-----
> >  tests/xfs/600.out | 109 ++++++++++++++++++++++++++++++++++++------------------
> >  2 files changed, 85 insertions(+), 44 deletions(-)
> > 
> > diff --git a/tests/xfs/600 b/tests/xfs/600
> > index 252cdf27..84704646 100755
> > --- a/tests/xfs/600
> > +++ b/tests/xfs/600
> > @@ -16,7 +16,7 @@ _begin_fstest auto quick attr
> >  
> >  _cleanup()
> >  {
> > -	rm -rf $tmp.* $testdir
> > +	rm -rf $tmp.*
> >  	test -w /sys/fs/xfs/debug/larp && \
> >  		echo 0 > /sys/fs/xfs/debug/larp
> 
> Blergh, this ^^^^^^^^^ is going to need fixing too.
> 
> Please save the old value, then write it back in the _cleanup function.

Ok, I'm going to do that when I merge it, if Catherine wouldn't like to do
more changes in a V8 patch. If this case still need more changes, please tell
me in time, and then it might have to wait the fstests release after next, if
too late.

Thanks,
Zorro

> 
> <slightly ot rant>
> 
> These sysfs knobs are a pain because they all reset to defaults if
> xfs.ko gets cycled.  I know, I know, at least Dave and Ted don't do
> modular kernels and so never see this happen, but I do.  I bet Dave also
> hasn't ever run xfs/434 or xfs/436, which might be why I'm the only one
> seeing dquot leaks with 5.19-next.
> 
> (I might be able to lift the xfs-as-module requirement if "echo 1 >
> /sys/kernel/slab/*/validate" does what I think it might, since all we
> want to do is look for slab leaks, and those tests rmmod/modprobe as a
> brute force way of making the slab debug code check for leaks.)
> 
> In case anyone's wondering, a solution to the knobs getting unset after
> an rmmod/modprobe cycle is to add a file
> /etc/udev/rules.d/99-fstester.rules containing:
> 
> ACTION=="add|change", SUBSYSTEM=="module", DEVPATH=="/module/${module}", RUN+="/bin/sh -c \"echo ${value} > ${knob}\""
> 
> which should be enough to keep LARP turned on.
> 
> <end rant>
> 
> Anyway, since this is a proposed test, I say that with this applied and
> the debug knob bits fixed, the whole thing is
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> >  }
> > @@ -46,7 +46,9 @@ test_attr_replay()
> >  	touch $testfile
> >  
> >  	# Verify attr recovery
> > -	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
> > +	$ATTR_PROG -l $testfile | _filter_scratch
> > +	echo -n "$attr_name: "
> > +	$ATTR_PROG -q -g $attr_name $testfile | md5sum;
> >  
> >  	echo ""
> >  }
> > @@ -157,19 +159,19 @@ create_test_file remote_file2 1 $attr64k
> >  test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
> >  test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
> >  
> > -# replace shortform
> > +# replace shortform with different value
> >  create_test_file sf_file 2 $attr64
> > -test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> > +test_attr_replay sf_file "attr_name2" $attr16 "s" "larp"
> >  
> > -# replace leaf
> > -create_test_file leaf_file 2 $attr1k
> > -test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> > +# replace leaf with different value
> > +create_test_file leaf_file 3 $attr1k
> > +test_attr_replay leaf_file "attr_name2" $attr256 "s" "larp"
> >  
> > -# replace node
> > +# replace node with a different value
> >  create_test_file node_file 1 $attr64k
> >  $ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
> >  		>> $seqres.full
> > -test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> > +test_attr_replay node_file "attr_name2" $attr256 "s" "larp"
> >  
> >  echo "*** done"
> >  status=0
> > diff --git a/tests/xfs/600.out b/tests/xfs/600.out
> > index 96b1d7d9..fe25ea3e 100644
> > --- a/tests/xfs/600.out
> > +++ b/tests/xfs/600.out
> > @@ -4,146 +4,185 @@ QA output created by 600
> >  attr_set: Input/output error
> >  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> > -21d850f99c43cc13abbe34838a8a3c8a  -
> > +Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty_file1
> > +attr_name: cfbe2a33be4601d2b655d099a18378fc  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file1
> > +attr_name: attr_get: No data available
> > +Could not get "attr_name" for /mnt/scratch/testdir/empty_file1
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> > -2ff89c2935debc431745ec791be5421a  -
> > +Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/empty_file2
> > +attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file2
> > +attr_name: attr_get: No data available
> > +Could not get "attr_name" for /mnt/scratch/testdir/empty_file2
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> > -5d24b314242c52176c98ac4bd685da8b  -
> > +Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/empty_file3
> > +attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file3
> > +attr_name: attr_get: No data available
> > +Could not get "attr_name" for /mnt/scratch/testdir/empty_file3
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> > -5a7b559a70d8e92b4f3c6f7158eead08  -
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
> > +Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inline_file1
> > +attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file1
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> > -5717d5e66c70be6bdb00ecbaca0b7749  -
> > +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/inline_file2
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
> > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file2
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> > -5c929964efd1b243aa8cceb6524f4810  -
> > +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/inline_file3
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
> > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> > +Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/inline_file3
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> > -51ccb5cdfc9082060f0f94a8a108fea0  -
> > +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file1
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
> > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/extent_file1
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
> > -8d530bbe852d8bca83b131d5b3e497f5  -
> > +Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
> > +Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> > +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
> > +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
> > -5d77c4d3831a35bcbbd6e7677119ce9a  -
> > +Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
> > +Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> > +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
> > +attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> > -6707ec2431e4dbea20e17da0816520bb  -
> > +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/extent_file4
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
> > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/extent_file4
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> > -767ebca3e4a6d24170857364f2bf2a3c  -
> > +Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/remote_file1
> > +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
> > +attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> >  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> > +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/remote_file1
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> > -fd84ddec89237e6d34a1703639efaebf  -
> > +Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
> > +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
> > +attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
> >  
> >  attr_remove: Input/output error
> >  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> > -attr_get: No data available
> > -Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> > +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
> > +attr_name2: attr_get: No data available
> > +Could not get "attr_name2" for /mnt/scratch/testdir/remote_file2
> >  d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
> >  touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
> > -34aaa49662bafb46c76e377454685071  -
> > +Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_file
> > +Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_file
> > +attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
> >  touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
> > -664e95ec28830ffb367c0950026e0d21  -
> > +Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/leaf_file
> > +Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
> > +Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
> > +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
> >  touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
> > -bb37a78ce26472eeb711e3559933db42  -
> > +Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/node_file
> > +Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/node_file
> > +attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
> >  
> >  *** done
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

