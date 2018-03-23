Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:39206 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbeCWOA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 10:00:26 -0400
Received: by mail-wr0-f173.google.com with SMTP id c24so12239012wrc.6
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 07:00:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323034251.GI4818@magnolia>
References: <20180315182850.36783-1-jtulak@redhat.com> <20180316170720.44227-1-jtulak@redhat.com>
 <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net> <20180323032548.GG4818@magnolia>
 <f68aab96-7a08-26ee-2b9c-dfe291689506@sandeen.net> <20180323034251.GI4818@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 23 Mar 2018 15:00:04 +0100
Message-ID: <CACj3i72qrFecUopHtw_BUaiRqMJmR2UR=FHTdjWvgWVzgtDfsA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v5] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 23, 2018 at 4:42 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Mar 22, 2018 at 10:29:27PM -0500, Eric Sandeen wrote:
>>
>>
>> On 3/22/18 10:25 PM, Darrick J. Wong wrote:
>> >> It make sense to check that it's available before running it, but I think
>> >> hardcoding paths runs the risk of missing it if it's somewhere unique.
>>
>> > OTOH hardcoding the path (since we control where xfs_repair gets
>> > installed) means that we avoid the "someone poisoned PATH" attack.  I'm
>> > not sure I buy that argument since if you have root access you probably
>> > can just bind mount a garbage atop /sbin/xfs_repair, but eh.
>>
>> But this is the initramfs, right?  Do we really have any idea where things
>> land?  Do initramfs paths follow the installed system paths?  (maybe?)
>
> They land wherever the initramfs construction script puts them, though
> at least on Debian the binaries are usually put in the same places as
> they are on the rootfs.  Not sure about dracut. :)
>

AFAICT in the few cases I saw (Debian based distros, Fedora, Arch),
the paths were always the same on the rootfs and initramfs. But yeah,
I agree that it's better to avoid hardcoding. I didn't know about
"command -v", and "which" is not usually present, so I went with
hardcoding rather than implement it on my own. Which is no issue
now...

Jan
