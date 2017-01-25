Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33421 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751137AbdAYFBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 00:01:16 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0P4wpG3034958
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 00:01:15 -0500
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2865sk5pfj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 00:01:15 -0500
Received: from localhost
        by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 25 Jan 2017 10:31:12 +0530
Received: from d28relay08.in.ibm.com (d28relay08.in.ibm.com [9.184.220.159])
        by d28dlp02.in.ibm.com (Postfix) with ESMTP id BEDC93940060
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 10:31:10 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
        by d28relay08.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v0P50HL515859958
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 10:30:17 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
        by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v0P519Tc012940
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 10:31:10 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] tools/find-api-violations: fix fs -> fsr in the directory list
Date: Wed, 25 Jan 2017 10:31:07 +0530
In-Reply-To: <20170124172210.GC9134@birch.djwong.org>
References: <20170124172210.GC9134@birch.djwong.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1560023.HPyvzjyxDL@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tuesday, January 24, 2017 09:22:10 AM Darrick J. Wong wrote:
> Fix a stupid typo in the original commit.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tools/find-api-violations.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
> index 7937749..b4b8de5 100755
> --- a/tools/find-api-violations.sh
> +++ b/tools/find-api-violations.sh
> @@ -6,7 +6,7 @@
> 
>  # NOTE: This script doesn't look for API violations in function parameters.
> 
> -tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
> +tool_dirs="copy db estimate fsr fsck fsr growfs io mdrestore mkfs quota repair rtcp"
>
                               
fsr is already part of the list. With this patch, we now have a duplicate
entry. Or, Am I missing something very obvious?

-- 
chandan

