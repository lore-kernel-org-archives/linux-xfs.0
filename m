Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46899 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725726AbeLBIGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 03:06:00 -0500
Subject: Re: block layer API for file system creation - when to use multidisk
 mode
References: <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
 <20181005232710.GH12041@dastard>
 <CAOi1vP-Z7xZk1YvWHYWQGOHfyWccFCkyn8je0HBvGhGuUrXmaQ@mail.gmail.com>
 <20181006232037.GB18095@dastard>
 <36bc3f17-e7d1-ce8b-2088-36ff5d7b1e8b@sandeen.net>
 <0290ec9f-ab2b-7c1b-faaf-409d72f99e5f@gmail.com>
 <20181129214851.GU6311@dastard>
 <39031e68-3936-b5e1-bcb6-6fdecc5988c1@gmail.com>
 <20181130022510.GW6311@dastard>
 <3da04164-a89f-f4c0-1529-eab12b3226e1@gmail.com>
 <20181201043509.GZ6311@dastard>
From: Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <80505ddf-8c6f-50d7-1e6d-2e50e7349c6f@gmail.com>
Date: Sat, 1 Dec 2018 15:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <20181201043509.GZ6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Ilya Dryomov <idryomov@gmail.com>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org

On 11/30/18 11:35 PM, Dave Chinner wrote:
> On Fri, Nov 30, 2018 at 01:00:52PM -0500, Ric Wheeler wrote:
>> On 11/30/18 7:55 AM, Dave Chinner wrote:
>>> On Thu, Nov 29, 2018 at 06:53:14PM -0500, Ric Wheeler wrote:
>>>> Other file systems also need to
>>>> accommodate/probe behind the fictitious visible storage device
>>>> layer... Specifically, is there something we can add per block
>>>> device to help here? Number of independent devices
>>> That's how mkfs.xfs used to do stripe unit/stripe width calculations
>>> automatically on MD devices back in the 2000s. We got rid of that
>>> for more generaly applicable configuration information such as
>>> minimum/optimal IO sizes so we could expose equivalent alignment
>>> information from lots of different types of storage device....
>>>
>>>> or a map of
>>>> those regions?
>>> Not sure what this means or how we'd use it.
>>> Dave.
>> What I was thinking of was a way of giving up a good outline of how
>> many independent regions that are behind one "virtual" block device
>> like a ceph rbd or device mapper device. My assumption is that we
>> are trying to lay down (at least one) allocation group per region.
>>
>> What we need to optimize for includes:
>>
>>      * how many independent regions are there?
>>
>>      * what are the boundaries of those regions?
>>
>>      * optimal IO size/alignment/etc
>>
>> Some of that we have, but the current assumptions don't work well
>> for all device types.
> Oh, so essential "independent regions" of the storage device. I
> wrote this in 2008:
>
> http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption#Failure_Domains
>
> This was derived from the ideas in prototype code I wrote in ~2007
> to try to optimise file layout and load distribution across linear
> concats of multi-TB RAID6 luns. Some of that work was published
> long after I left SGI:
>
> https://marc.info/?l=linux-xfs&m=123441191222714&w=2
>
> Essentially, independent regions - called "Logical
> Extension Groups", or "legs" of the filesystem - and would
> essentially be an aggregation of AGs in that region. The
> concept was that we'd move the geometry information from the
> superblock into the legs, and so we could have different AG
> geoemetry optimies for each independent leg of the filesystem.
>
> eg the SSD region could have numerous small AGs, the large,
> contiguous RAID6 part could have maximally size AGs or even make use
> of the RT allocator for free space management instead of the
> AG/btree allocator. Basically it was seen as a mechanism for getting
> rid of needing to specify block devices as command line or mount
> options.
>
> Fundamentally, though, it was based on the concept that Linux would
> eventually grow an interface for the block device/volume manager to
> tell the filesystem where the independent regions in the device
> were(*), but that's not something that has ever appeared. If you can
> provide an indepedent region map in an easy to digest format (e.g. a
> set of {offset, len, geometry} tuples), then we can obviously make
> use of it in XFS....
>
> Cheers,
>
> Dave.
>
> (*) Basically provide a linux version of the functionality Irix
> volume managers had provided filesystems since the late 80s....
>
Hi Dave,

This is exactly the kind of thing I think would be useful.  We might want to 
have a distinct value (like the rotational) that indicates this is a device with 
multiple "legs" so that normally we query that and don't have to look for the 
more complicated information.

Regards,

Ric
