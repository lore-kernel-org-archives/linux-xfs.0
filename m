Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-3.ukservers.net ([217.10.138.152]:60344 "EHLO
        auth-3.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbeANVdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Jan 2018 16:33:23 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
From: Wol's lists <antlists@youngman.org.uk>
Message-ID: <37abf496-57aa-fd12-26b7-09d43f08e6d5@youngman.org.uk>
Date: Sun, 14 Jan 2018 21:33:17 +0000
MIME-Version: 1.0
In-Reply-To: <20180112152538.2c4d8cd4@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 12/01/18 14:25, Emmanuel Florac wrote:
>> My point is that all this causes geometries to change, and ext and
>> btrfs amongst others can clearly handle this. Can XFS?

> Neither XFS, ext4 or btrfs can handle this. That's why Dave mentioned
> the fact that growing your RAID is almost always the wrong solution.
> A much better solution is to add a new array and use LVM to aggregate
> it with the existing ones.

Does the new array need the same geometry as the old one?

What happens if my original array is a 4-disk raid-5, and then I add a 
3-disk raid-5? Can XFS cope with the different optimisations required 
for the different layouts on the different arrays?
> 
> Basically growing an array then the filesystem on it generally works
> OK, BUT it may kill performance (or not). YMMV. At least, you *probably
> won't* get the performance gain that the difference of stripe width
> would permit when starting anew.
> 
Cheers,
Wol
