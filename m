Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 16:51:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L0pihX021203
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 16:51:49 -0800
Date: Mon, 21 Jan 2008 11:52:19 +1100
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com> <200801181905.05263.Martin@lichtvoll.de>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t488phjj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <200801181905.05263.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

On Sat, 19 Jan 2008 05:05:04 +1100, Martin Steigerwald  
<Martin@Lichtvoll.de> wrote:

>
> Hi Barry!
>
> Am Freitag 18 Januar 2008 schrieb Barry Naujok:
>
>> There are two mount options for enabling case-insensitivity
>> on a Unicode XFS filesystem:
>>    - "ci" - enables case-insensitivity for file names
>>    - "ciattr" - enables case-insensitivity for extended
>>                 attributes.
>
> How do I know that I am on an Unicode XFS filesystem. Could I see this
> with xfs_db -r -c 'sb 0' -c p <device>? Hmm, nothing unicode related in
> there as far as I can see. The fs was created with 2.6.23, mkfs.xfs 2.9.4
> and the mkfs options that David suggested.

Good point, xfs_info should report this info.

> Do I need to backup / mkfs / restore to switch to one? I understand that  
> I
> can switch between enable / disable case-insensitivity via a mount
> option. Would I be able to enable unicode via xfs_db version command or
> something like it?
>
> Just curious.

Strictly speaking you do need to do backup/mkfs/restore to get utf8.
But, with xfs_db hackery and xfs_repair, you can actually switch between
them without mkfsing (I never said that ;) )

Once your filesystem is unicode, ci is a mount option that can be turned
on/off.

Barry.
