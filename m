Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O7DQ52057705 for <xfs@oss.sgi.com>; Tue, 24 May 2011 02:13:26 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C841D107F7
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 00:13:25 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 3ixI2zCqLC7JPGKA
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 00:13:25 -0700 (PDT)
Received: by vws13 with SMTP id 13so5214302vws.26
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 00:13:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110524015105.GE32466@dastard>
References: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110524015105.GE32466@dastard>
Date: Tue, 24 May 2011 15:13:24 +0800
Message-ID: <BANLkTikubsOdBmUA1fjOko+h6B3BqCWn5Q@mail.gmail.com>
Subject: Re: [PATCH v3] xfstests:Make 225 compare map and fiemap at each block.
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
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
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Tue, May 24, 2011 at 9:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, May 23, 2011 at 03:07:03PM +0800, Yongqiang Yang wrote:
>> Due to my carelessness, =A0I induced a ugly patch to ext4's fiemap, as a=
 result
>> delayed-extents that did not start at the head block of a page was ignor=
ed
>> in ext4 with 1K block, but 225 could not find it.
>
> When ext4 is using 1k block sizes, fiemap-tester does not find
> problems that may exist on ext4 with delayed allocation extents on
> the first block of a page.
>
>> So I looked into the 225
>> and could not figure out logic in compare_map_and_fiemap(), which seemed=
 to
>> mix extents with blocks.
>
> Once again, "I don't understand it" is not a reason for a whoelsale
> rewrite.
>
>> Then I made 225 compare map and fiemap at each block,
>> the new 225 can find the bug I induced and another bug in ext4 with 1k b=
lock,
>> which ignored delayed-extents after a hole, which did not start at the h=
ead
>> block of a page.
>
> Which means that the first paragraph should read:
>
> "When ext4 is using 1k block sizes, fiemap-tester does not find
> problems that may exist on ext4 with delayed allocation extents on
> the first block of a page or directly after a hole."
>
> That's a concise description of the overall problem you are fixing
> in this patch. Next you need to describe the different changes being
> made in the patch and the bugs they are fixing. =A0There appear to be:
>
> =A0 =A0 =A0 =A0- an off-by one in map array allocation
> =A0 =A0 =A0 =A0- zeroing the end block in the map array
> =A0 =A0 =A0 =A0- making check_weird_fs_hole() verify bytes read by pread()
> =A0 =A0 =A0 =A0- moving truncate/seek of the test file around
> =A0 =A0 =A0 =A0- changing the way map/fiemap are compared
>
> Also, you haven't addressed any of the comments I made in my
> original review:
>
> =A0 =A0 =A0 =A0- removing the changelog from the header comment
> =A0 =A0 =A0 =A0- adding comments on check_data/check_hole explaining what
> =A0 =A0 =A0 =A0 =A0they are checking
> =A0 =A0 =A0 =A0- explaining why the existing map/fiemap compare couldn't
> =A0 =A0 =A0 =A0 =A0detect the problems with delayed extents on ext4? i.e.
> =A0 =A0 =A0 =A0 =A0what's the bug that you are fixing so we can determine=
 if
> =A0 =A0 =A0 =A0 =A0it really does need a rewrite to fix?
Sorry for being dense, I still can not understand logic in 225.  I
will take an example to explain the bug which 225 does not report.  I
think fiemap and map info should be compared at each block, I tried to
find this logic in 225, but I could not.

Assume that a file is 'HDDHD', and set blocks_to_map in
compare_fiemap_and map() to 5.
Due to a bug I induced in ext4, only the 1st extent is returned.
for-loop will check block 0 and break with i =3D 2. then cur_extent will
be 2.  Next, do-loop will lookup from 2 and no extent is returned,
then for-loop break with i =3D 3. then cur_extent will be 3.  Then
do-loop will lookup from 3 and no extent is returned, then for-loop
break with i=3D4. then do-loop will lookup from 4 and the 2nd delayed
extent is returned, and block 4 is verified.  225 does not find the
bug.

Actually, 225 should report the bug at first, because blocks_to_map is set =
to 5.

I am not sure this can be understood.

Thanks,
Yongqiang.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
