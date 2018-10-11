Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33125 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbeJLGia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 02:38:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id l14-v6so836115edq.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 16:09:01 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id s12-v6sm8452562edd.39.2018.10.11.16.08.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Oct 2018 16:08:59 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id y20-v6so9797297eds.10
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 16:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
 <20181011195859.GA114854@rodete-desktop-imager.corp.google.com> <b6ee7861-3bf0-7192-d26e-5d57bcb10d19@sandeen.net>
In-Reply-To: <b6ee7861-3bf0-7192-d26e-5d57bcb10d19@sandeen.net>
From: Brian Norris <briannorris@chromium.org>
Date: Thu, 11 Oct 2018 16:08:48 -0700
Message-ID: <CA+ASDXNermsMZsSOgCxJQkFrvXUG5ej+Ttfdav0tmGeGGqLKFA@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: don't include all xfs headers just for crc32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Oct 11, 2018 at 3:36 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> Thanks.  At this point I think you have a better grasp of what all the
> $FOO_FLAGS do than I do ;)  It may be  to keep things sorted
> and separate, but it also seemed useful to get a giant tangle of
> xfs header out of a non-xfs library file.

Yep! I'm happy with this patch. If I'm bothered enough, I can still
send another patch to sort out the flags further.

> I'm also on the fence about whether cross-compiling the self-check
> really even gains us much, given that it may be built or optimized
> completely differently from the code on the target arch ...

I don't have a whole lot of opinion here.

Regards,
Brian
