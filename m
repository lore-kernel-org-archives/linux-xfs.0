Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E2B24E4C6;
	Thu, 22 May 2025 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908868; cv=none; b=DiVg8TQJp0zTw2wql6kSWiwks/dxJF62gUHzuU7j+eSmCGSUbQH5YZaf/dHBQ9LOK5+aK8pI6OaZynkjU7ZGV7QWJNt/GTAzzjmMnQUE9FnAtV5Nbxk1aW8+GUdtbRayFvuHNFoktU6LTLKSOSllUQFtz0SMaNVkAVOxrOgxrNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908868; c=relaxed/simple;
	bh=81nSlrNEn7TupWWVCq94ofRhN4LgxSF59P3tOkAPshE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5OM6fEgAHKfeLjAFGCgQ8yBSJOs9tvN3f51xi6iPohsh+A6NY8MqpwznVebea1k4/uNoJvEhPrnmvFtKwNmdFQv3ZzxmTfbqCbPxBPLGyOxrgBjDKJF9FDzCzyOM8A+A51z2vqPgMb6iLn36yok3eDC8FshkwvbRrP0H2myVH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bebaMRk4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bebaMRk4"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M7pDFO006460;
	Thu, 22 May 2025 10:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QxGjNRehU2LkAFrnegqUShcAB/Ui2F
	Fsvvs4virmNQM=; b=bebaMRk4GLs0mx3KsZ0K+WW66yWFLffWjHCrN9msR6gtmL
	NnTOwIesn0KEcGxua7D92nrup4t6H8S3ywwOs0hl/0Kut4SusqEQcjP2zp7bJilH
	/l3Nh5VrxYHSwWYiqS05A7g7rwF58Wra2UBd67P2vL451TNN4V1iKjbpolOkkQEr
	Ngm8MLkmjkUMHSBZPq6DLYvWBkMYrmjLYHUxFAvdfptlZe5cI0fSG7Nasq1sy+LC
	djBj8rEI2UZ92J++VGZ0U14NbHF7HVAPHJWQfYv7MIwwTJidQO8+Wx5OL8A6wF/s
	a7VUNJilgbARnLSKddCrMDXglwqDwLWS2MlkDwHA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg2351s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:20 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MADFuo016418;
	Thu, 22 May 2025 10:14:20 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg2351s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9wJBj032014;
	Thu, 22 May 2025 10:14:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq8xk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:14:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MAEHfu59507080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:14:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2310A2004B;
	Thu, 22 May 2025 10:14:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEC1420043;
	Thu, 22 May 2025 10:14:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:14:15 +0000 (GMT)
Date: Thu, 22 May 2025 15:44:13 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 1/6] generic/765: fix a few issues
Message-ID: <aC749au_0ilVX5pE@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520013400.36830-2-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G-9HCzvn0x0oYkKWeT7y7fr0uQgRD93I
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682ef8fc cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8
 a=NVOziJVM4IywdpioYoMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA5NiBTYWx0ZWRfX4WWr1dEZeEJw dQUM9ykWYXgaJoenqf/cdLBd5BWn/X9grYoYQ0HqV/oW6xv8+i5wlTwA7bgy09f5wXVUVWezPvR kxtzArpIXS/5lSYfeICVxfiMMbAsfgc7BRY4jGYvH+J0hPOxkVS40zGa0GkQfnKcJdRKUn6zRoY
 sRYcbOVdvTSJxbkIwWtyc1QmWezNo43W28Xq/6sPNfAF2MtEoonksQaupVfCzDj4k1hE+fWN6bZ Q4VPQbLhS6fDrMmMEgagczuutBvr3H9m/0qhVzD1fe3z9hTFk3kHfSD1X3HS3E7ecrL14tKgqh4 r4WrttaMpiq+3r98467XIDxtrYFwQ5iF+1TBpRrgO8wWmPM4CPS2/z/ckD1ngjA2sY+db4PEeOj
 OMEuNHIMzRofOhBkRHLvrvOPQw6EwBbMwfLEtPkL4hsa2rFcnqrEI4Fy7/qz5K/8zSGUQJqQ
X-Proofpoint-GUID: oLkPAdlquJu16DVPWLMteMtijMPHZm23
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220096

On Mon, May 19, 2025 at 06:33:55PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix a few bugs in the single block atomic writes test, such as not requiring
> directio, using the page size for the ext4 max bsize, and making sure we check
> the max atomic write size.
> 
> Cc: ritesh.list@gmail.com
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin
> ---
>  common/rc         | 2 +-
>  tests/generic/765 | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 657772e7..0ac90d3e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>  		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-D -V 1 -b 4k"
> +			pwrite_opts+="-V 1 -b 4k"
>  		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> diff --git a/tests/generic/765 b/tests/generic/765
> index 9bab3b8a..8695a306 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -28,7 +28,7 @@ get_supported_bsize()
>          ;;
>      "ext4")
>          min_bsize=1024
> -        max_bsize=4096
> +        max_bsize=$(_get_page_size)
>          ;;
>      *)
>          _notrun "$FSTYP does not support atomic writes"
> @@ -73,7 +73,7 @@ test_atomic_writes()
>      # Check that atomic min/max = FS block size
>      test $file_min_write -eq $bsize || \
>          echo "atomic write min $file_min_write, should be fs block size $bsize"
> -    test $file_min_write -eq $bsize || \
> +    test $file_max_write -eq $bsize || \
>          echo "atomic write max $file_max_write, should be fs block size $bsize"
>      test $file_max_segments -eq 1 || \
>          echo "atomic write max segments $file_max_segments, should be 1"
> -- 
> 2.34.1
> 
