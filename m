Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 00:37:09 -0800 (PST)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l258b26p028680
	for <xfs@oss.sgi.com>; Mon, 5 Mar 2007 00:37:05 -0800
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l258b0Nm012708
	for <xfs@oss.sgi.com>; Mon, 5 Mar 2007 17:37:00 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l258axE05458 for xfs@oss.sgi.com; Mon, 5 Mar 2007 17:36:59 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l258ax222741 for <xfs@oss.sgi.com>; Mon, 5 Mar 2007 17:36:59 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070305.163650.35902140 for <xfs@oss.sgi.com>
	; Mon, 5 Mar 2007 16:36:50 +0900
Message-Id: <200703050836.AA05033@TNESG9305.tnes.nec.co.jp>
Date: Mon, 05 Mar 2007 17:36:50 +0900
Subject: Re: [PATCH] repquota doesn't report correct space usage #2
From: Utako Kusaka <utako@tnes.nec.co.jp>
In-Reply-To: <45EBB613.5040803@sgi.com>
References: <45EBB613.5040803@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: donaldd@sgi.com
Cc: xfs@oss.sgi.com

Hi Donald,

I see. I tested your patch and it was no problem.

Mon, 05 Mar 2007 17:17:55 +1100 Donald Douwsma wrote：
>Hi Utako,
>
>That's closer to what I was thinking of but I'd prefer to do the
>manipulation separate to init. Putting it in xfs_qm_mount_quotas()
>minimizes the number of places changes are made to the superblock.
>
>We dont need to worry about group/project differences as a
>quotacheck is forced by XFS_QM_NEED_QUOTACHECK() if there are
>incompatibilities.
>
>
>Signed-off-by: Donald Douwsma <donaldd@sgi.com>
>
>--- a/fs/xfs/quota/xfs_qm.c     2007-03-05 16:50:11.000000000 +1100
>+++ b/fs/xfs/quota/xfs_qm.c     2007-03-05 15:36:12.000000000 +1100
>@@ -388,6 +388,17 @@ xfs_qm_mount_quotas(
>                        return XFS_ERROR(error);
>                }
>        }
>+	/*
>+	 * If one type of quotas is off, then it will lose its
>+	 * quotachecked status, since we won't be doing accounting for
>+	 * that type anymore.
>+	 */
>+	if (!XFS_IS_UQUOTA_ON(mp)) {
>+		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
>+	}
>+	if (!(XFS_IS_GQUOTA_ON(mp) || XFS_IS_PQUOTA_ON(mp))) {
>+		mp->m_qflags &= ~XFS_OQUOTA_CHKD;
>+	}
>
>  write_changes:
>        /*
>
>
>Utako Kusaka wrote:
>> Hi,
>> 
>> This new patch skips the quota check when the filesystem is mounted
>> with the same quota option. 
>> 
>> Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
>> ---
>> 
>> --- fs/xfs/quota/xfs_qm.c.orgn	2007-02-22 17:30:07.000000000 +0900
>> +++ fs/xfs/quota/xfs_qm.c	2007-03-02 15:01:44.000000000 +0900
>> @@ -1175,7 +1175,12 @@ xfs_qm_init_quotainfo(
>>  	qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
>>  	do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));
>>  
>> -	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>> +	if (XFS_IS_UQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT))
>> +		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD);
>> +	if (XFS_IS_GQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))
>> +		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
>> +	if (XFS_IS_PQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))
>> +		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
>>  
>>  	/*
>>  	 * We try to get the limits from the superuser's limits fields.
