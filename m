Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E213D3B3
	for <linux-xfs@vger.kernel.org>; Sat,  1 Feb 2025 06:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738391727; cv=none; b=MuGx7WIWcp3AEjl+w9VjKpfJcvEIO3DPEnJJdXWm9GDo+um+LJpBR7FW52GQO3LkZpWObGNWnA2yhtsjBP6UO4a/Oz626AVhg84RU5c4LadYqhCLCtOWZYvf5kiu9NyCywlgnr4QqsiRRaYki72PceRVj/120c8id/K2egoZmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738391727; c=relaxed/simple;
	bh=r8ftWM/hebwS1rJyNrr6lmmsmljV8W9Gfouwud4GxX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1uwPBRQ2AUoQJY9DLUHaMO0SPX8zFvUEIbZrL3HgoRp5iuH/xExHaItmXGvUsYT7qkjOJwPsuqPucNTgs54ASIsl0gien7JW/N8ikVZqb9MsPemyuwURnFUVRwLjH89BVTKwAXBkZYv+TTUzSE9+cChvnJk07YHsyYfKWT4WO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=daXb/+fn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="daXb/+fn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738391723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/07Sljrc5p5soU5Yi/wgGGKKmFfQVh8wEjFVUjgujU=;
	b=daXb/+fnQZf6k3GrhvVIO+upeeccg6jC7+krqz0DsYenQVTUVzXKnj3zMCfMBj9g4ViS/B
	moBvQcGWL0/MYicbpnRfkOX6SBhh61bABtU00bmHTM5htGItRyiiIM+vYZf1WeYP/RFYoJ
	ofxSFgVFEXOalh1q+w19HrmMsmm22Zk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-blGIn450Pmq1do7FBw9Zfg-1; Sat, 01 Feb 2025 01:35:22 -0500
X-MC-Unique: blGIn450Pmq1do7FBw9Zfg-1
X-Mimecast-MFC-AGG-ID: blGIn450Pmq1do7FBw9Zfg
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2166855029eso54541995ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 22:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738391721; x=1738996521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/07Sljrc5p5soU5Yi/wgGGKKmFfQVh8wEjFVUjgujU=;
        b=MQ+E+dPad2jwFGliVCRjTGmHQIKIqTMHkGDqKCY1/f5+G4x/tjI3to2MpBtxSZXqVr
         Kzloy+P+qpLj/WA4qQr/Z5kTeKklUrllnbK4Opr09Y933sO/n9v1ws8uBp/VF5Y/jUVf
         VuMqAM5mnRRY0XgBK0PyKgLFuaZ6VpazEoZaeyHPRj+/8CFA4ZGDlEFsj3tr8ehCFFwB
         BXpHYVbZuNwEHzTcL3FoF9ahHjXkqp6C1G5eN67ue0K95QGFbemE8fmW8SCa3uhbKO9Q
         Fa9opy/48GFoLRNoiWZjCn7IFkqkl5UDCPOF7dD5xl8n0Hp2vCWBykUki35r9dr5CV/b
         /95A==
X-Forwarded-Encrypted: i=1; AJvYcCVHvYfKhguob49p2+GeQcjhGAs2atYprlgRRXFfTn0Vtps/lAlfmfkeFN/XDTk+IdLyFI7qiiFFe3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWgIy2RAEenLGUlugzQxtZNrc6ULUZbb4ckTfDjDYdnf5BcA3Y
	6rN0EofCTwtCSF2o7jCDAPyvM3lgHFYq8mm7VrHJTsJ4AOo7lT1UELtHi8VekS2xc6C6Z0DHJM4
	7MaPjQKu7YqmRjK43YSIrJJ11gUAbEuA29xeHwz9WSqSNyQ8KTh017z+4yGn+N+1K5Z0v
X-Gm-Gg: ASbGncvZXmqRktuGiH9fJYRrZNlQHat4loeekmWVfv2Tdn2D/SOMkdDvNrVU7zfXLIQ
	9WfwtFNrPYK8HMPYd2b5ib5CNpq4R/R81bxJXaz7XCoDCIQrvRwH+jNhpOgrbITMEh9hK0B15Xt
	aFeXxxh5/Qy6Mjwcjvpm8YRMaG/mkSs1WSXpu6elnzdIp5ln8vOW5ZhiQ0j03tggcOdxfiu0VqH
	P4vPh4qpToeiN80b8UHbcwsDjTNlPoLAms3kaer4RlDUdQKm4vqmjL7ELgGWOlkow3jcBPQkEOk
	CRnHG5vRKKYW6I32xh2ewsV/RhcSbTmohGI3Ld63xdXOHw==
X-Received: by 2002:a05:6a21:390:b0:1e0:d4f4:5b2f with SMTP id adf61e73a8af0-1ed7a5efa56mr26755603637.32.1738391720946;
        Fri, 31 Jan 2025 22:35:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEae0ZCjJUk7odBShwtqVjouiVq95TbgVv4Wipu556QipzBPuGHLOrSOmTAJ7HEQceiqo4TtA==
X-Received: by 2002:a05:6a21:390:b0:1e0:d4f4:5b2f with SMTP id adf61e73a8af0-1ed7a5efa56mr26755582637.32.1738391720623;
        Fri, 31 Jan 2025 22:35:20 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe69ba3acsm4256319b3a.111.2025.01.31.22.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 22:35:20 -0800 (PST)
Date: Sat, 1 Feb 2025 14:35:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, zlang@kernel.org
Subject: Re: [PATCH v2] check: Fix fs specfic imports when
 $FSTYPE!=$OLD_FSTYPE
Message-ID: <20250201063516.gndb7lngpd5afatv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <3b980d028a8ae1496c13ebe3a6685fbc472c5bc0.1738040386.git.nirjhar.roy.lists@gmail.com>
 <20250128180917.GA3561257@frogsfrogsfrogs>
 <f89b6b40-8dce-4378-ba56-cf7f29695bdb@gmail.com>
 <20250129160259.GT3557553@frogsfrogsfrogs>
 <dfbd2895-e29a-4e25-bbc6-a83826d14878@gmail.com>
 <20250131162457.GV1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250131162457.GV1611770@frogsfrogsfrogs>

On Fri, Jan 31, 2025 at 08:24:57AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 31, 2025 at 06:49:50PM +0530, Nirjhar Roy (IBM) wrote:
> > 
> > On 1/29/25 21:32, Darrick J. Wong wrote:
> > > On Wed, Jan 29, 2025 at 04:48:10PM +0530, Nirjhar Roy (IBM) wrote:
> > > > On 1/28/25 23:39, Darrick J. Wong wrote:
> > > > > On Tue, Jan 28, 2025 at 05:00:22AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > > Bug Description:
> > > > > > 
> > > > > > _test_mount function is failing with the following error:
> > > > > > ./common/rc: line 4716: _xfs_prepare_for_eio_shutdown: command not found
> > > > > > check: failed to mount /dev/loop0 on /mnt1/test
> > > > > > 
> > > > > > when the second section in local.config file is xfs and the first section
> > > > > > is non-xfs.
> > > > > > 
> > > > > > It can be easily reproduced with the following local.config file
> > > > > > 
> > > > > > [s2]
> > > > > > export FSTYP=ext4
> > > > > > export TEST_DEV=/dev/loop0
> > > > > > export TEST_DIR=/mnt1/test
> > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > 
> > > > > > [s1]
> > > > > > export FSTYP=xfs
> > > > > > export TEST_DEV=/dev/loop0
> > > > > > export TEST_DIR=/mnt1/test
> > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > 
> > > > > > ./check selftest/001
> > > > > > 
> > > > > > Root cause:
> > > > > > When _test_mount() is executed for the second section, the FSTYPE has
> > > > > > already changed but the new fs specific common/$FSTYP has not yet
> > > > > > been done. Hence _xfs_prepare_for_eio_shutdown() is not found and
> > > > > > the test run fails.
> > > > > > 
> > > > > > Fix:
> > > > > > Remove the additional _test_mount in check file just before ". commom/rc"
> > > > > > since ". commom/rc" is already sourcing fs specific imports and doing a
> > > > > > _test_mount.
> > > > > > 
> > > > > > Fixes: 1a49022fab9b4 ("fstests: always use fail-at-unmount semantics for XFS")
> > > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > > > ---
> > > > > >    check | 12 +++---------
> > > > > >    1 file changed, 3 insertions(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/check b/check
> > > > > > index 607d2456..5cb4e7eb 100755
> > > > > > --- a/check
> > > > > > +++ b/check
> > > > > > @@ -784,15 +784,9 @@ function run_section()
> > > > > >    			status=1
> > > > > >    			exit
> > > > > >    		fi
> > > > > > -		if ! _test_mount
> > > > > Don't we want to _test_mount the newly created filesystem still?  But
> > > > > perhaps after sourcing common/rc ?
> > > > > 
> > > > > --D
> > > > common/rc calls init_rc() in the end and init_rc() already does a
> > > > _test_mount. _test_mount after sourcing common/rc will fail, won't it? Does
> > > > that make sense?
> > > > 
> > > > init_rc()
> > > > {
> > > >      # make some further configuration checks here
> > > >      if [ "$TEST_DEV" = ""  ]
> > > >      then
> > > >          echo "common/rc: Error: \$TEST_DEV is not set"
> > > >          exit 1
> > > >      fi
> > > > 
> > > >      # if $TEST_DEV is not mounted, mount it now as XFS
> > > >      if [ -z "`_fs_type $TEST_DEV`" ]
> > > >      then
> > > >          # $TEST_DEV is not mounted
> > > >          if ! _test_mount
> > > >          then
> > > >              echo "common/rc: retrying test device mount with external set"
> > > >              [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
> > > >              if ! _test_mount
> > > >              then
> > > >                  echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
> > > >                  exit 1
> > > >              fi
> > > >          fi
> > > >      fi
> > > > ...
> > > ahahahaha yes it does.
> > > 
> > > /commit message reading comprehension fail, sorry about that.
> > > 
> > > Though now that you point it out, should check elide the init_rc call
> > > about 12 lines down if it re-sourced common/rc ?
> > 
> > Yes, it should. init_rc() is getting called twice when common/rc is getting
> > re-sourced. Maybe I can do like
> > 
> > 
> > if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
> > 
> >     <...>
> > 
> >     . common/rc # changes in this patch
> > 
> >     <...>
> > 
> > elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > 
> >     ...
> > 
> >     init_rc() # explicitly adding an init_rc() for this condition
> > 
> > else
> > 
> >     init_rc() # # explicitly adding an init_rc() for all other conditions.
> > This will prevent init_rc() from getting called twice during re-sourcing
> > common/rc
> > 
> > fi
> > 
> > What do you think?
> 
> Sounds fine as a mechanical change, but I wonder, should calling init_rc
> be explicit?  There are not so many places that source common/rc:
> 
> $ git grep 'common/rc'
> check:362:if ! . ./common/rc; then
> check:836:              . common/rc
> common/preamble:52:     . ./common/rc
> soak:7:. ./common/rc
> tests/generic/749:18:. ./common/rc
> 
> (I filtered out the non-executable matches)
> 
> I think the call in generic/749 is unnecessary and I don't know what
> soak does.  But that means that one could insert an explicit call to
> init_rc at line 366 and 837 in check and at line 53 in common/preamble,
> and we can clean up one more of those places where sourcing a common/
> file actually /does/ something quietly under the covers.
> 
> (Unless the maintainer is ok with the status quo...?)

I think people just hope to import the helpers in common/rc mostly, don't
want to run init_rc again. Maybe we can make sure the init_rc is only run
once each time?

E.g.

  if [ _INIT_RC != "done" ];then
	init_rc
	_INIT_RC="done"
  fi

Or any better idea.

Thanks,
Zorro

> 
> --D
> 
> > 
> > > 
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > 
> > > --D
> > > 
> > > > ...
> > > > 
> > > > --NR
> > > > 
> > > > 
> > > > 
> > > > > > -		then
> > > > > > -			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
> > > > > > -			status=1
> > > > > > -			exit
> > > > > > -		fi
> > > > > > -		# TEST_DEV has been recreated, previous FSTYP derived from
> > > > > > -		# TEST_DEV could be changed, source common/rc again with
> > > > > > -		# correct FSTYP to get FSTYP specific configs, e.g. common/xfs
> > > > > > +		# Previous FSTYP derived from TEST_DEV could be changed, source
> > > > > > +		# common/rc again with correct FSTYP to get FSTYP specific configs,
> > > > > > +		# e.g. common/xfs
> > > > > >    		. common/rc
> > > > > >    		_prepare_test_list
> > > > > >    	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > > > > > -- 
> > > > > > 2.34.1
> > > > > > 
> > > > > > 
> > > > -- 
> > > > Nirjhar Roy
> > > > Linux Kernel Developer
> > > > IBM, Bangalore
> > > > 
> > -- 
> > Nirjhar Roy
> > Linux Kernel Developer
> > IBM, Bangalore
> > 
> > 
> 

