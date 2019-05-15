Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:40529 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOP5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 11:57:35 -0400
Received: by mail-lj1-f172.google.com with SMTP id d15so257828ljc.7
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 08:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190514185026.73788-1-jorgeguerra@gmail.com> <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
In-Reply-To: <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
From: Jorge Guerra <jorge.guerra@gmail.com>
Date: Wed, 15 May 2019 08:57:21 -0700
Message-ID: <CAEFkGAx1A3-XXqWSssa3QQsTZW-8BuVU_D+Dq2sYfKAKs0+t_w@mail.gmail.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

Thanks Eric,

I'm addressing these comments.  Will send an update once we have an
agreement with Dave into how and where to implement this.

On Tue, May 14, 2019 at 1:02 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 5/14/19 1:50 PM, Jorge Guerra wrote:
> > +             dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
> > +             extstats.logicalused, answer, iec_prefixes[i]);
>
> I think I missed this instance of "indent please" and probably others...
>
> (I'm kind of wondering about carrying 'used' in bytes, but I suppose we're
> ok until we really get zettabyte filesytems in the wild) ;)
>
> -Eric



-- 
Jorge E Guerra D
