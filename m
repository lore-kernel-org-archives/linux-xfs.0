Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.stoffel.org ([104.236.43.127]:40480 "EHLO mail.stoffel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbeAIVyT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 16:54:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23125.14428.570478.379095@quad.stoffel.home>
Date: Tue, 9 Jan 2018 16:47:08 -0500
From: "IMAP-FCC:Sent"@stoffel.org
Subject: Re: Growing RAID10 with active XFS filesystem
In-Reply-To: <5A548D31.4000002@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
        <20180108192607.GS5602@magnolia>
        <20180108220139.GB16421@dastard>
        <5A548D31.4000002@youngman.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 08/01/18 22:01, Dave Chinner wrote:
>> Yup, 21 devices in a RAID 10. That's a really nasty config for
>> RAID10 which requires an even number of disks to mirror correctly.
>> Why does MD even allow this sort of whacky, sub-optimal
>> configuration?

Wols> Just to point out - if this is raid-10 (and not raid-1+0 which is a
Wols> completely different beast) this is actually a normal linux config. I'm
Wols> planning to set up a raid-10 across 3 devices. What happens is that is
Wols> that raid-10 writes X copies across Y devices. If X = Y then it's a
Wols> normal mirror config, if X > Y it makes good use of space (and if X < Y
Wols> it doesn't make sense :-)

Wols> SDA: 1, 2, 4, 5
Wols> SDB: 1, 3, 4, 6
Wols> SDC: 2, 3, 5, 6

This is a nice idea, but honestly, I think it's just asking for
trouble down the line. It's almost more like RAID4 in some ways, but
without parity, just copies.

So I suspect that the problem that's happened here is that some bug in
RAID10 has been found when you do a re-shape (on an old kernel,
RHEL6? Debian?  Not clear...) with a large number of devices.  Since
you have to re-balance the data as new disks are added... it might get
problematic.

In any case, I would recommend that you simple setup RAID1 pairs, then
pull them all into a VG, then create an LV which spans all the RAID1
pairs.  Then you can add new pairs to the system easily and
grow/shrink the array easily.

This also lets you replace the 2tb disks with 4tb or larger disks more
easily as time goes on.  And of course I'd *also* put in some hot
spares.

But then again, if this is just a dumping ground for data with mostly
reads, or just large sequential writes (say for media, images, video,
etc) then going to RAID6 sets (say 10 or so per) which you THEN stripe
over using LVM is a better way to go.

I'll see if I can find some time to try setting up a bunch of test
loop devices on my own to see what happens here.  But I'm also running
newer kernel and Debian Jessie distribution.

But it will probably be Neil who needs to debug the real issue, I
don't know the code well at all.

John
