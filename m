Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB70262FF3;
	Thu, 22 May 2025 10:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908908; cv=none; b=n2K06Y+hAg+Szq7y66gY/8lfQbQIalXqY2NaPRIPTWwIDFIy8Dg0lXXRJdmBi4gGRlzLQAKKehPd/fXPuXlcG44cMaW4HxXw8Z0zpK1H648kh2xmW2/xKKmUxdhJ6uHAGs2OsFOU43TJB6Qo6vFj5DJhdEX0WSXGZpt/wz4uwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908908; c=relaxed/simple;
	bh=w6cpnRwR86dShRCtob+USHzl2I2jLHIckdqg2nB8nvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qz0ZKIDGQuABpmnDkifDT0pCC+LFsZBvtAFAU1Jf4Blf0jIBCy1fQ4KV5C55aM9YhOYZc7M5BBp60rXoydtPwlr8ASKTZoY0mfScc6jdZGaQdyTp1IiVae0ycj0x+5OXoQ2WWHpOImZg7VqERxMcPvfRnGaujmwBZOq8ry9xzg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SBfIYFY4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SBfIYFY4"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LMje4o006691;
	Thu, 22 May 2025 10:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=iGqyG+xvet/3qzh2+XVLBvmapAw52M
	/HK0YIuf865OQ=; b=SBfIYFY4JqtLUl4PgE1dQ+yiMf6dDIcqkfPC0G4IFjSjfr
	EVJyZeieA7oq4B0MG61u1Pp2IZZJ83tL+dzBzAucDHxv2YnB6uOyakfvkOoRnwu7
	oKjjPtFRB2VCqCNAfOvLrD959SSgtGRwFXD4O2NR4qfI8qf0ecEaXndYS11yKF3C
	J4nVwsMTAkYMfIDJK+AJNy6uwy8Q0zgwpIdtdZ11BML0NOIDvVYagCggz9LuTd6i
	HB5ymSJyD4ym3jfc4opU/7uUwmuU88piIzZKK8n/xJCshDxpzKF9n2bSxYTRd+3C
	t7d2Tdwk7D16inJVEWr1jA70C07FV1vQ1lx0xqfg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg2351uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:58 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MADFuq016418;
	Thu, 22 May 2025 10:14:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg2351u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9al8M032122;
	Thu, 22 May 2025 10:14:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmgx10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:56 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MAEtnV29491704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:14:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 156672004B;
	Thu, 22 May 2025 10:14:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9388420040;
	Thu, 22 May 2025 10:14:53 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:14:53 +0000 (GMT)
Date: Thu, 22 May 2025 15:44:51 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 2/6] generic/765: adjust various things
Message-ID: <aC75G53TMzJLFdfq@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520013400.36830-3-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t_1ccBdQdrRQ4t1lGqoKCTyqD6PZb5w_
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682ef922 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=-_So8W15D0TCrSHlM_cA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA5NiBTYWx0ZWRfXzWmJjWKTvvzN eDjjkC2FLcpRrHEUDdOIHRe5ddZeYvFQY/DIKEv33bDvpm97IMinMgWf1WEZhq5kzbWZnDdQcYz Ci5ZzEMXDa0ikJuznxzMeK5Nt8Wf6T+jcpXDe+o0WKKEPXrv6NGylvu4yNqzkOYx9+ELQWOB9Is
 ToFqylutKcNvf6+D/RgSHg566x4R+GCh0HVq8uQFgMPI6FgsW7uM/vKnpdOZTz9wPcPYcaG7UGL lKK/wz+La8+SDV8vngoiOrtcH8tF5ZSt5CLpdIe2N2fkNeEca6cxyHgp0siCZ7EYzWad/ppQeKQ jrflH1z5i44cUu7830WPvul4L5324AXwEKvORgBKGToau1ptX8qnwM0l/sHs/mUGOwHZ/IEmIXT
 ydsqTNUdyR6smAIKw0YM1662C+AkxM7SbYkBTFWJ5nfriJNHoqAHKwWAH+XqjElWimPNQdKB
X-Proofpoint-GUID: OOKy37_vYfyjfebK_PQHW2jb0ZEjuYnV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220096

On Mon, May 19, 2025 at 06:33:56PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix some bugs when detecting the atomic write geometry, record what
> atomic write geometry we're testing each time through the loop, and
> create a group for atomic writes tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Looks good, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  common/rc           |  4 ++--
>  doc/group-names.txt |  1 +
>  tests/generic/765   | 25 ++++++++++++++++++++++++-
>  3 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 0ac90d3e..261fa72a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5442,13 +5442,13 @@ _get_atomic_write_unit_min()
>  _get_atomic_write_unit_max()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep atomic_write_unit_max | grep -o '[0-9]\+'
> +        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
>  }
>  
>  _get_atomic_write_segments_max()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep atomic_write_segments_max | grep -o '[0-9]\+'
> +        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
>  }
>  
>  _require_scratch_write_atomic()
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index f510bb82..1b38f73b 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -12,6 +12,7 @@ acl			Access Control Lists
>  admin			xfs_admin functionality
>  aio			general libaio async io tests
>  atime			file access time
> +atomicwrites		RWF_ATOMIC testing
>  attr			extended attributes
>  attr2			xfs v2 extended aributes
>  balance			btrfs tree rebalance
> diff --git a/tests/generic/765 b/tests/generic/765
> index 8695a306..84381730 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -7,7 +7,7 @@
>  # Validate atomic write support
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rw
> +_begin_fstest auto quick rw atomicwrites
>  
>  _require_scratch_write_atomic
>  _require_xfs_io_command pwrite -A
> @@ -34,6 +34,10 @@ get_supported_bsize()
>          _notrun "$FSTYP does not support atomic writes"
>          ;;
>      esac
> +
> +    echo "fs config ------------" >> $seqres.full
> +    echo "min_bsize $min_bsize" >> $seqres.full
> +    echo "max_bsize $max_bsize" >> $seqres.full
>  }
>  
>  get_mkfs_opts()
> @@ -70,6 +74,11 @@ test_atomic_writes()
>      file_max_write=$(_get_atomic_write_unit_max $testfile)
>      file_max_segments=$(_get_atomic_write_segments_max $testfile)
>  
> +    echo "test $bsize --------------" >> $seqres.full
> +    echo "file awu_min $file_min_write" >> $seqres.full
> +    echo "file awu_max $file_max_write" >> $seqres.full
> +    echo "file awu_segments $file_max_segments" >> $seqres.full
> +
>      # Check that atomic min/max = FS block size
>      test $file_min_write -eq $bsize || \
>          echo "atomic write min $file_min_write, should be fs block size $bsize"
> @@ -145,6 +154,15 @@ test_atomic_write_bounds()
>      testfile=$SCRATCH_MNT/testfile
>      touch $testfile
>  
> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> +
> +    echo "test awb $bsize --------------" >> $seqres.full
> +    echo "file awu_min $file_min_write" >> $seqres.full
> +    echo "file awu_max $file_max_write" >> $seqres.full
> +    echo "file awu_segments $file_max_segments" >> $seqres.full
> +
>      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
>          echo "atomic write should fail when bsize is out of bounds"
>  
> @@ -157,6 +175,11 @@ sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_un
>  bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>  bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>  
> +echo "sysfs awu_min $sys_min_write" >> $seqres.full
> +echo "sysfs awu_min $sys_max_write" >> $seqres.full
> +echo "bdev awu_min $bdev_min_write" >> $seqres.full
> +echo "bdev awu_min $bdev_max_write" >> $seqres.full
> +
>  # Test that statx atomic values are the same as sysfs values
>  if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
>      echo "bdev min write != sys min write"
> -- 
> 2.34.1
> 
