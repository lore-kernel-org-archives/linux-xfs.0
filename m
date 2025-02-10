Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5582528EB
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739197413; cv=none; b=jfMMqximBQnJeBIInVBvZxr74HeMvMe7hCwTeGOdTeD2Gn9kpxkwMMMbgnrUUjj4khq+ChH65Wc4BIc+rdzWjfG9u5VBhaFzcRMHWPg2yxw5k3W9yn9oDbIgUDIHc2yLAhcAZsyx/1fAg/sA8n2HObt0Ng8NLe+tD6NefSl0VEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739197413; c=relaxed/simple;
	bh=1Z2zsOiXE6O6GTVKoPdKuaAm5SnVWXvJtZUpZHd1K+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbbKD3P2Ckhmujba82+hNDHLtMfkskxzPbM9nSQG+oCuwbe5iF6FjhyAnj4kh1MXrobiK8EjHrlCMfRYY63sm55d7EaOCYiBTlLWIHUxAEPd4XkJhIJQmLSfqupl6DuoM0WNAK7mRptYIuGTBPH3epVaAllqfAkgjGCRftfL8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ESTCh4p7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESTCh4p7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739197410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGzuxbEMQPiuowHPxJeA1JII8eG7zdJNZMUo+iSTSnA=;
	b=ESTCh4p7uVccIhiBRnQ5/CWTdP/zeMaIS6iUDLN3nrBJOxrpio7N4oI9N7ebEHfIc7NMfS
	i1v/BTzQJUtCePk5o+pTLHOLWMj2I6rwtnv0xfX7o9vSSRLqQ3NeGl0qggqtngDOpcLcZS
	6285viRRtBTPybjoRWwbyTNaXId5VUE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-KAChHNpbOwqRhxd69u2BYQ-1; Mon, 10 Feb 2025 09:23:29 -0500
X-MC-Unique: KAChHNpbOwqRhxd69u2BYQ-1
X-Mimecast-MFC-AGG-ID: KAChHNpbOwqRhxd69u2BYQ
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fa636e5283so2721183a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 06:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739197407; x=1739802207;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xGzuxbEMQPiuowHPxJeA1JII8eG7zdJNZMUo+iSTSnA=;
        b=dGWKjYGGCb/qAguDMdm21JfFSMrWdPLREYVEE3cST+FLDnX1CO7Qn6r8NuSfdPlvs9
         Jv8KADP7A9LJL4d5Is/vTgZ1/PAfI6LqqrFDlkVUim3T3f1a3CnCUV999Ylg8CFIS8nE
         zJT+erGIvGTdbbFWOmru39VFUmOpqbzh2hjlcSIFLssZh6qUKWsLxw+tJ4ftijrqYtWG
         0L33k3RhCXrhqzWU+najfuZw0Smno5t7gZIGkrNAf/jNpx0ODgaBHFbego6LkuFmv9TH
         fajWONVZxUAoBDmD+fYrTPRiXhAuSMpOPh75yAmiPxIg3MDp9KKpsN7vP3BV9xEqATdA
         cxgw==
X-Forwarded-Encrypted: i=1; AJvYcCVu2e2t7HUVXStVSVC/jzBBK1qirnp3dNSALiNh6VIulT2Fgt+QM9OlYJw72BHgvZ+ONRKMcyrujSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZAT07OGzvl+lZf0We8pfOm3EwfCPv3YaO8HshbwFfS8EmXYzs
	ww+ushnpY1IdBzmABafo+6zw/Lk3CV31RzNYhji3/ZO6kNTv4DQZZzuoGSVXGpoT8Tp6xk6/Gtr
	eIuqVGPqNoa3UDKcmC/pQidniAuU6CYLYuqNrAHOnsCRxERwrm1fsqI1zYA==
X-Gm-Gg: ASbGncsNjG5s64psF2KzxJ2S0XGB03YRVLy+u1Sqw1IrijX7zO2D9XO3NCMj7+AF8cL
	un1B6ubV83/63nc9SjW6XhEXvJ+I47Jz/cUfSYfSMzZgnu4lJ1F3TSt0ZHL/7UTOqaC1JBFSnvj
	yzdDZ9C3gXR70Joiz7PTpUc0KAi35MDky8O0DTyOaiehf/XhjUuTK0/gdQcSUl8dypsYTwy6B+M
	8WpBMOTgCb/pbZ0/Uygrb9VoJflvbrpDdBpH9NqPpoAa1oOvgXh5PXbPeHXuYBfCWfG0bATVAQY
	AES956xZMFusEImR+J9sDJl8IYdUdpyMf+afcVUNy30hOw==
X-Received: by 2002:a17:90b:3588:b0:2ee:c04a:4281 with SMTP id 98e67ed59e1d1-2fa23f55e36mr17607443a91.6.1739197407427;
        Mon, 10 Feb 2025 06:23:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyP6CawqOeKaUVxUnUyswTZh9FvFL8k4DQt790I6J6UB1hJTPatRSE4FGebHj2ux/PXkRhxA==
X-Received: by 2002:a17:90b:3588:b0:2ee:c04a:4281 with SMTP id 98e67ed59e1d1-2fa23f55e36mr17607401a91.6.1739197406969;
        Mon, 10 Feb 2025 06:23:26 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09b5c71csm8662517a91.47.2025.02.10.06.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 06:23:26 -0800 (PST)
Date: Mon, 10 Feb 2025 22:23:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, zlang@kernel.org
Subject: Re: [PATCH v2] check: Fix fs specfic imports when
 $FSTYPE!=$OLD_FSTYPE
Message-ID: <20250210142322.tptpphdntglsz4eq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <3b980d028a8ae1496c13ebe3a6685fbc472c5bc0.1738040386.git.nirjhar.roy.lists@gmail.com>
 <20250128180917.GA3561257@frogsfrogsfrogs>
 <f89b6b40-8dce-4378-ba56-cf7f29695bdb@gmail.com>
 <20250129160259.GT3557553@frogsfrogsfrogs>
 <dfbd2895-e29a-4e25-bbc6-a83826d14878@gmail.com>
 <20250131162457.GV1611770@frogsfrogsfrogs>
 <20250201063516.gndb7lngpd5afatv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ff6b4e2f-dbd3-479b-a522-a1ae4837b3df@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff6b4e2f-dbd3-479b-a522-a1ae4837b3df@gmail.com>

On Thu, Feb 06, 2025 at 11:32:43PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 2/1/25 12:05, Zorro Lang wrote:
> > On Fri, Jan 31, 2025 at 08:24:57AM -0800, Darrick J. Wong wrote:
> > > On Fri, Jan 31, 2025 at 06:49:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > > On 1/29/25 21:32, Darrick J. Wong wrote:
> > > > > On Wed, Jan 29, 2025 at 04:48:10PM +0530, Nirjhar Roy (IBM) wrote:
> > > > > > On 1/28/25 23:39, Darrick J. Wong wrote:
> > > > > > > On Tue, Jan 28, 2025 at 05:00:22AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > > > > Bug Description:
> > > > > > > > 
> > > > > > > > _test_mount function is failing with the following error:
> > > > > > > > ./common/rc: line 4716: _xfs_prepare_for_eio_shutdown: command not found
> > > > > > > > check: failed to mount /dev/loop0 on /mnt1/test
> > > > > > > > 
> > > > > > > > when the second section in local.config file is xfs and the first section
> > > > > > > > is non-xfs.
> > > > > > > > 
> > > > > > > > It can be easily reproduced with the following local.config file
> > > > > > > > 
> > > > > > > > [s2]
> > > > > > > > export FSTYP=ext4
> > > > > > > > export TEST_DEV=/dev/loop0
> > > > > > > > export TEST_DIR=/mnt1/test
> > > > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > > > 
> > > > > > > > [s1]
> > > > > > > > export FSTYP=xfs
> > > > > > > > export TEST_DEV=/dev/loop0
> > > > > > > > export TEST_DIR=/mnt1/test
> > > > > > > > export SCRATCH_DEV=/dev/loop1
> > > > > > > > export SCRATCH_MNT=/mnt1/scratch
> > > > > > > > 
> > > > > > > > ./check selftest/001
> > > > > > > > 
> > > > > > > > Root cause:
> > > > > > > > When _test_mount() is executed for the second section, the FSTYPE has
> > > > > > > > already changed but the new fs specific common/$FSTYP has not yet
> > > > > > > > been done. Hence _xfs_prepare_for_eio_shutdown() is not found and
> > > > > > > > the test run fails.
> > > > > > > > 
> > > > > > > > Fix:
> > > > > > > > Remove the additional _test_mount in check file just before ". commom/rc"
> > > > > > > > since ". commom/rc" is already sourcing fs specific imports and doing a
> > > > > > > > _test_mount.
> > > > > > > > 
> > > > > > > > Fixes: 1a49022fab9b4 ("fstests: always use fail-at-unmount semantics for XFS")
> > > > > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > > > > > ---
> > > > > > > >     check | 12 +++---------
> > > > > > > >     1 file changed, 3 insertions(+), 9 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/check b/check
> > > > > > > > index 607d2456..5cb4e7eb 100755
> > > > > > > > --- a/check
> > > > > > > > +++ b/check
> > > > > > > > @@ -784,15 +784,9 @@ function run_section()
> > > > > > > >     			status=1
> > > > > > > >     			exit
> > > > > > > >     		fi
> > > > > > > > -		if ! _test_mount
> > > > > > > Don't we want to _test_mount the newly created filesystem still?  But
> > > > > > > perhaps after sourcing common/rc ?
> > > > > > > 
> > > > > > > --D
> > > > > > common/rc calls init_rc() in the end and init_rc() already does a
> > > > > > _test_mount. _test_mount after sourcing common/rc will fail, won't it? Does
> > > > > > that make sense?
> > > > > > 
> > > > > > init_rc()
> > > > > > {
> > > > > >       # make some further configuration checks here
> > > > > >       if [ "$TEST_DEV" = ""  ]
> > > > > >       then
> > > > > >           echo "common/rc: Error: \$TEST_DEV is not set"
> > > > > >           exit 1
> > > > > >       fi
> > > > > > 
> > > > > >       # if $TEST_DEV is not mounted, mount it now as XFS
> > > > > >       if [ -z "`_fs_type $TEST_DEV`" ]
> > > > > >       then
> > > > > >           # $TEST_DEV is not mounted
> > > > > >           if ! _test_mount
> > > > > >           then
> > > > > >               echo "common/rc: retrying test device mount with external set"
> > > > > >               [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
> > > > > >               if ! _test_mount
> > > > > >               then
> > > > > >                   echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
> > > > > >                   exit 1
> > > > > >               fi
> > > > > >           fi
> > > > > >       fi
> > > > > > ...
> > > > > ahahahaha yes it does.
> > > > > 
> > > > > /commit message reading comprehension fail, sorry about that.
> > > > > 
> > > > > Though now that you point it out, should check elide the init_rc call
> > > > > about 12 lines down if it re-sourced common/rc ?
> > > > Yes, it should. init_rc() is getting called twice when common/rc is getting
> > > > re-sourced. Maybe I can do like
> > > > 
> > > > 
> > > > if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
> > > > 
> > > >      <...>
> > > > 
> > > >      . common/rc # changes in this patch
> > > > 
> > > >      <...>
> > > > 
> > > > elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > > > 
> > > >      ...
> > > > 
> > > >      init_rc() # explicitly adding an init_rc() for this condition
> > > > 
> > > > else
> > > > 
> > > >      init_rc() # # explicitly adding an init_rc() for all other conditions.
> > > > This will prevent init_rc() from getting called twice during re-sourcing
> > > > common/rc
> > > > 
> > > > fi
> > > > 
> > > > What do you think?
> > > Sounds fine as a mechanical change, but I wonder, should calling init_rc
> > > be explicit?  There are not so many places that source common/rc:
> > > 
> > > $ git grep 'common/rc'
> > > check:362:if ! . ./common/rc; then
> > > check:836:              . common/rc
> > > common/preamble:52:     . ./common/rc
> > > soak:7:. ./common/rc
> > > tests/generic/749:18:. ./common/rc
> > > 
> > > (I filtered out the non-executable matches)
> > > 
> > > I think the call in generic/749 is unnecessary and I don't know what
> > > soak does.  But that means that one could insert an explicit call to
> > > init_rc at line 366 and 837 in check and at line 53 in common/preamble,
> > > and we can clean up one more of those places where sourcing a common/
> > > file actually /does/ something quietly under the covers.
> > > 
> > > (Unless the maintainer is ok with the status quo...?)
> > I think people just hope to import the helpers in common/rc mostly, don't
> > want to run init_rc again. Maybe we can make sure the init_rc is only run
> > once each time?
> > 
> > E.g.
> > 
> >    if [ _INIT_RC != "done" ];then
> > 	init_rc
> > 	_INIT_RC="done"
> >    fi
> > 
> > Or any better idea.
> 
> Yes, this idea looks good too. However, after thinking a bit more, I like
> Darrick's idea to remove the call to init_rc from common/rc and explicitly
> calling them explicitly whenever necessary makes more sense. This also makes
> the interface/reason to source common/rc more meaningful, and also not
> making common/rc do something via init_rc silently. What do you think?

Sorry I'm on a travel, reply you late. I don't like to run codes in include
files either :) If we remove the init_rc calling from common/rc we might
need to do 2 things:
1) xfstests/check needs to run init_rc, calls it in check properly.
2) Now each sub-cases run init_rc when they import common/rc, I think
we can call init_rc in common/preamble:_begin_fstest().

If I miss other things, please feel free to remind me:)

Thanks,
Zorro

> 
> --NR
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > --D
> > > 
> > > > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > 
> > > > > --D
> > > > > 
> > > > > > ...
> > > > > > 
> > > > > > --NR
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > > -		then
> > > > > > > > -			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
> > > > > > > > -			status=1
> > > > > > > > -			exit
> > > > > > > > -		fi
> > > > > > > > -		# TEST_DEV has been recreated, previous FSTYP derived from
> > > > > > > > -		# TEST_DEV could be changed, source common/rc again with
> > > > > > > > -		# correct FSTYP to get FSTYP specific configs, e.g. common/xfs
> > > > > > > > +		# Previous FSTYP derived from TEST_DEV could be changed, source
> > > > > > > > +		# common/rc again with correct FSTYP to get FSTYP specific configs,
> > > > > > > > +		# e.g. common/xfs
> > > > > > > >     		. common/rc
> > > > > > > >     		_prepare_test_list
> > > > > > > >     	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> > > > > > > > -- 
> > > > > > > > 2.34.1
> > > > > > > > 
> > > > > > > > 
> > > > > > -- 
> > > > > > Nirjhar Roy
> > > > > > Linux Kernel Developer
> > > > > > IBM, Bangalore
> > > > > > 
> > > > -- 
> > > > Nirjhar Roy
> > > > Linux Kernel Developer
> > > > IBM, Bangalore
> > > > 
> > > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 

