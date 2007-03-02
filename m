Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 22:34:56 -0800 (PST)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l226Yl6p028373
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 22:34:50 -0800
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l226YlD1008695
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 15:34:47 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l226Yk015713 for xfs@oss.sgi.com; Fri, 2 Mar 2007 15:34:46 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l226YkL00734 for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 15:34:46 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070302.143432.87504704 for <xfs@oss.sgi.com>
	; Fri, 2 Mar 2007 14:34:32 +0900
Message-Id: <200703020634.AA05027@TNESG9305.tnes.nec.co.jp>
Date: Fri, 02 Mar 2007 15:34:34 +0900
Subject: [PATCH] repquota doesn't report correct space usage #2
From: Utako Kusaka <utako@tnes.nec.co.jp>
In-Reply-To: <45E76138.2020202@sgi.com>
References: <45E76138.2020202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: donaldd@sgi.com, xfs@oss.sgi.com

Hi,

This new patch skips the quota check when the filesystem is mounted
with the same quota option. 

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- fs/xfs/quota/xfs_qm.c.orgn	2007-02-22 17:30:07.000000000 +0900
+++ fs/xfs/quota/xfs_qm.c	2007-03-02 15:01:44.000000000 +0900
@@ -1175,7 +1175,12 @@ xfs_qm_init_quotainfo(
 	qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
 	do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));
 
-	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
+	if (XFS_IS_UQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT))
+		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD);
+	if (XFS_IS_GQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))
+		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
+	if (XFS_IS_PQUOTA_ON(mp) && (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))
+		mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.

Fri, 02 Mar 2007 10:26:48 +1100 Donald Douwsma wrote：
>Utako Kusaka wrote:
>> Hi,
>> 
>> repquota may report incorrect space usage when the filesystem is mounted
>> repeatedly with different quota options.
>> The cause of the problem is that xfs_qm_quotacheck() is not called because
>> the `CHKD' flag in mp->m_qflags is not cleared until it is mounted with 
>> no quota option. This patch fixes it.
>
>Good find, I've heard of some problems with quota 'corruption' that may
>actually be caused by this.
>
>> --- linux-2.6.20-orgn/fs/xfs/quota/xfs_qm.c.orgn        2007-02-22 17:30:07.000000000 +0900
>> +++ linux-2.6.20/fs/xfs/xfs_qm.c        2007-02-22 17:30:58.000000000 +0900
>> @@ -1175,8 +1175,6 @@ xfs_qm_init_quotainfo(
>>         qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
>>         do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));
>> 
>> -       mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>> -
>>         /*
>>          * We try to get the limits from the superuser's limits fields.
>>          * This is quite hacky, but it is standard quota practice.
>
>This disables the optimization that skips the quota check for the normal case where mount
>options have not been changed.
>
>I don't have any quota check performance figures handy but I don't think we can loose this
>optimization for people with large filesystems/machines.
>
>I think instead we need to clear the individual quota bit when a filesystem is mounted
>without a particular quota type. This will force a quota check but only when the filesystem
>is again mounted with that quota type.
>
>Donald
>
>
