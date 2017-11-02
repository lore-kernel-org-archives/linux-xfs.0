Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:45998 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755395AbdKBNOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 09:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <20171102124214.GY17339@eguan.usersys.redhat.com>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia> <20171102124214.GY17339@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 2 Nov 2017 15:14:45 +0200
Message-ID: <CAOQ4uxjJD+r5uvQ4=F5zaL5uUkLQu3sW2nVcWqsUS2YP3hxrUQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be allowed
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Nov 2, 2017 at 2:42 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Nov 01, 2017 at 02:47:23PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> A directory corrupted into a symlink will be caught by the upcoming
>> local format ifork verifiers.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  tests/xfs/348.out |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>
>> diff --git a/tests/xfs/348.out b/tests/xfs/348.out
>> index f4a7a71..17d9be2 100644
>> --- a/tests/xfs/348.out
>> +++ b/tests/xfs/348.out
>> @@ -239,7 +239,7 @@ would have junked entry "DATA" in directory PARENT_INO
>>  would have junked entry "DIR" in directory PARENT_INO
>>  would have junked entry "EMPTY" in directory PARENT_INO
>>  would have junked entry "FIFO" in directory PARENT_INO
>> -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
>> +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
>
> But this breaks tests on old kernels. Or with the new ifork verifiers,
> old kernels can be considered as buggy?
>

Can filter new and old error into canonicalized string.
Dodgy, bug we've done it before.
See:
git grep sed | grep 'Operation not permitted\|Permission denied'

Amir.
