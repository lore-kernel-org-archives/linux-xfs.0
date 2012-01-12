Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHP0TR008465 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:25:00 -0600
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id F4RANOVovqEFf0Bn
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:24:58 -0800 (PST)
Received: by werm12 with SMTP id m12so1807715wer.26
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:24:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120110220242.GB24410@dastard>
References: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
	<1326213469-22687-2-git-send-email-guaneryu@gmail.com>
	<20120110220242.GB24410@dastard>
From: Eryu Guan <guaneryu@gmail.com>
Date: Fri, 13 Jan 2012 01:24:37 +0800
Message-ID: <CA+dCu88ZapVZvZSc34YOMQki2=4EMBEfpMd-+LiSP0jnyK4nPA@mail.gmail.com>
Subject: Re: [PATCH] xfstests 273: Create lost+found to pass _check_scratch_fs
Reply-To: guaneryu@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 6:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jan 11, 2012 at 12:37:49AM +0800, Eryu Guan wrote:
>> fsck.extN will complain lost+found is missing and fail 273.
>> So create lost+found explicitly after removing everything in
>> $SCRATCH_MNT.
>
> I'd consider that a bug in e2fsck. Other filesystems handle missing
> lost+found directories without failing, but then again it's only
> these new tests that do this so fixing the tests is probably the
> right thing to do here.
>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>> ---
>> =A0273 | =A0 =A02 ++
>> =A01 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/273 b/273
>> index 2965132..9ecb2d3 100755
>> --- a/273
>> +++ b/273
>> @@ -36,6 +36,7 @@ _cleanup()
>> =A0{
>> =A0 =A0 =A0 cd /
>> =A0 =A0 =A0 rm -rf $SCRATCH_MNT/* $tmp.*
>> + =A0 =A0 mkdir -p $SCRATCH_MNT/lost+found
>> =A0 =A0 =A0 _scratch_unmount
>> =A0}
>
> We shouldn't be removing files from the scratch device =A0in the
> _cleanup function - if the test exits or fails, we need the corpse
> to be intact for debugging. Remving $SCRATCH_MNT/* from the rm
> command is what should be done here.
>
>>
>> @@ -107,6 +108,7 @@ _do_workload()
>> =A0 =A0 =A0 _pid=3D1
>>
>> =A0 =A0 =A0 rm -rf $SCRATCH_MNT/*
>> + =A0 =A0 mkdir -p $SCRATCH_MNT/lost+found
>
> And rather than doing this, the test should put all it's files in a
> known location on the $SCRATCH_MNT and just remove that. e.g:
>
> WORK_DIR=3D"$SCRATCH_MNT/$seq"
>
> ....
>
> =A0 =A0 =A0 =A0rm -rf $WORKDIR
>
> ....
>
> The same fixes are required for 274 and 275 as well.

Thanks for the review, I just sent a new patch to fix 273 274 and 275
[PATCH] xfstests 273 274 275: do test in dedicated dir and leave test
files in it

Please help review.

Thanks,
Eryu Guan
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
