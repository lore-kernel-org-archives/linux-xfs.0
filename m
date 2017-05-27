Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33372 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753330AbdE0HlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 May 2017 03:41:23 -0400
Received: by mail-ua0-f179.google.com with SMTP id e28so16010264uah.0
        for <linux-xfs@vger.kernel.org>; Sat, 27 May 2017 00:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
References: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Sat, 27 May 2017 09:41:02 +0200
Message-ID: <CACj3i71pW6JxNFzfPMwJW1qz9U54pO2i94_ihhcsb_FwOn_3PQ@mail.gmail.com>
Subject: Re: RFC: removing non-linux platform support from xfsprogs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 26, 2017 at 11:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> There's a bunch of mucking about to try to build xfsprogs on non-linux
> platforms.  Is anyone using that, or care about it?  If not, I propose
> removing it all in a cruft-reducing effort.
>
> If I'm missing some good reason for it to be there, please educate me,
> and I'll leave it alone.
>
> In particular, Jan - I know you did a lot of this work - do you still
> use it?
>

I used the macos stuff at the beginning to get into the code with
little risk of breaking anything. Until it is possible to mount xfs in
the other systems, xfsprogs is useless there... So, I'm ok with the
removal of macos code. I don't know how it is with the other systems,
though.

Cheers,
Jan

> Thanks,
> -Eric
>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
