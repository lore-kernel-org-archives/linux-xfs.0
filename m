Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:36270 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdHQJp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 05:45:56 -0400
Received: by mail-wr0-f176.google.com with SMTP id x43so39016515wrb.3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 02:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170817083538.GQ21024@dastard>
References: <20170817073844.1351-1-jtulak@redhat.com> <20170817083538.GQ21024@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 17 Aug 2017 11:45:34 +0200
Message-ID: <CACj3i7301p_NZJpaATZG-YCf-AAuvnh05kWhXHjMc3GTBQm2Hg@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: add sectsize/sectlog to the man page
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Aug 17, 2017 at 10:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 17, 2017 at 09:38:44AM +0200, Jan Tulak wrote:
>> The man page is missing description of these options.
>> Add it.
>
> Just remove the options. They are redundant as they cannot be
> different from the values set by the "-s" sector size options.
> They aren't documented, so just remove them from mkfs.
>

The code doesn't look like that. From what it does:

-d sectsize: will set data section sector size
-l sectsize: will set log section sector size (and as I see now, this
is not in man page as well)
-s size: will set both data and log sector size

Does the removal of -d sectsize really make a sense? In any case, the
man page needs to be updated to reflect the code.

Cheers,
Jan
