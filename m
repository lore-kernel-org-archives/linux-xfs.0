Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 18:35:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E1Z1ak026391
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 18:35:03 -0700
Message-ID: <4802B4E8.3070807@sgi.com>
Date: Mon, 14 Apr 2008 11:35:36 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW XFSQA test out xfs_attr_shortform_bytesfit attr2/attr1
 fix
References: <47FC79FC.5020803@sgi.com> <20080410053601.GK108924158@sgi.com>
In-Reply-To: <20080410053601.GK108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, "bnaujok@sgi.com via BugWorks" <bnaujok@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asgqa@sgi.com>

Hi Dave and Barry,

David Chinner wrote:
> On Wed, Apr 09, 2008 at 06:10:36PM +1000, Timothy Shimmin wrote:
>> Hi there,
>>
>> A test to test out Eric's fix for xfs_attr_shortform_bytesfit
>> bug when going from attr2 to attr1.
>>
>> With TOT kernel, without patch, one can see the corrupted inline
>> dirents. With patch, all is well.
>>
>> The 186.out _should_ be output'ing ATTR2 for the db version
>> command but I'm awaiting Barry's xfsprogs checkin to fix that one -
>> and then I will regenerate it.
> 
> Really? I'm seeing it fail with ATTR2 in the xfs_db output...
> 
That's what I used to see until I updated to TOT kernel.
That's weird.
And I don't know why ATTR and ATTR2 is coming out either.
I assume it is all about the recent version 2 changes,
and what was done in userspace and in the kernel.
Barry, can you enlighten us here?
Do we have latest changes for xfs_db and mkfs now?
That's why I was waiting to ensure I had the latest user changes;
it feels like xfs_db is getting things wrong as the
mkfs and kernel behaviour seems to be behaving like I expected.

--Tim

> dgc@budgie:~/xfstests$ sudo ./check 186
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/ia64 budgie 2.6.25-rc3-dgc-xfs
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
> MOUNT_OPTIONS -- /dev/sdb6 /mnt/scratch
> 
> 186      - output mismatch (see 186.out.bad)
> 13a14
>> ATTR2
> 98a100
>> ATTR2
> Failures: 186
> Failed 1 of 1 tests
> dgc@budgie:~/xfstests$
> 
> So the first is supposed to be there, but the second shows:
> 
> ....
> =================================
> ATTR
> ATTR2
> core.forkoff = 47
> ....
> 
> Are both supposed to be present?
> 
> Cheers,
> 
> Dave.
