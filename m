Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35876 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1956744AbdDZIEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 04:04:12 -0400
Received: by mail-ua0-f175.google.com with SMTP id 110so47179411uas.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 01:04:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426015741.GW28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com> <20170420135839.22102-1-jtulak@redhat.com>
 <20170425013721.GE28800@wotan.suse.de> <CACj3i70Niht-0FJSyVp2iOpKssTnz=LmryJMLQKiX=hHm6d+-A@mail.gmail.com>
 <20170426015741.GW28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 10:03:50 +0200
Message-ID: <CACj3i73kRA_RcaHCq3g8NgHO3VBGnYB1fB0GF9EAroBwLHU94Q@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 3:57 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Apr 25, 2017 at 02:07:02PM +0200, Jan Tulak wrote:
>> Ehh, it is not really an issue.. cvtnum is called only on two places
>> in the whole xfsprogs.
>
> Huh, I count 46, and spread all over the place:
>
> mcgrof@ergon ~/devel/xfsprogs-dev (git::libiniconfig-conf)$ git grep " cvtnum("| awk '{print $1}'| sort | uniq
> include/input.h:extern
> include/xfs_multidisk.h:extern
> io/fadvise.c:
> io/madvise.c:
> io/mincore.c:
> io/mmap.c:
> io/pread.c:
> io/prealloc.c:
> io/pwrite.c:
> io/readdir.c:
> io/reflink.c:
> io/resblks.c:
> io/seek.c:
> io/sendfile.c:
> io/sync_file_range.c:
> io/truncate.c:
> mkfs/proto.c:
> mkfs/xfs_mkfs.c:
> quota/edit.c:
>
> So 19 files.

They use a different prototype/implementation. If you change the
prototype of cvtnum in include/xfs_multidisk.h and mkfs
implementation, only one call in mkfs's getnum and in mkfs/proto.c's
getnum complains. There are three implementations of cvtnum in
xfsprogs.

>
>> Changing mkfs/proto.c is just few lines added
>> to this patch and the changes in xfs_mkfs.c do cause few conflicts,
>> but it is nothing terrific, I rebased all my further changes in about
>> three minutes. I pushed it into the git tree, check it now...
>
> Will do...
>
>> And thanks for this patch for the patch. :-)
>
> My pleasure, on second thought if the wrap around change can be a separate
> atomic change that might be worth it.
>
Yeah, I realised that too... I will split it if I don't forget.

Cheers,
Jan

>  Luis



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
