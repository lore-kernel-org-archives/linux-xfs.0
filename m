Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 00:03:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8J72maG019244
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 00:02:50 -0700
Message-ID: <450F9617.2020603@sgi.com>
Date: Tue, 19 Sep 2006 17:02:47 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu> <450F1A1F.1020204@agami.com> <450F7C1E.5020300@sgi.com> <450F91D4.1030606@agami.com>
In-Reply-To: <450F91D4.1030606@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: cousins@umit.maine.edu, "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>

Shailendra Tripathi wrote:
> 
> Hi Tim,
> 
>> I'm not that au fait with RAID and md, but looking at what you wrote,
>> Shailendra, and the md code, instead of your suggestions
>> (what I think are your suggestions:) of:
>>
>> (1) subtracting parity from md.raid_disk (instead of md.nr_disks)
>>     where we work out parity by switching on md.level
>> or
>> (2) using directly: (md.nr_disks - md.spares);
>>
>> that instead we could use:
>> (3) using directly:  md.active_disks
>>
>> i.e.
>> *swidth = *sunit * md.active_disks;
>> I presume that active is the working non spares and non-parity.
>>
>> Does that make sense?
>       I agree with you that for operational raid since there would not 
> be any faulty disks, active disks should the number of disks. However, I 
> am just concerned that active disks tracks live disks (not failed 
> disks). If we ever used these commands when the system has faulty drive, 
> the information returned wouldn't be correct. Though, from XFS 
> perspective, I can't think of where it can happen.
>       I would still say that lets rely more on raid_disks to be more 
> conservative, just my choice.

I see your point.
I can just change md_get_subvol_stripe(): s/nr_disks/raid_disks/
I just liked the idea of removing the switch statement which could
potentially get out of date in the future. Too bad :)

--Tim
