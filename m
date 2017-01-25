Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39153 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751231AbdAYFmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 00:42:22 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0P5fAXW021762
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 00:42:16 -0500
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0a-001b2d01.pphosted.com with ESMTP id 286dq3qyf8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 00:42:16 -0500
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 25 Jan 2017 15:42:14 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id 103953578053
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 16:42:12 +1100 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v0P5g3XI26214604
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 16:42:11 +1100
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v0P5fd19029094
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 16:41:39 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] tools/find-api-violations: fix missing dirs in the directory list
Date: Wed, 25 Jan 2017 11:11:20 +0530
In-Reply-To: <20170125052852.GK9134@birch.djwong.org>
References: <20170125052852.GK9134@birch.djwong.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2357002.pCcJ9JlUn9@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tuesday, January 24, 2017 09:28:52 PM Darrick J. Wong wrote:
> Fix a stupid typo in the original commit.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tools/find-api-violations.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
> index 7937749..c2be4c5 100755
> --- a/tools/find-api-violations.sh
> +++ b/tools/find-api-violations.sh
> @@ -6,7 +6,7 @@
> 
>  # NOTE: This script doesn't look for API violations in function parameters.
> 
> -tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
> +tool_dirs="copy db estimate fsck fsr growfs io logprint mdrestore mkfs quota repair rtcp"
> 
>  # Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
>  find_possible_api_calls() {
> 

Looks good to me,

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

