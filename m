Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06DD1D5AA7
	for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2025 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740116868; cv=none; b=IwgfE3g0TgWwcV4J9KzK5RV8c0g9qBeRNurIGCaBIDlibrDcl9btwOKKnNuClK7MsOtDn4Ccn+Ph3XlkBXQBaK12Gh9Y0r9SIlK5TkkNKXprACo2xDutUz65kJ79jVZn+5LTQ91Yh0QltBXcYL1dJREwMGCWdzTCh4tM5chj4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740116868; c=relaxed/simple;
	bh=qu+f+dSN91QApRKg7m2Cev7ImqfQlStn4u4bk5YyROY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+rJ4bCQmaGkX4B0GxXRWUTRdUloDcP01A2o+Jziw/mRTKhEdn6BN+mnBPGIlxrVAcwBDv/wL8bfUGa7Q6S55OToVrRWhs0kCZWZc4H/rfjR7HfZCezKs9dK1ug0kCPr72RZ1AgX7byy2xzpXjgRgipbu6H5lunpcnQg+zSoMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OO5Jm6bo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OO5Jm6bo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740116865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k8T1pjgdjRC78V1JpC8pwsPiEuxf+Efhtq+AnzUXc4s=;
	b=OO5Jm6boVAYWEsoXpNYW6abOcZqClT1dY/BWNbwt6OFANbZfdi/AqMG5qQ04OHECzGiwzf
	AquFJtn7AVPLhzjsHX9b9kwWE0nyPB9Ume1TQf5SfXZOKsbCvwCheIT+QIppkLTLrex58I
	dpgiwh1F9wS+UdlzklNoDL+m5NywCTU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-TUqRc2FmNvW_6knx5_2ZjA-1; Fri, 21 Feb 2025 00:47:44 -0500
X-MC-Unique: TUqRc2FmNvW_6knx5_2ZjA-1
X-Mimecast-MFC-AGG-ID: TUqRc2FmNvW_6knx5_2ZjA_1740116863
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-220d1c24b25so36657015ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 21:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740116863; x=1740721663;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k8T1pjgdjRC78V1JpC8pwsPiEuxf+Efhtq+AnzUXc4s=;
        b=u7rw3+RgNlyy+qMkH+doRaWZVMIsCPE3EKNXhxECJLI9onQBHHPlqpHSfvY3RCIO2T
         9X6K/1Cvv9uRV6LDZQB3edwGtTLUEHmybgnONzY6+U4wUlTG18frhz/eS2ZaEsQBWcLF
         nFU3BY5U8AVsZwjn7QjNPhwfISr7nyapMtKGWJ7o+kLggi758BE4JNVyo9MPnvTqmPLq
         O/EObUQHCT0ixWpABLpH/BW6TeGElOmIz9JD+aAIRtAsQJljWpCDftkM2K7mMZEciD+9
         2cX7K0ox4PJYrLBzdI5jUqDGQuFquEz768uGjUJkebVjjIVrwdi9AyIK4DUd2lD+jWxe
         ROiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEM8XxZd+aKNqeqxGI7MbQ7QqFCOL1sn7/mK7Bw/GBxQ98cF7KizmOqSFSj4dVrIj878BVzlZpCwY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkxGB9ObTY/ii+DVt/suB57nFETufTTI8XvW4Sxokc12o0KRTf
	IWlxMLt76HpfrhooVyXgyTIvC2Rl1o+eMcPK59/IjQan/B/9kHKneZhbr+QT2LHkaJD9jB9x0Mh
	h5pLH09w0keTKQdOMYDz7lChwTVoi5OF8tAbYh8dJVXE2QAiA3naBXJomBQ==
X-Gm-Gg: ASbGncuz4jv8TpUoYPvnTMh19R7tESjPlOmru717+faOFcyceix+vfR8+5sFH+JJIkM
	4RqwfHl0jlkYDZunPbpF+UyDrXVMbvWmmctyURP5AnwQPtriGJnnNN+8enH5GgcwM77i89vvtYD
	UfwBvs3YrzeeDK2rhO+5t3Mkwn9sUt7AbnzdTFY2gjpPjXpULy3RY94ukv0eZj8efGmh/+X8MY1
	kKj2QRX7ilXxwCM9gGXoZl4MZohkq2MqfU7Ubkr3cNcHcGV9uo44o5tKOwQ1wI9Cvv08F1ppUWR
	P0yU0moKMmIBWL7pYC6QZkSjxSnom38azt1pXntbTOGQoOn1N1lRbCMg
X-Received: by 2002:a17:903:22c7:b0:215:19ae:77bf with SMTP id d9443c01a7336-2219ff576afmr32794325ad.19.1740116863100;
        Thu, 20 Feb 2025 21:47:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmjmSo3cnSxkWsLnoM+KrT9hEmwn54kb/85p9breyLix2qt+p+cz5qO4HfraUuN9OOZIBC4Q==
X-Received: by 2002:a17:903:22c7:b0:215:19ae:77bf with SMTP id d9443c01a7336-2219ff576afmr32793995ad.19.1740116862612;
        Thu, 20 Feb 2025 21:47:42 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5585faasm130842615ad.225.2025.02.20.21.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 21:47:42 -0800 (PST)
Date: Fri, 21 Feb 2025 13:47:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, zlang@kernel.org
Subject: Re: [PATCH v2] check: Fix fs specfic imports when
 $FSTYPE!=$OLD_FSTYPE
Message-ID: <20250221054737.owarnxetb34gdicf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <3b980d028a8ae1496c13ebe3a6685fbc472c5bc0.1738040386.git.nirjhar.roy.lists@gmail.com>
 <20250128180917.GA3561257@frogsfrogsfrogs>
 <f89b6b40-8dce-4378-ba56-cf7f29695bdb@gmail.com>
 <20250129160259.GT3557553@frogsfrogsfrogs>
 <dfbd2895-e29a-4e25-bbc6-a83826d14878@gmail.com>
 <20250131162457.GV1611770@frogsfrogsfrogs>
 <20250201063516.gndb7lngpd5afatv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ff6b4e2f-dbd3-479b-a522-a1ae4837b3df@gmail.com>
 <20250210142322.tptpphdntglsz4eq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <b066257d-e32b-4c2e-a213-826ce8923a93@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b066257d-e32b-4c2e-a213-826ce8923a93@gmail.com>

On Fri, Feb 21, 2025 at 09:44:19AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 2/10/25 19:53, Zorro Lang wrote:
> > On Thu, Feb 06, 2025 at 11:32:43PM +0530, Nirjhar Roy (IBM) wrote:
> > > On 2/1/25 12:05, Zorro Lang wrote:
> > > > On Fri, Jan 31, 2025 at 08:24:57AM -0800, Darrick J. Wong wrote:
> > > > > On Fri, Jan 31, 2025 at 06:49:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > > > > On 1/29/25 21:32, Darrick J. Wong wrote:
> > > > > > > On Wed, Jan 29, 2025 at 04:48:10PM +0530, Nirjhar Roy (IBM) wrote:
> > > > > > > > On 1/28/25 23:39, Darrick J. Wong wrote:
> > > > > > > > > On Tue, Jan 28, 2025 at 05:00:22AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > > > > > > Bug Description:
> > > > > > > > > > 
> > > > > > > > > > _test_mount function is failing with the following error:
> > > > > > > > > > ./common/rc: line 4716: _xfs_prepare_for_eio_shutdown: command not found
> > > > > > > > > > check: failed to mount /dev/loop0 on /mnt1/test
> > > > > > > > > > 
> > > > > > > > > > when the second section in local.config file is xfs and the first section
> > > > > > > > > > is non-xfs.
> > > > > > > > > > 
> > > > > > > > > > It can be easily reproduced with the following local.config file
> > > > > > > > > > 
> > > > > > > > > > [s2]
> > > > > > > > > > export FSTYP=ext4
> > > > > > > > > > export TEST_DEV=/dev/loop0
> > > > > > > > > > export TEST_DIR=/mnt1/test
> > > > > > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > > > > > 
> > > > > > > > > > [s1]
> > > > > > > > > > export FSTYP=xfs
> > > > > > > > > > export TEST_DEV=/dev/loop0
> > > > > > > > > > export TEST_DIR=/mnt1/test
> > > > > > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > > > > > 
> > > > > > > > > > ./check selftest/001
> > > > > > > > > > 
> > > > > > > > > > Root cause:
> > > > > > > > > > When _test_mount() is executed for the second section, the FSTYPE has
> > > > > > > > > > already changed but the new fs specific common/$FSTYP has not yet
> > > > > > > > > > been done. Hence _xfs_prepare_for_eio_shutdown() is not found and
> > > > > > > > > > the test run fails.
> > > > > > > > > > 
> > > > > > > > > > Fix:
> > > > > > > > > > Remove the additional _test_mount in check file just before ". commom/rc"
> > > > > > > > > > since ". commom/rc" is already sourcing fs specific imports and doing a
> > > > > > > > > > _test_mount.
> > > > > > > > > > 
> > > > > > > > > > Fixes: 1a49022fab9b4 ("fstests: always use fail-at-unmount semantics for XFS")
> > > > > > > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > > > > > > > ---
> > > > > > > > > >      check | 12 +++---------
> > > > > > > > > >      1 file changed, 3 insertions(+), 9 deletions(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/check b/check
> > > > > > > > > > index 607d2456..5cb4e7eb 100755
> > > > > > > > > > --- a/check
> > > > > > > > > > +++ b/check
> > > > > > > > > > @@ -784,15 +784,9 @@ function run_section()
> > > > > > > > > >      			status=1
> > > > > > > > > >      			exit
> > > > > > > > > >      		fi
> > > > > > > > > > -		if ! _test_mount
> > > > > > > > > Don't we want to _test_mount the newly created filesystem still?  But
> > > > > > > > > perhaps after sourcing common/rc ?
> > > > > > > > > 
> > > > > > > > > --D
> > > > > > > > common/rc calls init_rc() in the end and init_rc() already does a
> > > > > > > > _test_mount. _test_mount after sourcing common/rc will fail, won't it? Does
> > > > > > > > that make sense?
> > > > > > > > 
> > > > > > > > init_rc()
> > > > > > > > {
> > > > > > > >        # make some further configuration checks here
> > > > > > > >        if [ "$TEST_DEV" = ""  ]
> > > > > > > >        then
> > > > > > > >            echo "common/rc: Error: \$TEST_DEV is not set"
> > > > > > > >            exit 1
> > > > > > > >        fi
> > > > > > > > 
> > > > > > > >        # if $TEST_DEV is not mounted, mount it now as XFS
> > > > > > > >        if [ -z "`_fs_type $TEST_DEV`" ]
> > > > > > > >        then
> > > > > > > >            # $TEST_DEV is not mounted
> > > > > > > >            if ! _test_mount
> > > > > > > >            then
> > > > > > > >                echo "common/rc: retrying test device mount with external set"
> > > > > > > >                [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
> > > > > > > >                if ! _test_mount
> > > > > > > >                then
> > > > > > > >                    echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
> > > > > > > >                    exit 1
> > > > > > > >                fi
> > > > > > > >            fi
> > > > > > > >        fi
> > > > > > > > ...
> > > > > > > ahahahaha yes it does.
> > > > > > > 
> > > > > > > /commit message reading comprehension fail, sorry about that.
> > > > > > > 
> > > > > > > Though now that you point it out, should check elide the init_rc call
> > > > > > > about 12 lines down if it re-sourced common/rc ?
> > > > > > Yes, it should. init_rc() is getting called twice when common/rc is getting
> > > > > > re-sourced. Maybe I can do like
> > > > > > 
> > > > > > 
> > > > > > if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
> > > > > > 
> > > > > >       <...>
> > > > > > 
> > > > > >       . common/rc # changes in this patch
> > > > > > 
> > > > > >       <...>
> > > > > > 
> > > > > > elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > > > > > 
> > > > > >       ...
> > > > > > 
> > > > > >       init_rc() # explicitly adding an init_rc() for this condition
> > > > > > 
> > > > > > else
> > > > > > 
> > > > > >       init_rc() # # explicitly adding an init_rc() for all other conditions.
> > > > > > This will prevent init_rc() from getting called twice during re-sourcing
> > > > > > common/rc
> > > > > > 
> > > > > > fi
> > > > > > 
> > > > > > What do you think?
> > > > > Sounds fine as a mechanical change, but I wonder, should calling init_rc
> > > > > be explicit?  There are not so many places that source common/rc:
> > > > > 
> > > > > $ git grep 'common/rc'
> > > > > check:362:if ! . ./common/rc; then
> > > > > check:836:              . common/rc
> > > > > common/preamble:52:     . ./common/rc
> > > > > soak:7:. ./common/rc
> > > > > tests/generic/749:18:. ./common/rc
> > > > > 
> > > > > (I filtered out the non-executable matches)
> > > > > 
> > > > > I think the call in generic/749 is unnecessary and I don't know what
> > > > > soak does.  But that means that one could insert an explicit call to
> > > > > init_rc at line 366 and 837 in check and at line 53 in common/preamble,
> > > > > and we can clean up one more of those places where sourcing a common/
> > > > > file actually /does/ something quietly under the covers.
> > > > > 
> > > > > (Unless the maintainer is ok with the status quo...?)
> > > > I think people just hope to import the helpers in common/rc mostly, don't
> > > > want to run init_rc again. Maybe we can make sure the init_rc is only run
> > > > once each time?
> > > > 
> > > > E.g.
> > > > 
> > > >     if [ _INIT_RC != "done" ];then
> > > > 	init_rc
> > > > 	_INIT_RC="done"
> > > >     fi
> > > > 
> > > > Or any better idea.
> > > Yes, this idea looks good too. However, after thinking a bit more, I like
> > > Darrick's idea to remove the call to init_rc from common/rc and explicitly
> > > calling them explicitly whenever necessary makes more sense. This also makes
> > > the interface/reason to source common/rc more meaningful, and also not
> > > making common/rc do something via init_rc silently. What do you think?
> > Sorry I'm on a travel, reply you late. I don't like to run codes in include
> > files either :) If we remove the init_rc calling from common/rc we might
> > need to do 2 things:
> > 1) xfstests/check needs to run init_rc, calls it in check properly.
> > 2) Now each sub-cases run init_rc when they import common/rc, I think
> > we can call init_rc in common/preamble:_begin_fstest().
> 
> Sorry for my delayed reply, I got caught up with some other work items.
> Thank you for your above suggestions. Let me go through them, look for some
> edge cases and I can come up with a patch after some proper testing.

No problem :) I just suggested, but the thing is we must figure out which
". common/rc" hopes to run init_rc, and which not :) Thanks for looking
into it and test it.

> 
> Regards,
> 
> --NR
> 
> > 
> > If I miss other things, please feel free to remind me:)
> > 
> > Thanks,
> > Zorro
> > 
> > > --NR
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > --D
> > > > > 
> > > > > > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > ...
> > > > > > > > 
> > > > > > > > --NR
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > > > -		then
> > > > > > > > > > -			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
> > > > > > > > > > -			status=1
> > > > > > > > > > -			exit
> > > > > > > > > > -		fi
> > > > > > > > > > -		# TEST_DEV has been recreated, previous FSTYP derived from
> > > > > > > > > > -		# TEST_DEV could be changed, source common/rc again with
> > > > > > > > > > -		# correct FSTYP to get FSTYP specific configs, e.g. common/xfs
> > > > > > > > > > +		# Previous FSTYP derived from TEST_DEV could be changed, source
> > > > > > > > > > +		# common/rc again with correct FSTYP to get FSTYP specific configs,
> > > > > > > > > > +		# e.g. common/xfs
> > > > > > > > > >      		. common/rc
> > > > > > > > > >      		_prepare_test_list
> > > > > > > > > >      	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > > > > > > > > > -- 
> > > > > > > > > > 2.34.1
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > -- 
> > > > > > > > Nirjhar Roy
> > > > > > > > Linux Kernel Developer
> > > > > > > > IBM, Bangalore
> > > > > > > > 
> > > > > > -- 
> > > > > > Nirjhar Roy
> > > > > > Linux Kernel Developer
> > > > > > IBM, Bangalore
> > > > > > 
> > > > > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 

