Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36382 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754553AbcKYOvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Nov 2016 09:51:01 -0500
Received: by mail-io0-f170.google.com with SMTP id x94so128327808ioi.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Nov 2016 06:50:17 -0800 (PST)
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
 <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
 <20161124194419.GR28177@dastard>
From: Dave Hall <kdhall@binghamton.edu>
Message-ID: <96f2ee29-7f75-500d-3ac2-687632ece24b@binghamton.edu>
Date: Fri, 25 Nov 2016 09:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <20161124194419.GR28177@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 11/24/16 2:44 PM, Dave Chinner wrote:
>>> - I've read that there are tricks and calculations for aligning XFS to the
>>> > > RAID stripes.  Can use suggest any guidelines or tools for calculating the
>>> > > right configuration?
>> >
>> > There is no magical trick :), you need to configure Stripe unit and stripe width
>> > according to your raid configuration. You should set stripe unit (su option) to
>> > the size of the stripes on your raid, and set the stripe width (sw option)
>> > according to the number of data disks on your array (if you have a 4+1 raid 5,
>> > it should be 4, into a 8+2 raid 6, it should be 8).
> mkfs.xfs will do this setup automatically on software raid and any
> block device that exports the necessary information to set it up.
> In general, it's only older/cheaper hardware RAID that you have to
> worry about this anymore.
>
So how do we know for sure?  Is there a way that we can be sure that the 
hardware RAID has exported this information?  In lieu of this, is there 
a solid way to deduce or test for correct alignment?
