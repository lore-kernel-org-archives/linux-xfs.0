Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9691607AC;
	Wed, 23 Oct 2024 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729677289; cv=none; b=L6hINLHhwZE/11exo0IaVzk1bWTr36m7+yV6pFk+qf0oxl49YigksUxrFJdcQ1ce/H0sV1kP9+YgXp0IxYrUWxqUeU6RThprCB3HTAXMb0PkTJApVLJAdstiyj6KfwvNn7dTkARqXWegBhL4i7tViAGsN0wJGSORvpKa6HgWY2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729677289; c=relaxed/simple;
	bh=BjC+k6iTn5usSFpLFhhvu/hqaIKcJm8OUNVxfEvCE44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=itiFSI/IL29+HL9wAmuXygq1UyebHySI/KuZ+K1MIfT6kGlPJ95sPAXtO8N1aEnYJ0wnNBIZp+O3WXoPY8FpHoZ2kS4tAmDH8Mnks2FLJe/0fGHGd90TvWxlFAkoepsPozOYNLeDkYLRGepyasAzDsmKkNQOpRV0MaZWoVmx2ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a2RnBw6h; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a2RnBw6h"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N0N335025218;
	Wed, 23 Oct 2024 09:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gQifT507hGC5nwbUYcGEqzKhA6120I
	xsn4+skQxx+OU=; b=a2RnBw6h9+15VkDkqIC8GisuUZxPTk4r1V3gXC182OWy7R
	8f8exNIOsvl5JgVzrT1+Tv3rpyTWameOCUylspEhlfHgTPUljRGQHBWriy7INVH1
	Plwzg1aNdlx+AUM7q4F44n4EzoCWwqw+GuHEJsBp7YAbbScatozycroruipO7H0s
	JyHjLr8MKo59ZiWMYANTEGDZX2HnKlV0mPUk7VNWs3JJKpKceE4L42GXUcCRjpgH
	aI1tmy35ZSITbGmXFkj+gkYQEeiiZV4DxkCwHb0WQ2ScdEgX6K7B5aAPov+ydTeM
	+odfQLu5O3hOY77IpMe/GUOvrbFvkXnNlU66f8zw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emaetb8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 09:54:37 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49N9sbAM009209;
	Wed, 23 Oct 2024 09:54:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emaetb8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 09:54:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7KXvd008851;
	Wed, 23 Oct 2024 09:54:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42emkaj91q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 09:54:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49N9sYwH52887810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 09:54:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB081202F6;
	Wed, 23 Oct 2024 09:54:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24326202D7;
	Wed, 23 Oct 2024 09:54:17 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.39.27.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Oct 2024 09:53:46 +0000 (GMT)
Date: Wed, 23 Oct 2024 15:23:44 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
        Christoph Hellwig <hch@lst.de>, nirjhar@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <ZxjHdDbAkiHpbTC8@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20241015094509.678082-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015094509.678082-1-ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: voi4MFaHMY_m5_sLlquGv1u7fu2mhyA2
X-Proofpoint-ORIG-GUID: RyOuei7EeJi2YfvfOFYXoVzks0Qtorzg
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=773
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410230059

On Tue, Oct 15, 2024 at 03:15:09PM +0530, Ojaswin Mujoo wrote:
> Extsize should only be allowed to be set on files with no data in it.
> For this, we check if the files have extents but miss to check if
> delayed extents are present. This patch adds that check.
> 
> While we are at it, also refactor this check into a helper since
> it's used in some other places as well like xfs_inactive() or
> xfs_ioctl_setattr_xflags()
> 
> **Without the patch (SUCCEEDS)**
> 
> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> 
> **With the patch (FAILS as expected)**
> 
> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> 
> Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
> 

The initial set of tests have been posted by Nirjhar here:
https://lore.kernel.org/fstests/cover.1729624806.git.nirjhar@linux.ibm.com/T/#t

Regards,
ojaswin
