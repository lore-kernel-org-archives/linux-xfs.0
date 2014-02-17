Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 448547F75
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 19:42:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B26C304043
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:42:56 -0800 (PST)
Received: from mail-bk0-f41.google.com (mail-bk0-f41.google.com
	[209.85.214.41]) by cuda.sgi.com with ESMTP id hEOlg6ERrK6UKjac
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:42:55 -0800 (PST)
Received: by mail-bk0-f41.google.com with SMTP id na10so3992146bkb.14
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:42:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140217011929.GA13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392596438-6509-1-git-send-email-fdmanana@gmail.com>
	<20140217011929.GA13997@dastard>
Date: Mon, 17 Feb 2014 01:42:53 +0000
Message-ID: <CAL3q7H5XAVBZ32qgW-Q1o=T1q67eK0Zo4g-t_n=0vE16cVzchA@mail.gmail.com>
Subject: Re: [PATCH v3] xfstests: add regression test for btrfs incremental
	send
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Feb 17, 2014 at 1:19 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Feb 17, 2014 at 12:20:38AM +0000, Filipe David Borba Manana wrote:
>> Test for a btrfs incremental send issue where we end up sending a
>> wrong section of data from a file extent if the corresponding file
>> extent is compressed and the respective file extent item has a non
>> zero data offset.
>>
>> Fixed by the following linux kernel btrfs patch:
>>
>>    Btrfs: use right clone root offset for compressed extents
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
>>     hole punch implementation leaving hole file extent items when we punch
>>     beyond the file's current size.
>> V3: Filter xfs_io output and make less use of the run_check function, as
>>     suggested by Dave Chinner.
>
> Awesome. Thanks for the quick turn around.
>
>>  common/rc           |    5 +++
>>  tests/btrfs/040     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/040.out |    9 ++++
>>  tests/btrfs/group   |    1 +
>>  4 files changed, 134 insertions(+)
>>  create mode 100755 tests/btrfs/040
>>  create mode 100644 tests/btrfs/040.out
>>
>> diff --git a/common/rc b/common/rc
>> index e91568b..27be009 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2207,6 +2207,11 @@ run_check()
>>       "$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>>  }
>>
>> +_run_btrfs_util_prog()
>> +{
>> +     run_check $BTRFS_UTIL_PROG $*
>> +}
>
> Can you do a cleanup of all the other btrfs tests that can use this?

I just did that for all the non-merged test cases (4 including this
one), as you probably have noticed already by now.
I'll see if I can do the same for the ones already in the git repository soon.

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
