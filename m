Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 18:33:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0G2Wvpa029749
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 18:33:00 -0800
Date: Wed, 16 Jan 2008 13:33:50 +1100
Subject: Re: [REVIEW] Refactor xfs_repair's process_dinode_int
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <4782B72D.8070208@agami.com> <47833C0F.6070206@agami.com> <op.t4m0r1an3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D1899.9080201@agami.com> <op.t4zzbvbs3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t4z32owo3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t4zzbvbs3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chandan Talukdar <chandan@agami.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, 16 Jan 2008 11:51:21 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> On Wed, 16 Jan 2008 07:33:29 +1100, Chandan Talukdar <chandan@agami.com>  
> wrote:
>
>> Hi Barry,
>>
>> - In process_dinode_int(), we should be checking for 'dblkmap' not  
>> being NULL before freeing it.  There are a few error conditions which  
>> can cause the control to go to 'clear_bad_out' with dblkmap being NULL.
>
> freeing a NULL is valid

My bad! Yes, blkmap_free() doesn't check for a NULL pointer before going
through the structure. I'll fix this up.

Regards,
Barry.
