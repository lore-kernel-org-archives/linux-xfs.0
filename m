Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40728 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbeD3Nni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 09:43:38 -0400
Received: by mail-wr0-f194.google.com with SMTP id v60-v6so8088066wrc.7
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 06:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <34b3e3c1-90a9-f901-eb3a-1bc86469ccab@sandeen.net>
References: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
 <20180430053059.GA21688@magnolia> <34b3e3c1-90a9-f901-eb3a-1bc86469ccab@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 30 Apr 2018 15:43:17 +0200
Message-ID: <CACj3i73QQqvV6s=_OW-YhosaTDWrS635bXmnD1X18Mej2FQd1g@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: do not use 'function' keyword
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 3:28 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 4/30/18 12:30 AM, Darrick J. Wong wrote:
>> On Sun, Apr 29, 2018 at 08:15:28PM -0500, Eric Sandeen wrote:
>>> It was pointed out on irc that fsck.xfs uses the 'function' keyword
>>> although it invokes /bin/sh - 'function' is a bashism.  It's not needed
>>> here, so just remove it.
>>>
>>> Fixes: 04a2d5d ("fsck.xfs: allow forced repairs using xfs_repair")
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Does RHEL have 'checkbashisms'?
>
> Hm, yes, Fedora & RHEL have it in devscripts-minimal.
>
> $ checkbashisms ./fsck/xfs_fsck.sh
> possible bashism in ./fsck/xfs_fsck.sh line 9 ('function' is useless):
> function repair2fsck_code() {
> possible bashism in ./fsck/xfs_fsck.sh line 62 ('command' with option other than -p):
>         XFS_REPAIR=`command -v xfs_repair`
>
> Apparently -v is only part of "User Portability Utilities?"
>

I think so. Is it any problem? If so, I will try to find some other
way how to search in PATH.

Jan
