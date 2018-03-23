Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:53486 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeCWJYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 05:24:42 -0400
Received: by mail-wm0-f42.google.com with SMTP id e194so2263620wmd.3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 02:24:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <669909a6-6976-04fc-7717-f109b58b9c5a@sandeen.net>
References: <20180315174521.33897-1-jtulak@redhat.com> <20180315182308.36245-1-jtulak@redhat.com>
 <669909a6-6976-04fc-7717-f109b58b9c5a@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 23 Mar 2018 10:24:20 +0100
Message-ID: <CACj3i73kRq5bDqwk=2V-qaSy174kxzJTCj7B38AGeB4LOLODDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] xfs_repair: add flag -e to detect corrected errors
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 23, 2018 at 2:57 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/15/18 1:23 PM, Jan Tulak wrote:
>> xfs_repair ends with a return code 0 if it finished ok, no matter if
>> there were some errors in the fs, or not. The new flag -e means that we
>> can avoid screenscraping and parsing text output to detect if an error
>> was found (and corrected).
>>
>> If something could not be corrected or in any other case than the "found
>> something but fixed it all," the behaviour with this flag is unchanged.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> A couple more minor things, sorry for chiming in late.
>
> Can we make the changelog summary a little more specific, i.e.
>
> "xfs_repair: add flag -e to modify exit code for corrected errors"
>
> I had a late-breaking thought ;) that maybe we should skip up to exit
> code 4, so that if for some reason in the future we need to, we can
> OR together exit codes ala e2fsck to convey more information.
> I don't know what other exit codes we might need, but this might
> future-proof it a little.
>
> (Actually, I can see an use today:  1 | 4 = 5 could mean
> "we found and fixed some errors and then encountered an operational
> problem and exited." - but that can come later, not here.  Skipping
> to 4 would keep this option open.)
>

That makes sense. I will update it accordingly. And thanks for the
rest of the things, fixing that too.
