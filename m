Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45725 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbeEUJkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 05:40:52 -0400
Received: by mail-wr0-f196.google.com with SMTP id w3-v6so7609701wrl.12
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 02:40:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180518235610.GF24680@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org> <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net> <20180518034600.GW23858@magnolia>
 <20180518153805.GE24680@garbanzo.do-not-panic.com> <c2e7b213-0dad-7609-7984-e4c897d6bb08@sandeen.net>
 <20180518235610.GF24680@garbanzo.do-not-panic.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 21 May 2018 11:40:30 +0200
Message-ID: <CACj3i70TM0uZpOLdD=gAguOvt-eGuypWtPC6LUH5_HKMCUxGhw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, lpechacek@suse.com

On Sat, May 19, 2018 at 1:56 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, May 18, 2018 at 12:09:23PM -0500, Eric Sandeen wrote:
...
>>
>> mkfs.xfs -c hoogah            searches /@sysconfigdir@/mkfs.xfs.d/
>> mkfs.xfs -c ./hoogah          or
>> mkfs.xfs -c /path/to/hoogah   do exactly what you'd expect.
>>
...
>
> Sounds good. I'll drop the environment variable junk and only support
> the above 3 cases.
>

mkfs.xfs -c ../hoogah too, please. :-)

Jan
