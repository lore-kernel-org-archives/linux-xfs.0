Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:32879 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932654AbcKYRJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Nov 2016 12:09:09 -0500
Received: by mail-io0-f171.google.com with SMTP id j65so134019716iof.0
        for <linux-xfs@vger.kernel.org>; Fri, 25 Nov 2016 09:09:09 -0800 (PST)
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
 <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
 <ca974620-fff5-e26b-897d-c1c62d47cc64@binghamton.edu>
 <20161125111814.p7ltczag7akqk3w5@eorzea.usersys.redhat.com>
 <264e0ba1-f3ea-b320-1c22-c1e23e74ffa6@binghamton.edu>
From: Dave Hall <kdhall@binghamton.edu>
Message-ID: <14553049-ef53-5594-61a7-a91394b66d95@binghamton.edu>
Date: Fri, 25 Nov 2016 12:09:10 -0500
MIME-Version: 1.0
In-Reply-To: <264e0ba1-f3ea-b320-1c22-c1e23e74ffa6@binghamton.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>


-- 
Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)

On 11/25/16 10:20 AM, Dave Hall wrote:
>
>
> On 11/25/16 6:18 AM, Carlos Maiolino wrote:
>>>> > > Regarding thing-provisioning, there are a couple things that 
>>>> you should keep in
>>>> > > mind.
>>>> > >
>>>> > > - AGs segment the metadata across a whole disk, and increase 
>>>> parallelism in the
>>>> > >   filesystem, but, thin-provisioning will make such allocations 
>>>> sequential,
>>>> > >   despite where in the block device the filesystem tries to 
>>>> write, this is the
>>>> > >   nature of thin-provisioning devices so, I believe you should 
>>>> be more careful
>>>> > >   planning your DM-thin structure than the filesystem itself.
>>> >
>>> > So it sounds like I should used striping for my logical volume to 
>>> assure
>>> > that data is distributed across the whole physical array?
>> I'm not sure if I understand you question here, what kind of 
>> architecture you
>> have in your mind. All thin-provisioning allocation are sequential, 
>> block
>> requested, next block available served (although with the recent 
>> dm-thin versions
>> it will serve blocks in bundles, not on a block-by-block granularity 
>> anymore,
>> but it is still a sequential alignment.
>>
>> I am really not sure what you have in mind to 'force' the 
>> distribution across
>> the whole physical array. The only thing I could think was to have 2 
>> dm-thin
>> devices, on different pools, and use them to build a stripped LVM. I 
>> don't know
>> if it is possible tbh, I never tried such configuration, but it's a 
>> setup bound
>> to have problems IMHO.
>>
>
> Currently I have 4 LVM PVs that are mapped to explicit groups of 
> physical disks (RAID 5) in my array.  I would either stripe or 
> concatenate them together and create a single large DM-Thin LV and 
> format it for XFS.
>
> If the PVs are concatenated it sounds like DM-Thin would fill up the 
> first PV before moving to the next.  It seems that DM-Thin on striped 
> PVs would assure that disk activity is spread across all of the PVs 
> and thus across all of the physical disks.  Without DM-Thin, an XFS on 
> concatenated PVs would probably tend to organize an AGs into single 
> PVs which would spread disk activity across all of the physical disks, 
> just in a different way.
>
I'd like to add some clarification just to be sure...

The configuration strategy I've been using for my physical storage array 
is to map specific disks into a small RAID group and define a single LUN 
per RAID group.  Thus, each LUN presented to the server is currently 
mapped to a group of 5 disks in RAID 5.

If I understand correctly an LVM Logical Volume presents a single linear 
storage space to the file system (XFS) regardless of the underlying 
storage organization.  XFS divides this space into a number of 
Allocation Groups that it perceives to be contiguous sub-volumes within 
the Logical Volume.

With a concatenated LV most AGs would be mapped to a single PV, but XFS 
would still disperse disk activity across all AGs and thus across all 
PVs.  With a striped LV each AG would be striped across multiple PVs, 
which would change the distribution of disk activity across the PVs but 
still lead to all PVs being fairly active.

With DM-Thin, things would change.  XFS would perceive that it's AGs 
were fully allocated, but in reality new chunks of storage would be 
allocated as needed.  If DM-Thin uses a linear allocation algorithm on a 
concatenated LV it would seem that certain kinds of disk activity would 
tend to be concentrated in a single PV at a time.  On the other hand, 
DM-Thin in a striped LV would tend to spread things around more evenly 
regardless of allocation patterns.

Please let me know if this perception is accurate.

Thanks.

