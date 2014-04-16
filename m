Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F203D7F5A
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B534AC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:39:22 -0700 (PDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
	[209.85.217.173]) by cuda.sgi.com with ESMTP id
	vd2DAy18mW88Csf8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 07:39:20 -0700 (PDT)
Received: by mail-lb0-f173.google.com with SMTP id p9so8261241lbv.32
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140416002349.GV15995@dastard>
References: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
	<20140416002349.GV15995@dastard>
Date: Wed, 16 Apr 2014 15:39:18 +0100
Message-ID: <CAL3q7H75Da9uvLnE7HVam9ue-yayw=SgePbLszVWvnPbMwkd4Q@mail.gmail.com>
Subject: Re: [PATCH] xfstests: btrfs, test send's ability to punch holes and
	prealloc extents
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
Cc: Josef Bacik <jbacik@fb.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 1:23 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Apr 15, 2014 at 05:43:21PM +0100, Filipe David Borba Manana wrote:
>> This test verifies that after an incremental btrfs send the replicated file has
>> the same exact hole and data structure as in the origin filesystem. This didn't
>> use to be the case before the send stream version 2 - holes were sent as write
>> operations of 0 valued bytes instead of punching holes with the fallocate system
>> call, and pre-allocated extents were sent as well as write operations of 0 valued
>> bytes instead of intructions for the receiver to use the fallocate system call.
>> Also checks that prealloc extents that lie beyond the file's size are replicated
>> by an incremental send.
>
> Can you wrap commit messages at 68 columns?
>
> ....
>> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
>> +# List all hole and data segments.
>> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
>> +# List all extents, we're interested here in prealloc extents that lie beyond
>> +# the file's size.
>> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch
>
> That dumps raw block numbers into the golden output. _filter_fiemap
> is probably needed here.

Hum, just tried it and uploaded a v2.
However I'm now noticing it doesn't do everything I had in mind.
_filter_fiemap is not showing the extents falloc -k created, only a
collapsed range of holes.

So my intention is to verify not just holes, but also the extents
created by 'falloc -k'. The following filter I just made locally gives
me that:

_filter_all_fiemap()
{
awk --posix '
$3 ~ /hole/ {
print $1, $2, $3;
next;
}
$3 ~ /[[:xdigit:]]*..[[:xdigit:]]/ {
print $1, $2, "extent";
next;
}'
}

(nicely printed/indented at
https://friendpaste.com/1JtG5bts2Sz0LWhUutCpzE, as e-mail is not good
for code pasting)

Which gives me:

0: [0..191]: extent
1: [192..199]: extent
2: [200..231]: extent
3: [232..239]: extent
4: [240..287]: extent
5: [288..295]: extent
6: [296..487]: extent
7: [488..495]: extent
8: [496..519]: hole
9: [520..527]: extent
10: [528..583]: extent
11: [584..591]: extent
12: [592..2543]: extent
13: [2544..17575]: hole
14: [17576..21487]: extent


Versus only (from _filter_fiemap):

0: [496..17575]: hole

I couldn't find any existing similar filter. Is it ok to add this new
filter? If so, does this name makes sense and does it make sense to
add it to common/punch file or some other file?

Thanks Dave


>
>> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
>> +# List all hole and data segments.
>> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
>> +# List all extents, we're interested here in prealloc extents that lie beyond
>> +# the file's size.
>> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch
>
> Same here.
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
