Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36349 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbdCaHfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 03:35:44 -0400
Received: by mail-vk0-f45.google.com with SMTP id s68so81611950vke.3
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2017 00:35:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170331014013.GP28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-12-jtulak@redhat.com>
 <40f76322-d4f1-5c48-3568-206a2564dad5@sandeen.net> <CACj3i71XTGsHM5U4Av=Ywn9Q7UY3QtU_ZCZrfwatfeUx0AHNNQ@mail.gmail.com>
 <CACj3i73ubkr6pGsxwkRvLwmnuCyPma+eF2L2HGMwaufHbazRNQ@mail.gmail.com> <20170331014013.GP28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 31 Mar 2017 09:35:21 +0200
Message-ID: <CACj3i70UJYPTXuRj_Ycqyni5GVB5FwnB-pKjk=A8Pejhqrf-1Q@mail.gmail.com>
Subject: Re: [PATCH 11/22] mkfs: add test_default_value into conflict struct
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, Mar 31, 2017 at 3:40 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Mar 29, 2017 at 06:33:38PM +0200, Jan Tulak wrote:
>> https://github.com/jtulak/xfsprogs-dev
>
> FWIW
>
> mcgrof@ergon ~/devel $ git clone https://github.com/jtulak/xfsprogs-dev.git jtulak-xfsprogs
> Cloning into 'jtulak-xfsprogs'...
> remote: Counting objects: 20082, done.
> remote: Compressing objects: 100% (3760/3760), done.
> remote: Total 20082 (delta 16302), reused 20082 (delta 16302), pack-reused 0
> Receiving objects: 100% (20082/20082), 5.99 MiB | 9.80 MiB/s, done.
> Resolving deltas: 100% (16302/16302), done.
> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>
> mcgrof@ergon ~/devel $ git clone https://github.com/jtulak/xfsprogs-dev.git --reference xfsprogs-dev/.git jtulak-xfsprogs
> Cloning into 'jtulak-xfsprogs'...
> remote: Counting objects: 96, done.
> remote: Compressing objects: 100% (29/29), done.
> remote: Total 96 (delta 72), reused 91 (delta 67), pack-reused 0
> Unpacking objects: 100% (96/96), done.
> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>
> A branch does work:
>
> mcgrof@ergon ~/devel/xfsprogs-dev (git::master)$ git remote add jtulak https://github.com/jtulak/xfsprogs-dev.git
> mcgrof@ergon ~/devel/xfsprogs-dev (git::master)$ git fetch jtulak
> remote: Counting objects: 96, done.
> remote: Compressing objects: 100% (29/29), done.
> remote: Total 96 (delta 72), reused 91 (delta 67), pack-reused 0
> Unpacking objects: 100% (96/96), done.
> From https://github.com/jtulak/xfsprogs-dev
>  * [new branch]                github     -> jtulak/github
>
> So one can just do:
>
> git clone https://github.com/jtulak/xfsprogs-dev -b github j-xfs --reference  /home/mcgrof/devel/xfsprogs-dev/.git
> Cloning into 'j-xfs'...
>
>   Luis

o_O This is something I didn't think that there could be any issue.
Well, next time I know that I need to push all branches this specific
one originates from. Anyway, fixed, I pushed master branch on github
too. Mine branch should be the default one, but git now knows the
ref...

$ git clone https://github.com/jtulak/xfsprogs-dev.git jtulak-xfsprogs
Cloning into 'jtulak-xfsprogs'...
remote: Counting objects: 20082, done.
remote: Compressing objects: 100% (3760/3760), done.
remote: Total 20082 (delta 16302), reused 20082 (delta 16302), pack-reused 0
Receiving objects: 100% (20082/20082), 5.99 MiB | 3.39 MiB/s, done.
Resolving deltas: 100% (16302/16302), done.
$

Thanks,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
