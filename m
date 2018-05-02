Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40366 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbeEBJN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 05:13:56 -0400
Received: by mail-wr0-f195.google.com with SMTP id v60-v6so13183927wrc.7
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 02:13:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180502085503.GE29084@desktop>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518921090.23023.14958881774088486712.stgit@magnolia> <20180502085503.GE29084@desktop>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 2 May 2018 11:13:34 +0200
Message-ID: <CACj3i70-wqmr_ynB4YQbDYD7f00KzCAsBwsrw8cuQYKzx-DLgQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs: checkbashisms in all script files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org

On Wed, May 2, 2018 at 10:55 AM, Eryu Guan <guaneryu@gmail.com> wrote:
> On Tue, May 01, 2018 at 08:40:10AM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Find all the /bin/sh scripts in xfsprogs and check for bashisms.
>>
>> Cc: sandeen@sandeen.net
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> Looks fine to me, but I'd like a review from Eric too, as it's a
> "maintainer script" :)
>

A good idea, looks generally ok to me (and now we really wait for Eric).

[snip]
>> +
>> +find $WORKAREA -name 'xfs*.sh' -print0 | xargs -0 grep '^#!/bin/sh' | sed -e 's/:.*$//g' | while read f; do
>
> Do we care about spaces between "#!" and "/bin/sh"? i.e. "#! /bin/sh",
> sometimes there can be space(s).
>

As far as I know, spaces are completely OK and allowed and accepted
everywhere, so I would add them here too.

Jan
