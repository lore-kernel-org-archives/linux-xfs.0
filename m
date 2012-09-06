Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86CXDfM065899 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 07:33:13 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	xdvEgYY4vx7rVrIO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Sep 2012 05:34:12 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so2377966obb.26
	for <xfs@oss.sgi.com>; Thu, 06 Sep 2012 05:34:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120905230431.GK15292@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<1343294892-20991-18-git-send-email-david@fromorbit.com>
	<1346846436.1129.20.camel@localhost>
	<20120905230431.GK15292@dastard>
Date: Thu, 6 Sep 2012 14:34:12 +0200
Message-ID: <CAFZPdfj8bRW4s6fmKohRF9uqE4rr8nav2_c-hbs80h4k+6QWkA@mail.gmail.com>
Subject: Re: [PATCH 17/18] xfstests: convert tests to use new results directory
From: Boris Ranto <ranto.boris@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 6, 2012 at 1:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 05, 2012 at 02:00:35PM +0200, Boris Ranto wrote:
>> On Thu, 2012-07-26 at 19:28 +1000, Dave Chinner wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > Essentially the change is simply this. Converting:
>> >
>> > ... >> $seq.????
>> >
>> > to:
>> >
>> > .... >> $RESULT_DIR/$seq.????
>> >
>> > so that output files are directed to the defined output directory.
>> >
>> > sed to the rescue:
>> >
>> > $ sed -i -e '/^seq=.*$/a seqres=$RESULT_DIR/$seq' -e 's/seq.full/seqres.full/' tests/*/*
>> >
>> > will do most of the work automatically.
> .....
>> Quite a lot of tests use $here/$seq.full. This results in
>> $here/$seqres.full after the sed. $seqres is just a $RESULT_DIR/$seq.
>> This would break if RESULT_DIR was set to an absolute path instead of
>> relative path.
>
> Yes. As the patch description says it "will do most of the work",
> but it doesn't do all of it. Indeed, supporting full paths for
> $RESULT_DIR is actually necessary for other reasons, such as
> supporting completely external result destinations. To that end, I
> have a patch in my current series that does the rest of the
> conversion with the appropriate setup changes:
>
> commit 08dbbb1e6a82a4ed04e0622b7ee63957fae7721b
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Aug 22 16:09:33 2012 +1000
>
>     xfstests: RESULTS_DIR needs to be an absolute path
>
>
>     Some tests 'cd <somedir>' and then direct output to $RESULT_DIR,
>     which fails if the current working directory is not $here.
>     Regardless, if an external results directory is to be used it needs
>     to have a full path specified and the use of $here as the base of
>     the results files is completely incorrect.
>
>     Hence change all the $here/$seqres* references to simply be
>     $seqres*, and instead encode the full path to the results in
>     $RESULT_DIR.
>
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

OK, I just wanted to report the issue.

btw: The installation does not seem to work with the posted patches
(it expects the old '[0-9]??' tests to be in the root directory of
xfstests). Do you have/work on any patch for that?

Regards,
Boris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
