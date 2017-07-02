Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35161 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbdGBQk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jul 2017 12:40:28 -0400
Received: by mail-wm0-f53.google.com with SMTP id w126so148657924wme.0
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jul 2017 09:40:28 -0700 (PDT)
Subject: Re: Any tips for moving to reflink?
References: <20170701023529.GP5874@birch.djwong.org>
 <03eb6ac0-6c6e-0494-b008-25a187b43e12@enkore.de>
 <20170701163802.GX5874@birch.djwong.org>
From: Marian Beermann <public@enkore.de>
Message-ID: <e8fbb00d-4fe3-19e4-47ee-3dc65e2636b4@enkore.de>
Date: Sun, 2 Jul 2017 18:40:25 +0200
MIME-Version: 1.0
In-Reply-To: <20170701163802.GX5874@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 01.07.2017 18:38, Darrick J. Wong wrote:
> On Sat, Jul 01, 2017 at 01:41:43PM +0200, Marian Beermann wrote:
>> Hi
>>
>>>> I'm planning to use this reflink feature for instant local snapshots
>>>> and then use my backup software of choice, borg, to keep a long time
>>>> history of my work on a remote server. Since borg stores data in a
>>>> dedup fashion I can also backup the reflink snapshots and they won't
>>>> take additional space. The only drawback is that today borg need to
>>>> hash all the files found in a reflink directory in order to find out
>>>> about dedup blocks. I asked a question on the borg mailing list
>>>> https://github.com/borgbackup/borg/issues/2743 and apparently it
>>>> won't be an issue to add a feature to support XFS in order to
>>>> identify the physical extents. Is rmapbt required for that?
>>>
>>> borgbackup will probably need to call the GETFSMAP ioctl, which won't
>>> land until 4.12.  On xfs, rmapbt is needed to supply data block
>>> ownership info, which is what borgbackup (and bees, and...) say they
>>> want to be smarter about dedup.
>>
>> My understanding so far was that FIEMAP would be sufficient to query the
>> extents associated with a file. Shouldn't this be sufficient to know
>> whether two files on the same file system refer to the same data?
> 
> Not necessarily -- FIEMAP provides physical offset into a device but
> does not actually identify which one, which is a problem on multi-device
> filesystems such as btrfs and XFS.  IIRC btrfs creates a virtual
> physical offset space consisting of all the devices one after the other,
> but then you have to know /that/ mapping too.  GETFSMAP by contrast
> tells you which device and where on that device.
> 

I see. If FIEMAP reports same data, while describing different data,
then it certainly breaks one of the main uses of it (detecting identical
data)?

To clarify the intended;

Borg would essentially hash the output of FIEMAP/GETFSMAP for a given
file and compare this hash with a previous hash.

If the two hashes don't match,
then Borg would re-process the entire file.

It'd be possible to make this more granular, on a per-extent basis

Cheers, Marian
