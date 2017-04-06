Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33067 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934707AbdDFPDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 11:03:11 -0400
Received: by mail-vk0-f47.google.com with SMTP id d188so43332433vka.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Apr 2017 08:03:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170406144139.20284-1-jtulak@redhat.com>
References: <20170406144139.20284-1-jtulak@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 6 Apr 2017 17:02:49 +0200
Message-ID: <CACj3i71p17no6p8=A9ys_8-w8G7mw-4jjSP4oMAfcOFUeTV7xw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Jan Tulak <jtulak@redhat.com>

On Thu, Apr 6, 2017 at 4:41 PM, Jan Tulak <jtulak@redhat.com> wrote:
> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
>
> In the past, when mkfs was first written, it used atoi and
> similar calls, so the variables were ints. However, the situation moved
> since then and in course of the time, mkfs began to use other types too.
>
> Clean and unify it. We don't need negative values anywhere in the code and
> some numbers has to be 64bit. Thus, uint64 is the best candidate as the target
> type.
>
> This patch changes variables declared at the beginning of main() + block/sectorsize, making only minimal changes. The following patch cleans some now-unnecessary type casts.
>
> It would be nice to change types in some of the structures too, but
> this might lead to changes outside of mkfs, so I'm skipping them for
> this moment to keep it simple.
>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 184 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 92 insertions(+), 92 deletions(-)
>

Public git tree for these changes:
https://github.com/jtulak/xfsprogs-dev/tree/github-uint

(It includes the other two small patches I submitted today too).

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
