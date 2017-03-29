Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35762 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdC2QeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 12:34:00 -0400
Received: by mail-vk0-f45.google.com with SMTP id r69so24289026vke.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Mar 2017 09:33:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i71XTGsHM5U4Av=Ywn9Q7UY3QtU_ZCZrfwatfeUx0AHNNQ@mail.gmail.com>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-12-jtulak@redhat.com>
 <40f76322-d4f1-5c48-3568-206a2564dad5@sandeen.net> <CACj3i71XTGsHM5U4Av=Ywn9Q7UY3QtU_ZCZrfwatfeUx0AHNNQ@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 29 Mar 2017 18:33:38 +0200
Message-ID: <CACj3i73ubkr6pGsxwkRvLwmnuCyPma+eF2L2HGMwaufHbazRNQ@mail.gmail.com>
Subject: Re: [PATCH 11/22] mkfs: add test_default_value into conflict struct
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

On Wed, Mar 29, 2017 at 4:57 PM, Jan Tulak <jtulak@redhat.com> wrote:
>
> And I'm adding a validating function to spot this kind of errors
> before the program does anything else.

I made a first quick fire on this and even the half-baked version that
can only find if a conflict is missing its counterpart has found two
issues (L_AGNUM doesn't have an entry about L_NAME, but L_NAME points
at L_AGNUM. Ditto for L_INTERNAL and L_NAME.)

Let's see what it finds out when it also compares if the values are
set accordingly.

Also, I have published my git tree on github. It is in middle of
changes according to things reported here in mailing list and you
already have it locally, but if it is any help to you or Luis
(CCed)... I will update it once I send updated patchset, and maybe few
times before that (if I will find it helpful).

https://github.com/jtulak/xfsprogs-dev

(Ah, and ignore the name of the last commit, it is just a note for me
what to pick on tomorrow - I'm ending for today.)

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
