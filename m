Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:41073 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbeCORB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 13:01:28 -0400
Received: by mail-wr0-f177.google.com with SMTP id f14so9004169wre.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 10:01:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314152504.GP4865@magnolia>
References: <20180305215659.GE18129@dastard> <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard> <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard> <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <20180308162838.GY18989@magnolia> <20180308223652.GT18129@dastard>
 <CACj3i720ppnLEyF0k7Sv7Nf27SubnpC+N2A=7Y60st+ncGCG7w@mail.gmail.com> <20180314152504.GP4865@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 15 Mar 2018 18:01:05 +0100
Message-ID: <CACj3i73tCKkF=+H9ahfLjLCNvNupYYpSJnLWm_hxWQVe8yow8w@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 14, 2018 at 4:25 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>> through -vvvv output, but that doesn't look like a sensible solution -
>> too many things that could be missed if it is an issue and we need to
>> watch out for corrections that requires a reboot.
>>
>> And another thing is that after we drop the user into the shell, they
>> won't see any message directly I think but will have to read the logs
>> to see the "Errors corrected, You must reboot now!"
>
> Hopefully the repair output was the last thing printed on the screen
> before we started the shell?
>

Sadly, not in all distros. What you see in Fedora is that a service
failed and "see 'systemctl status systemd-fsck-root.service' for
details" followed by some other status reports for other things. It at
least points you in the right direction and in the log you can see the
fsck.xfs and xfs_repair output. But I doubt there is any other option,
and at least it is in the log if not on the screen.

Jan
