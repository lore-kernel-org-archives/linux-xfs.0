Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D19D207E0D
	for <linux-xfs@vger.kernel.org>; Mon,  7 Apr 2025 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744042764; cv=none; b=B6WhZJ4DF8bffBgaJNoHk9XuFOMfkmFKLyuCjH4r0GrUAdHvFy5+WnUE71p1GevANKZMwm6cBpL/crQXJvQbyeD3q2DuQut7Eoc7LBjsrAhTQFfBTP8i8vnqStL9rwiObe3Gz1hkzIr7/K1T/vKrHhvaDZlXsU8DsUODahQwBa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744042764; c=relaxed/simple;
	bh=vLFaSyk6sWXjYEwkM9T5XG3vYHT5MtPUPXEdSHtKDyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQpB3UzEgyaWvRUQOfyKH0UOGEqHlbZ3hxwzI6zm9ZKmiSw6gJM6pB5q+AC4ArPYWt+q48cUjE/mpcnqVaKQrBPqHIAdJqVSTodBkEzDH9QnXYWLkwguy5y7CpOONX/xBVzE5/dpnKF06gDZClCQDXQpnFDYVpfs+h082ZCYvmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSL+iPv3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSL+iPv3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744042761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/O5U86Y3WW6mgW47JNbSK3ilKTH03qmJFfErR0X+qvM=;
	b=fSL+iPv31+HyUOWE20gIulKYKY2DyzjPQFhIjIA2+zDp68K4EnpLH+qIsEbf2iD2NwZnPd
	X4BpVBJuqU4vPMkva9I0Rcw430U/Fz0XKQv1p32v2EY28Q0c2+VcCvakvDPGeplpRiGokz
	V9iFUU/zecD5bYMtA5SjX4hoMZ9VYiM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-p5r65ZicPJ6109YUJCnBDw-1; Mon, 07 Apr 2025 12:19:20 -0400
X-MC-Unique: p5r65ZicPJ6109YUJCnBDw-1
X-Mimecast-MFC-AGG-ID: p5r65ZicPJ6109YUJCnBDw_1744042759
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-227ea16b03dso64885455ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Apr 2025 09:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744042759; x=1744647559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/O5U86Y3WW6mgW47JNbSK3ilKTH03qmJFfErR0X+qvM=;
        b=pts92BU/B5YMxzubDrDVn1M2BVELI2TFa7WnZGc+LA+Qa5sYSd+6aC0YtNWGeZ0tk1
         v0IY7GrnLV7PJb2fh/jIqw9I5zjkc6EMfsiPEQCSHFehOjE01bpR1PXTbAcwfTCw5oVl
         5S1ymHkUf1B8IlmmLt4d0m1mZgG9W13yWG5AZG55QUiZ0G4fEY0mIrwPkeEirghjkzEJ
         eFguOWhn7gGfah99M2uHyXFmiysfNKCiEdEzC/QfnoT2bFWlbeQivKdFy8IvkCRJ0oKO
         vR491NBBHNFLEToSKgMfLz6h+1o9pZ4Lq1T66MetbEsf/+9F16t+aaMu6OHGYxhCaJzY
         XAiA==
X-Forwarded-Encrypted: i=1; AJvYcCVlAkQ4EIlIB09TRVhzPrirnMNW4wUUrmJZS1dGnc7KvEmBjn3EHHMdx4cKhX/Z4XScvRIncoOpg8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdFR3Lqfztl2Lcj1Rds1IU45QilMVIiqOt2lbmECHkWN0yTHo4
	0l9sm9Om7r/6EJrPyjt79FP2+tUwcIUUsUsaRn7YgPVjTXyx1afcwstlVQDM9KMgdsxJi2iWcNm
	Jd6LWy0zxX+nCxtC+6MLI9RKsxlC9gsv35JTuZoBtLH6Slo7AUZBEbm63Xw==
X-Gm-Gg: ASbGnctSk86gfnpY1oGoqtiY5jaxVs/VsDiylK2PkD5/4MsQ7xARGLaA+scHa3pYtQO
	AFXdxw+eLajMmaIRkgKhyiBHEaNLWm0egJnw30rHOcZG3PJmfMVvX+Mg31wuFzXQ0UFViuP+yT3
	zLz8wGPoxuReQFyicuWYdu89LEmasnQxzghkF3i7B9lyXZ4I4dKnKMfuxZWEEHIihweYULpKXda
	lr6Y4+no0YjI5MUmRVq1byTzQYf0Tis6SheZCgcEyi6tZY3yxOpwXw7UhCUtAFAVyB5pbEHa05G
	d3vHNPJ+ZA6MHaGeoGBdFLEFH5yN1YewNshECdjUwf4WFDDMBpmmD28M
X-Received: by 2002:a17:902:e952:b0:223:37ec:63d5 with SMTP id d9443c01a7336-22a8a0659fcmr191658685ad.28.1744042759148;
        Mon, 07 Apr 2025 09:19:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGlSRbRg+QrM0+xuEKWs08wLJNL1lp/YtXP90VI/LkeBCTUHnPXB/060ATzEC3fv57TY60fw==
X-Received: by 2002:a17:902:e952:b0:223:37ec:63d5 with SMTP id d9443c01a7336-22a8a0659fcmr191658295ad.28.1744042758753;
        Mon, 07 Apr 2025 09:19:18 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785ad84csm83572285ad.44.2025.04.07.09.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 09:19:18 -0700 (PDT)
Date: Tue, 8 Apr 2025 00:19:14 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, djwong@kernel.org,
	zlang@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 5/5] common: exit --> _exit
Message-ID: <20250407161914.mfnqef2vqghgy3c2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1743487913.git.nirjhar.roy.lists@gmail.com>
 <f6c7e5647d5839ff3a5c7d34418ec56aba22bbc1.1743487913.git.nirjhar.roy.lists@gmail.com>
 <87mscwv7o0.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mscwv7o0.fsf@gmail.com>

On Fri, Apr 04, 2025 at 10:34:47AM +0530, Ritesh Harjani wrote:
> "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com> writes:
> 
> > Replace exit <return-val> with _exit <return-val> which
> > is introduced in the previous patch.
> >
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > ---
> >  common/btrfs    |   6 +--
> >  common/ceph     |   2 +-
> >  common/config   |   7 ++--
> >  common/ext4     |   2 +-
> >  common/populate |   2 +-
> >  common/preamble |   2 +-
> >  common/punch    |  12 +++---
> >  common/rc       | 103 +++++++++++++++++++++++-------------------------
> >  common/xfs      |   8 ++--
> >  9 files changed, 70 insertions(+), 74 deletions(-)
> >
> > diff --git a/common/btrfs b/common/btrfs
> > index a3b9c12f..3725632c 100644
> > --- a/common/btrfs
> > +++ b/common/btrfs
> > @@ -80,7 +80,7 @@ _require_btrfs_mkfs_feature()
> >  {
> >  	if [ -z $1 ]; then
> >  		echo "Missing feature name argument for _require_btrfs_mkfs_feature"
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  	feat=$1
> >  	$MKFS_BTRFS_PROG -O list-all 2>&1 | \
> > @@ -104,7 +104,7 @@ _require_btrfs_fs_feature()
> >  {
> >  	if [ -z $1 ]; then
> >  		echo "Missing feature name argument for _require_btrfs_fs_feature"
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  	feat=$1
> >  	modprobe btrfs > /dev/null 2>&1
> > @@ -214,7 +214,7 @@ _check_btrfs_filesystem()
> >  	if [ $ok -eq 0 ]; then
> >  		status=1
> >  		if [ "$iam" != "check" ]; then
> > -			exit 1
> > +			_exit 1
> >  		fi
> >  		return 1
> >  	fi
> > diff --git a/common/ceph b/common/ceph
> > index d6f24df1..df7a6814 100644
> > --- a/common/ceph
> > +++ b/common/ceph
> > @@ -14,7 +14,7 @@ _ceph_create_file_layout()
> >  
> >  	if [ -e $fname ]; then
> >  		echo "File $fname already exists."
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  	touch $fname
> >  	$SETFATTR_PROG -n ceph.file.layout \
> > diff --git a/common/config b/common/config
> > index eb6af35a..4c5435b7 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -123,8 +123,7 @@ set_mkfs_prog_path_with_opts()
> >  _fatal()
> >  {
> >      echo "$*"
> > -    status=1
> > -    exit 1
> > +    _exit 1
> >  }
> >  
> >  export MKFS_PROG="$(type -P mkfs)"
> > @@ -868,7 +867,7 @@ get_next_config() {
> >  		echo "Warning: need to define parameters for host $HOST"
> >  		echo "       or set variables:"
> >  		echo "       $MC"
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  
> >  	_check_device TEST_DEV required $TEST_DEV
> > @@ -879,7 +878,7 @@ get_next_config() {
> >  	if [ ! -z "$SCRATCH_DEV_POOL" ]; then
> >  		if [ ! -z "$SCRATCH_DEV" ]; then
> >  			echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) should be unset when \$SCRATCH_DEV_POOL ($SCRATCH_DEV_POOL) is set"
> > -			exit 1
> > +			_exit 1
> >  		fi
> >  		SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> >  		export SCRATCH_DEV
> > diff --git a/common/ext4 b/common/ext4
> > index e1b336d3..f88fa532 100644
> > --- a/common/ext4
> > +++ b/common/ext4
> > @@ -182,7 +182,7 @@ _require_scratch_ext4_feature()
> >  {
> >      if [ -z "$1" ]; then
> >          echo "Usage: _require_scratch_ext4_feature feature"
> > -        exit 1
> > +        _exit 1
> >      fi
> >      $MKFS_EXT4_PROG -F $MKFS_OPTIONS -O "$1" \
> >  		    $SCRATCH_DEV 512m >/dev/null 2>&1 \
> > diff --git a/common/populate b/common/populate
> > index 7352f598..50dc75d3 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -1003,7 +1003,7 @@ _fill_fs()
> >  
> >  	if [ $# -ne 4 ]; then
> >  		echo "Usage: _fill_fs filesize dir blocksize switch_user"
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  
> >  	if [ $switch_user -eq 0 ]; then
> > diff --git a/common/preamble b/common/preamble
> > index c92e55bb..ba029a34 100644
> > --- a/common/preamble
> > +++ b/common/preamble
> > @@ -35,7 +35,7 @@ _begin_fstest()
> >  {
> >  	if [ -n "$seq" ]; then
> >  		echo "_begin_fstest can only be called once!"
> > -		exit 1
> > +		_exit 1
> >  	fi
> >  
> >  	seq=`basename $0`
> > diff --git a/common/punch b/common/punch
> > index 43ccab69..6567b9d1 100644
> > --- a/common/punch
> > +++ b/common/punch
> > @@ -172,16 +172,16 @@ _filter_fiemap_flags()
> >  	$AWK_PROG -e "$awk_script" | _coalesce_extents
> >  }
> >  
> > -# Filters fiemap output to only print the 
> > +# Filters fiemap output to only print the
> >  # file offset column and whether or not
> >  # it is an extent or a hole
> >  _filter_hole_fiemap()
> >  {
> >  	$AWK_PROG '
> >  		$3 ~ /hole/ {
> > -			print $1, $2, $3; 
> > +			print $1, $2, $3;
> >  			next;
> > -		}   
> > +		}
> >  		$5 ~ /0x[[:xdigit:]]+/ {
> >  			print $1, $2, "extent";
> >  		}' |
> > @@ -225,7 +225,7 @@ _filter_bmap()
> >  die_now()
> >  {
> >  	status=1
> > -	exit
> > +	_exit
> 
> Why not remove status=1 too and just do _exit 1 here too?
> Like how we have done at other places?

Yeah, nice catch! As the defination of _exit:

  _exit()
  {
       status="$1"
       exit "$status"
  }

The
  "
  status=1
  exit
  "
should be equal to:
  "
  _exit 1
  "

And "_exit" looks not make sense, due to it gives null to status.

Same problem likes below:


@@ -3776,7 +3773,7 @@ _get_os_name()
                echo 'linux'
        else
                echo Unknown operating system: `uname`
-               exit
+               _exit


The "_exit" without argument looks not make sense.

Thanks,
Zorro

> 
> Rest looks good to me. 
> 
> -ritesh
> 

