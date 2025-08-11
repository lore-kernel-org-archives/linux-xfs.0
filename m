Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF352E2DEB
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936409; cv=none; b=miSDBwm3QEcbRCUUdLh8tZX4gg2rdvyrZpz8a1EG6nHz6OM2usTwChZSnQBQ2MQVxC5L0laF55w+R5ZRQZ18P6aussD4jj3JTORJLdiSjoXQ9mc0fcQH6ALuoGHvMbNqa2eSmAA7pyqhLVThZzw1CexSNwLVs/jxyB5AGgDoUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936409; c=relaxed/simple;
	bh=T3LaeRVcsdi23+M59qG/VAc5/5y6EOXRDLfMSwKzyRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnVjpFEf7i+lvLAh8uwEpkMEB/WENp5DAP/lQyASPj0NhTArVnJY4C7csHEZovsG6ZAJzh95Kbs76AeAC4bdJLh9V97oD4sKfacdXYXqBL0m6mj+ePApe76O77QZslnLBIt4BofSxMQtH7lCqZruEIlxsC1ba+1ONrX3aSXfWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TTbyIHzq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TTbyIHzq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754936406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LIKfTOFRBpG1TUjWWmc0ELg8ITlQdSNAzn7Q8SWLBM8=;
	b=TTbyIHzqsvz9gaxnjSXRwTxNvZnk6ZEpzYP3zFodpzXIRBHwHbCFpXtDP1VZUEXvY+33KH
	EPaDUldIL0LAWknSoZvC0dwuec0eyPSjdoAz/U4NmclKWGSaHIRsc9o5G53opGcqvt9Toh
	Yal4v77tLskBXLVylWZ32L2WNOlDzyc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-eg3k6rtLO0aQKhqXvjBeow-1; Mon, 11 Aug 2025 14:20:05 -0400
X-MC-Unique: eg3k6rtLO0aQKhqXvjBeow-1
X-Mimecast-MFC-AGG-ID: eg3k6rtLO0aQKhqXvjBeow_1754936404
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7806a620cso2645915f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754936404; x=1755541204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIKfTOFRBpG1TUjWWmc0ELg8ITlQdSNAzn7Q8SWLBM8=;
        b=OFFkE7gPX05N03jcw3P3RdKo+1Iqj/NW9/wctCr6AC+X42+QoKcNmj6jzmVmL6OMDu
         B+GvCf0b0W7oXDELP+qXLLg0GvGanOyNqEf2fsHNftBdoqC/IiRI6uY2oK/ZQueyCEp7
         J6ux287WvMCn+k22Nnjnh7ktxuXH+A0KNMjagF+Kt9byfof4Pg7w4Q+3FvoaoHZKmt9D
         oUI4KncT3eGlePK3QrsIqtYoI1o6UWAP5kW7rWn/1nMALVyU8zmbjtntk8gn4t1CJOSJ
         MDdS8NjHAxKfxm5wi+4unhSvnR+9gm+bRGsP4B93sT+RmR253aYy3xLHzErm5EzzhhSc
         lWvg==
X-Forwarded-Encrypted: i=1; AJvYcCWuDmymFVuJ1YGLsTpDbWcjz5AxAWhsunyp8wyXoaJBg0zI+K9+vZpfeoyEAVOxf9u5NiXf0ySOThY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgd9X13N+y/n1FojMlM4ENyydzLW3bpy9mHrCqdLkuge2Z4gV7
	rGmTeaioiMmjV0uqpIyXw6h3Dr7nIVUfQSP96p8dLpGzrgBl5mUx+/BFKdKGp67B4oo95rRzFXq
	MZcYwArVmQysThyNkrc1RrpifuCZUR1752yibk92lEAryMV6HozfIV26Mzp3FYK6uDMPh
X-Gm-Gg: ASbGnctoAuICUTlEqG87XB1cG27zu2SW5fSv0G10QPDLK9ppL+hHDfWYTrcW6gK/ey3
	dupCuhT2C2IpfnyYQCnr5K7w+cX95gioyKkbzfaWYdMU4fKvLHvOO3M22tjHAQMaxG4VKQRZeBU
	InQsT2lnj00l3AwwaJirkBsDwqG+99HEG/mCGHhIHlfioOU+nyokb/jEkHz03XvvzIqftLoDLiO
	iznSqp63fXsa7IA04J9+PH6c08o7X3KIJ6wn1CDypA6Uc1R4roWY7kWb5bgmnIqjUweopjw0CzS
	hagQPwukmDjmm0BD0tvsF2X9xGMFESqVP7rnrKqPGEUZOOYL5eEBlL5LSdU=
X-Received: by 2002:a05:6000:2401:b0:3b8:d2d1:5c11 with SMTP id ffacd0b85a97d-3b91101537fmr618711f8f.51.1754936403727;
        Mon, 11 Aug 2025 11:20:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk+3gYuRh3b2bS07Zq+Au0xyx3Dg8lWVfR3XAQ5eneJikhJqXxYWXaYnC3hDSlsyYzupTJ5A==
X-Received: by 2002:a05:6000:2401:b0:3b8:d2d1:5c11 with SMTP id ffacd0b85a97d-3b91101537fmr618667f8f.51.1754936403283;
        Mon, 11 Aug 2025 11:20:03 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac115sm41479736f8f.12.2025.08.11.11.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:20:03 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:20:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/3] xfs: test quota's project ID on special files
Message-ID: <iwepnjszb4lgzyzap36nr7z7ysdntxlthbqmpvyz2vozdhzumr@hb4u5ojwifup>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-3-6a09c4f37f10@kernel.org>
 <20250811174613.tskc4xzbhteyiq5z@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811174613.tskc4xzbhteyiq5z@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On 2025-08-12 01:46:13, Zorro Lang wrote:
> On Fri, Aug 08, 2025 at 09:31:58PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > With addition of file_getattr() and file_setattr(), xfs_quota now can
> > set project ID on filesystem inodes behind special files. Previously,
> > quota reporting didn't count inodes of special files created before
> > project initialization. Only new inodes had project ID set.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tests/xfs/2000     | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/2000.out | 17 ++++++++++++
> >  2 files changed, 94 insertions(+)
> > 
> > diff --git a/tests/xfs/2000 b/tests/xfs/2000
> > new file mode 100755
> > index 000000000000..26a0093c1da1
> > --- /dev/null
> > +++ b/tests/xfs/2000
> > @@ -0,0 +1,77 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 2000
> > +#
> > +# Test that XFS can set quota project ID on special files
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Import common functions.
> > +. ./common/quota
> > +. ./common/filter
> > +
> > +_wants_kernel_commit xxxxxxxxxxx \
> > +	"xfs: allow setting file attributes on special files"
> > +_wants_git_commit xfsprogs xxxxxxxxxxx \
> > +	"xfs_quota: utilize file_setattr to set prjid on special files"
> > +
> > +# Modify as appropriate.
> > +_require_scratch
> > +_require_xfs_quota
> > +_require_test_program "af_unix"
> > +_require_symlinks
> > +_require_mknod
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_qmount_option "pquota"
> > +_scratch_mount
> > +
> > +create_af_unix () {
> > +	$here/src/af_unix $* || echo af_unix failed
> > +}
> > +
> > +filter_quota() {
> > +	_filter_quota | sed "s~$tmp.projects~PROJECTS_FILE~"
> > +}
> > +
> > +projectdir=$SCRATCH_MNT/prj
> > +id=42
> > +
> > +mkdir $projectdir
> > +mkfifo $projectdir/fifo
> > +mknod $projectdir/chardev c 1 1
> > +mknod $projectdir/blockdev b 1 1
> > +create_af_unix $projectdir/socket
> > +touch $projectdir/foo
> > +ln -s $projectdir/foo $projectdir/symlink
> > +touch $projectdir/bar
> > +ln -s $projectdir/bar $projectdir/broken-symlink
> > +rm -f $projectdir/bar
> > +
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "report -inN -p" $SCRATCH_DEV
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> > +
> > +# Let's check that we can recreate the project (flags were cleared out)
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "report -inN -p" $SCRATCH_DEV
> > +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/2000.out b/tests/xfs/2000.out
> > new file mode 100644
> > index 000000000000..dd3918f1376d
> > --- /dev/null
> > +++ b/tests/xfs/2000.out
> > @@ -0,0 +1,17 @@
> > +QA output created by 2000
> > +Setting up project 42 (path SCRATCH_MNT/prj)...
> > +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> > +Checking project 42 (path SCRATCH_MNT/prj)...
> > +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> > +#0                   3          0          0     00 [--------]
> 
> Better to filter out the root quota report, it might fail on some test environments.
> 

sure

-- 
- Andrey

