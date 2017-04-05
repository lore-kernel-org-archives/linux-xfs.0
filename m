Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36695 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933081AbdDENAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 09:00:49 -0400
Received: by mail-vk0-f41.google.com with SMTP id s68so6400709vke.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2017 06:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96ddb2a7-d93e-3ba4-6845-eb60d9558f60@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-2-jtulak@redhat.com>
 <96ddb2a7-d93e-3ba4-6845-eb60d9558f60@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 5 Apr 2017 15:00:27 +0200
Message-ID: <CACj3i720P-iC0UMFhx8QQEp7CPPXVe2SN298C7oWgxoxEVqFHg@mail.gmail.com>
Subject: Re: [PATCH 01/22] mkfs: remove intermediate getstr followed by getnum
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2017 at 11:59 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> The only downside I see to this is that we used to echo back the same
> form that was specified, i.e. -
>
> # mkfs.xfs -f -d size=4e fsfile
> size 4e specified for data subvolume is too large, maximum is 262144 blocks
> # mkfs.xfs -f -d size=4611686018427387904 fsfile
> size 4611686018427387904 specified for data subvolume is too large, maximum is 262144 blocks
> # mkfs.xfs -f -d size=1125899906842624b fsfile
> size 1125899906842624b specified for data subvolume is too large, maximum is 262144 blocks
>
> now we always get back the raw byte value:
>
> # mkfs/mkfs.xfs -f -d size=4e fsfile
> size 4611686018427387904 specified for data subvolume is too large, maximum is 262144 blocks
>
> Anything that fails the getnum() checks echo back the original
> form on the cmdline; this case is different because getnum() passes,
> but by the time we do value checking all we have is the bytes.  Is
> that intentional/desirable?
>
> So it's a change, not necessarily incorrect or unacceptable, but
> I wanted to highlight it and check.  It wouldn't be too hard to
> convert it right away, but keep the string around for error printing
> purposes, I suppose.
>

It goes back into the original reporting style later in the set. I
tried to change the patch to avoid this temporary change, but the
issue is, I loose the old raw strings before I have access to the
necessary indexes for the option table to read the raw string from it,
or before a code shuffling brings the reporting closer to where the
raw string still exists.

Given that it is only a temporary change of style and it seems to be
too deeply depending on other changes, I'm keeping it as a TODO, but
not a blocker. Maybe if the patch can be split and one of the parts
moved after other commits...

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
