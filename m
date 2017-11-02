Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:55915 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbdKBSLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 14:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <20171102163953.GT4911@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia> <20171102124214.GY17339@eguan.usersys.redhat.com>
 <CAOQ4uxjJD+r5uvQ4=F5zaL5uUkLQu3sW2nVcWqsUS2YP3hxrUQ@mail.gmail.com> <20171102163953.GT4911@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 2 Nov 2017 20:11:22 +0200
Message-ID: <CAOQ4uxjkzabQMViRmysJgj9Hk0K3T7rtmqyuM=v-pzuKmxZ+pA@mail.gmail.com>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be allowed
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Nov 2, 2017 at 6:39 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Thu, Nov 02, 2017 at 03:14:45PM +0200, Amir Goldstein wrote:
>> On Thu, Nov 2, 2017 at 2:42 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Wed, Nov 01, 2017 at 02:47:23PM -0700, Darrick J. Wong wrote:
>> >> From: Darrick J. Wong <darrick.wong@oracle.com>
>> >>
>> >> A directory corrupted into a symlink will be caught by the upcoming
>> >> local format ifork verifiers.
>> >>
>> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> >> ---
>> >>  tests/xfs/348.out |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >>
>> >> diff --git a/tests/xfs/348.out b/tests/xfs/348.out
>> >> index f4a7a71..17d9be2 100644
>> >> --- a/tests/xfs/348.out
>> >> +++ b/tests/xfs/348.out
>> >> @@ -239,7 +239,7 @@ would have junked entry "DATA" in directory PARENT_INO
>> >>  would have junked entry "DIR" in directory PARENT_INO
>> >>  would have junked entry "EMPTY" in directory PARENT_INO
>> >>  would have junked entry "FIFO" in directory PARENT_INO
>> >> -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
>> >> +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
>> >
>> > But this breaks tests on old kernels. Or with the new ifork verifiers,
>> > old kernels can be considered as buggy?
>> >
>>
>> Can filter new and old error into canonicalized string.
>> Dodgy, bug we've done it before.
>> See:
>> git grep sed | grep 'Operation not permitted\|Permission denied'
>
> I tried that, but the "stat: XXX is a symbolic link" message comes from
> a different path in the test file code.
>
> Unless... you're suggesting that I should sed the error output to make
> it look like the previous (broken) output?
>

Let's say I am not *suggesting* this, but I have seen tests that do that
See generic/160 and other tests that show in this grep output:

git grep sed | grep 'Operation not permitted\|Permission denied'

Amir.
