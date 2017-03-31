Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935038AbdCaBkV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:40:21 -0400
Date: Fri, 31 Mar 2017 03:40:13 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 11/22] mkfs: add test_default_value into conflict struct
Message-ID: <20170331014013.GP28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-12-jtulak@redhat.com>
 <40f76322-d4f1-5c48-3568-206a2564dad5@sandeen.net>
 <CACj3i71XTGsHM5U4Av=Ywn9Q7UY3QtU_ZCZrfwatfeUx0AHNNQ@mail.gmail.com>
 <CACj3i73ubkr6pGsxwkRvLwmnuCyPma+eF2L2HGMwaufHbazRNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73ubkr6pGsxwkRvLwmnuCyPma+eF2L2HGMwaufHbazRNQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

On Wed, Mar 29, 2017 at 06:33:38PM +0200, Jan Tulak wrote:
> https://github.com/jtulak/xfsprogs-dev

FWIW

mcgrof@ergon ~/devel $ git clone https://github.com/jtulak/xfsprogs-dev.git jtulak-xfsprogs
Cloning into 'jtulak-xfsprogs'...
remote: Counting objects: 20082, done.
remote: Compressing objects: 100% (3760/3760), done.
remote: Total 20082 (delta 16302), reused 20082 (delta 16302), pack-reused 0
Receiving objects: 100% (20082/20082), 5.99 MiB | 9.80 MiB/s, done.
Resolving deltas: 100% (16302/16302), done.
warning: remote HEAD refers to nonexistent ref, unable to checkout.

mcgrof@ergon ~/devel $ git clone https://github.com/jtulak/xfsprogs-dev.git --reference xfsprogs-dev/.git jtulak-xfsprogs
Cloning into 'jtulak-xfsprogs'...
remote: Counting objects: 96, done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 96 (delta 72), reused 91 (delta 67), pack-reused 0
Unpacking objects: 100% (96/96), done.
warning: remote HEAD refers to nonexistent ref, unable to checkout.

A branch does work:

mcgrof@ergon ~/devel/xfsprogs-dev (git::master)$ git remote add jtulak https://github.com/jtulak/xfsprogs-dev.git 
mcgrof@ergon ~/devel/xfsprogs-dev (git::master)$ git fetch jtulak
remote: Counting objects: 96, done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 96 (delta 72), reused 91 (delta 67), pack-reused 0
Unpacking objects: 100% (96/96), done.
>From https://github.com/jtulak/xfsprogs-dev
 * [new branch]                github     -> jtulak/github

So one can just do:

git clone https://github.com/jtulak/xfsprogs-dev -b github j-xfs --reference  /home/mcgrof/devel/xfsprogs-dev/.git
Cloning into 'j-xfs'...

  Luis
