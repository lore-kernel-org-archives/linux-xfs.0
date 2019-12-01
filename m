Return-Path: <SRS0=WxS8=ZX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5318DC432C0
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 09:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ADC42073C
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 09:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="nYUadp9b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfLAJAq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Dec 2019 04:00:46 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43210 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLAJAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Dec 2019 04:00:46 -0500
Received: by mail-io1-f67.google.com with SMTP id s2so1305039iog.10
        for <linux-xfs@vger.kernel.org>; Sun, 01 Dec 2019 01:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1cTT5jzYo3sBnCkymXWbf8E8p09cj/hZ5wODHFfmYaQ=;
        b=nYUadp9b9wb1HkZkVyPIEZOLcvvb2qz9AJYhvLAay2+YJsx8Pi+Cw7M4gn1i1TkJwf
         XQIMvyYUQm9MuHhZhmEZz6p5cwBOO+wmZ4o8L0GOsGoZjZIh/ijhg86tP8NJL2m/VeZp
         RD7sy0I37+yYnuq+JQoRO8v2kan2D8eMTe9Lo5HMFuHQdH/6MkZt9s6O9VCdh+iX/33t
         ceUAnqPDzn3FergYAcELeeFwCLBfyC/djkbpRP0e6xClCeowdhsCN13rjwIuTLUAj7c0
         8GEJaZw7WLtr1+5OApf1Zz+9PNzu4ariLJf8kjsowEtH2U7xXR3X8MqyRrDMBpOnYQN+
         phdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1cTT5jzYo3sBnCkymXWbf8E8p09cj/hZ5wODHFfmYaQ=;
        b=SVpUFzJeT58hoAxo2GbH8z5xGKSEe8VERyxBVMYpriKx7KmZNshFg7RxXuHZsuZYS1
         IMyH08o2h50EYqQYec+twEVFpiLWSgHtswNenpE5QfKI957wkZU//vIi+ggdNl1BshIr
         8TW3NB4p5XzEHKCuJeK3HczenntIOcUBpzp1HhK0FAqHTEhbOoGvQS9Ws3PiPL/S5WRe
         l+AHHsi6qbWkFR/5n9o6R+6WIzCQVF6bhobskv90clHgxBZ/aRDA1HBsSWPqVpeiXrnB
         apFBvBaLnELYrKfprDjOJxX2w3pHuYSE4xXPSYeFg8A9gyTUFnxzVBD3B4jWPwN9HVLn
         H6EA==
X-Gm-Message-State: APjAAAXjyCBF09IIy1/eMsUQCveUOZfuPpL4OYScYMnGOzyIiELF0POu
        vB8YPfJ15gz2yNv+CRzIxmetQbSMIE+CuWHH/2ebodCH
X-Google-Smtp-Source: APXvYqyGWZs1SGsm5cyk3+Ljp9uZ7z83DtWqqdvBSElHsK6jPwwKbAuup1yA8/Y7DSBOL3/Hw/QIgQwffrbGGmyKbnI=
X-Received: by 2002:a6b:b802:: with SMTP id i2mr21224144iof.20.1575190843770;
 Sun, 01 Dec 2019 01:00:43 -0800 (PST)
MIME-Version: 1.0
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster> <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster> <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster> <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net> <20191127141929.GA20585@infradead.org>
 <20191130202853.GA2695@dread.disaster.area>
In-Reply-To: <20191130202853.GA2695@dread.disaster.area>
From:   Alex Lyakas <alex@zadara.com>
Date:   Sun, 1 Dec 2019 11:00:32 +0200
Message-ID: <CAOcd+r21Ur=jxvJgUdXs+dQj37EnC=ZWP8F45sLesQFJ_GCejg@mail.gmail.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for your response.

On Sat, Nov 30, 2019 at 10:28 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Nov 27, 2019 at 06:19:29AM -0800, Christoph Hellwig wrote:
> > Can we all take a little step back and think about the implications
> > of the original patch from Alex?  Because I think there is very little.
> > And updated sunit/swidth is just a little performance optimization,
> > and anyone who really cares about changing that after the fact can
> > trivially add those to fstab.
> >
> > So I think something like his original patch plus a message during
> > mount that the new values are not persisted should be perfectly fine.
>
> Well, the original purpose of the mount options was to persist a new
> sunit/swidth to the superblock...
>
> Let's ignore the fact that it was a result of a CXFS client mount
> bug trashing the existing sunit/swidth values, and instead focus on
> the fact we've been telling people for years that you "only need to
> set these once after a RAID reshape" and so we have a lot of users
> out there expecting it to persist the new values...
>
> I don't think we can just redefine the documented and expected
> behaviour of a mount option like this.
>
> With that in mind, the xfs(5) man page explicitly states this:
>
>         The sunit and swidth parameters specified must be compatible
>         with the existing filesystem alignment characteristics.  In
>         general,  that  means  the  only  valid changes to sunit are
>         increasing it by a power-of-2 multiple. Valid swidth values
>         are any integer multiple of a valid sunit value.
>
> Note the comment about changes to sunit? What is being done here -
> halving the sunit from 64 to 32 blocks is invalid, documented as
> invalid, but the kernel does not enforce this. We should fix the
> kernel code to enforce the alignment rules that the mount option
> is documented to require.
>
> If we want to change the alignment characteristics after mkfs, then
> use su=1,sw=1 as the initial values, then the first mount can use
> the options to change it to whatever is present after mkfs has run.

If I understand your response correctly:
- some sunit/swidth changes during mount are legal and some aren't
- the legal changes should be persisted in the superblock

What about the repair? Even if user performs a legal change, it still
breaks the repairability of the file system.

For now, we made a local change to not persist sunit/swidth updates in
the superblock. Because we must have a working repair, and our kernel
(4.14 stable) allows any sunit/swidth changes.

We can definitely adhere to the recommended behavior of setting
sunit/swidth=1 during mkfs, provided the repair still works after
mounting with different sunit/swidth.

Thanks,
Alex.




>
> Filesystems on storage that has dynamically changeable geometry
> probably shouldn't be using fixed physical alignment in the first
> place, though...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
