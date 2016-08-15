Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94F527CA2
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 11:43:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66F8A8F80C0
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 09:43:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id evls1uBrJBrZxdmm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Aug 2016 09:43:12 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A0FBAC04B317
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 16:43:11 +0000 (UTC)
Subject: Re: [PATCH] xfs_quota: wire up XFS_GETQSTATV
References: <a8d81afb-8c95-c6bf-028d-8d6e463557b3@redhat.com>
	<20160815163859.GA7193@zlang.usersys.redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <cc9c36c1-79ad-60af-6938-66d9e0e73b2c@redhat.com>
Date: Mon, 15 Aug 2016 11:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <20160815163859.GA7193@zlang.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zorro Lang <zlang@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/15/16 11:38 AM, Zorro Lang wrote:
> From the result of strace, we can see:
>   quotactl(0x5808 /* Q_??? */|USRQUOTA, "/dev/mapper/testvg-scratchdev", 0, 0x7ffdbbda94c0) = -1 EINVAL (Invalid argument)
>   quotactl(Q_XGETQSTAT|USRQUOTA, "/dev/mapper/testvg-scratchdev", 0, {version=1, ...}) = 0
> 
> So the first call for XFS_GETQSTATV return EINVAL.
> 
> In linux kernel quota_getxstatev() function, the logic is:
>   /* If this kernel doesn't support user specified version, fail */
>   switch (fqs.qs_version) {
>   case FS_QSTATV_VERSION1:
>         break;
>   default:
>         return -EINVAL;
>   }
> 
> So we need to set qa_version to FS_QSTATV_VERSION1, before
> we call XFS_GETQSTATV. And as we talked on IRC, it test passed if I set
> 
>   sv.qs_version = 1;
> 
> at here.
> 
> So maybe a V2 patch is needed to fix this problem:)

Yep, kernel commit said:

| Callers of the new quotactl command have to set the version of the data
| structure being passed, and kernel will fill as much data as requested.
| If the kernel does not support the user-space provided version, EINVAL
| will be returned. User-space can reduce the version number and call the same
| quotactl again.

but this isn't documented anywhere else, AFAICT; this call still isn't
documented in the quotactl manpage.  o_O

I'll fix it up, thanks for catching it!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
