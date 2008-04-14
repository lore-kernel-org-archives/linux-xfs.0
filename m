Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 18:42:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E1g46h027294
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 18:42:07 -0700
Subject: Re: REVIEW XFSQA test out xfs_attr_shortform_bytesfit attr2/attr1 fix
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <47FC79FC.5020803@sgi.com> <20080410053601.GK108924158@sgi.com> <4802B4E8.3070807@sgi.com>
Date: Mon, 14 Apr 2008 11:46:30 +1000
Message-ID: <op.t9ku7su93jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <4802B4E8.3070807@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>, David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asgqa@sgi.com>

On Mon, 14 Apr 2008 11:35:36 +1000, Timothy Shimmin <tes@sgi.com> wrote:

> Hi Dave and Barry,
>
> David Chinner wrote:
>> On Wed, Apr 09, 2008 at 06:10:36PM +1000, Timothy Shimmin wrote:
>>> Hi there,
>>>
>>> A test to test out Eric's fix for xfs_attr_shortform_bytesfit
>>> bug when going from attr2 to attr1.
>>>
>>> With TOT kernel, without patch, one can see the corrupted inline
>>> dirents. With patch, all is well.
>>>
>>> The 186.out _should_ be output'ing ATTR2 for the db version
>>> command but I'm awaiting Barry's xfsprogs checkin to fix that one -
>>> and then I will regenerate it.
>>  Really? I'm seeing it fail with ATTR2 in the xfs_db output...
>>
> That's what I used to see until I updated to TOT kernel.
> That's weird.
> And I don't know why ATTR and ATTR2 is coming out either.
> I assume it is all about the recent version 2 changes,
> and what was done in userspace and in the kernel.
> Barry, can you enlighten us here?
> Do we have latest changes for xfs_db and mkfs now?
> That's why I was waiting to ensure I had the latest user changes;
> it feels like xfs_db is getting things wrong as the
> mkfs and kernel behaviour seems to be behaving like I expected.

I'll now checkin the latest sb_bad_features2 patches for user-space.
With Dave's kernel changes, should be quite compatible now.

> --Tim
>
>> dgc@budgie:~/xfstests$ sudo ./check 186
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/ia64 budgie 2.6.25-rc3-dgc-xfs
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
>> MOUNT_OPTIONS -- /dev/sdb6 /mnt/scratch
>>  186      - output mismatch (see 186.out.bad)
>> 13a14
>>> ATTR2
>> 98a100
>>> ATTR2
>> Failures: 186
>> Failed 1 of 1 tests
>> dgc@budgie:~/xfstests$
>>  So the first is supposed to be there, but the second shows:
>>  ....
>> =================================
>> ATTR
>> ATTR2
>> core.forkoff = 47
>> ....
>>  Are both supposed to be present?
>>  Cheers,
>>  Dave.
>
