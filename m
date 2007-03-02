Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 19:03:12 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l223366p023490
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 19:03:07 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l22330QB029427
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 12:03:04 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l222xpsK002231
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 11:59:51 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l222xpx05901 for xfs@oss.sgi.com; Fri, 2 Mar 2007 11:59:51 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l222xpg16589 for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 11:59:51 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070302.105937.51502548 for <xfs@oss.sgi.com>
	; Fri, 2 Mar 2007 10:59:37 +0900
Message-Id: <200703020259.AA05023@TNESG9305.tnes.nec.co.jp>
From: Utako Kusaka <utako@tnes.nec.co.jp>
Date: Fri, 02 Mar 2007 11:59:44 +0900
Subject: Re: [PATCH] repquota does't report correct space usage
In-Reply-To: <45E76138.2020202@sgi.com>
References: <45E76138.2020202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com

Hi, Donald

I understand your explanation. I'll think a new patch for this.

Thanks.

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
