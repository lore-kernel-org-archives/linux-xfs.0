Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 655087CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37BDE8F8039
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:31:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4H3a5BwDGDvlC1DW for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 14:31:20 -0700 (PDT)
Date: Wed, 13 Apr 2016 07:31:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: about the xfs performance
Message-ID: <20160412213118.GM567@dastard>
References: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
	<20160411231056.GD9088@dastard>
	<CAG=-QKoptGYwyAg3VntWFxz5R9+Q3i-G9iQCcbYJKcZT7OSjSw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG=-QKoptGYwyAg3VntWFxz5R9+Q3i-G9iQCcbYJKcZT7OSjSw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Songbo Wang <hack.coo@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 10:07:45PM +0800, Songbo Wang wrote:
> Hi Dave,
> =

> Thank you for your reply. I did some test today and described those as
> follows:
> =

> Delete the existing test file , and redo the test : fio -ioengine=3Dlibaio
> -bs=3D4k -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt=
/test
> -name=3D"EBS 4KB randwrite test" -iodepth=3D64 -runtime=3D60
> The iops resultes is 19k=B1(per second);  I continue to fio this test file
> untill it was filled to the full. Then I did another test using the same
> test case, the results was 210k=B1(per second).(The results mentioned

Yup, that's when the workload goes from allocation bound to being an
overwrite workload when there is no allocation occurring.

Perhaps you should preallocate the file using the fallocate=3Dposix
option. This will move the initial overhead to IO completion, so
won't block submission, and the file will not end up a fragmented
mess as the written areas will merge back into large single extents
as more of the file is written.

> yesterday was partial.  I used the same test file several times, the
> results degraded because of the test file was not fill to the full)
> =

> I try to remake the filesystem using the following command to increase the
> internal log size , inode size and agcount num:
> mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D2048,align=3D1 -d agcount=
=3D2045 -l
> size=3D512m
> but it has no help to the result.

Of course it won't. Turning random knobs without knowing what they
do will not solve the problem. Indeed, if you're workload is
performance limited because it is running out of log space, then
*reducing the log size* will not solve the issue.

Users who tweaking knobs without understanding what they do or how
they affect the application is the leading cause of filesystem
performance and reliability issues on XFS. Just don't do it - all
you'll do is cause something to go wrong when you can least afford
it to happen.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
