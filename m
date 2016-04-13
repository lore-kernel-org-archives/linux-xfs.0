Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFC3F7CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62236AC005
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:27:10 -0700 (PDT)
Received: from mail-yw0-f193.google.com (mail-yw0-f193.google.com
	[209.85.161.193]) by cuda.sgi.com with ESMTP id
	J7aKGALXZ779out6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:27:07 -0700 (PDT)
Received: by mail-yw0-f193.google.com with SMTP id h6so7592097ywc.1
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:27:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160412213118.GM567@dastard>
References: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
	<20160411231056.GD9088@dastard>
	<CAG=-QKoptGYwyAg3VntWFxz5R9+Q3i-G9iQCcbYJKcZT7OSjSw@mail.gmail.com>
	<20160412213118.GM567@dastard>
Date: Thu, 14 Apr 2016 01:27:07 +0800
Message-ID: <CAG=-QKoWEDsqGC-cvsv+3sYRvv74YCXEviteaqPw7MhJFaKn0g@mail.gmail.com>
Subject: Re: about the xfs performance
From: Songbo Wang <hack.coo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7899678672283224358=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7899678672283224358==
Content-Type: multipart/alternative; boundary=001a11c015ba44ce260530611642

--001a11c015ba44ce260530611642
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thank you for your suggestion,  and very appreciate for your reply!

2016-04-13 5:31 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Tue, Apr 12, 2016 at 10:07:45PM +0800, Songbo Wang wrote:
> > Hi Dave,
> >
> > Thank you for your reply. I did some test today and described those as
> > follows:
> >
> > Delete the existing test file , and redo the test : fio -ioengine=3Dlib=
aio
> > -bs=3D4k -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/m=
nt/test
> > -name=3D"EBS 4KB randwrite test" -iodepth=3D64 -runtime=3D60
> > The iops resultes is 19k=C4=85(per second);  I continue to fio this tes=
t file
> > untill it was filled to the full. Then I did another test using the sam=
e
> > test case, the results was 210k=C4=85(per second).(The results mentione=
d
>
> Yup, that's when the workload goes from allocation bound to being an
> overwrite workload when there is no allocation occurring.
>
> Perhaps you should preallocate the file using the fallocate=3Dposix
> option. This will move the initial overhead to IO completion, so
> won't block submission, and the file will not end up a fragmented
> mess as the written areas will merge back into large single extents
> as more of the file is written.
>
> > yesterday was partial.  I used the same test file several times, the
> > results degraded because of the test file was not fill to the full)
> >
> > I try to remake the filesystem using the following command to increase
> the
> > internal log size , inode size and agcount num:
> > mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D2048,align=3D1 -d agcoun=
t=3D2045
> -l
> > size=3D512m
> > but it has no help to the result.
>
> Of course it won't. Turning random knobs without knowing what they
> do will not solve the problem. Indeed, if you're workload is
> performance limited because it is running out of log space, then
> *reducing the log size* will not solve the issue.
>
> Users who tweaking knobs without understanding what they do or how
> they affect the application is the leading cause of filesystem
> performance and reliability issues on XFS. Just don't do it - all
> you'll do is cause something to go wrong when you can least afford
> it to happen.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c015ba44ce260530611642
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div>=C2=A0 =C2=A0</div><div>Thank you for your su=
ggestion, =C2=A0and very appreciate for your reply!</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-04-13 5:31 GMT+08:00 D=
ave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" ta=
rget=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex"><span class=3D"">On Tue, Apr 12, 2016 at 10:07:45PM +0800, Songb=
o Wang wrote:<br>
&gt; Hi Dave,<br>
&gt;<br>
&gt; Thank you for your reply. I did some test today and described those as=
<br>
&gt; follows:<br>
&gt;<br>
&gt; Delete the existing test file , and redo the test : fio -ioengine=3Dli=
baio<br>
&gt; -bs=3D4k -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/=
mnt/test<br>
&gt; -name=3D&quot;EBS 4KB randwrite test&quot; -iodepth=3D64 -runtime=3D60=
<br>
</span>&gt; The iops resultes is 19k=C4=85(per second);=C2=A0 I continue to=
 fio this test file<br>
<span class=3D"">&gt; untill it was filled to the full. Then I did another =
test using the same<br>
</span>&gt; test case, the results was 210k=C4=85(per second).(The results =
mentioned<br>
<br>
Yup, that&#39;s when the workload goes from allocation bound to being an<br=
>
overwrite workload when there is no allocation occurring.<br>
<br>
Perhaps you should preallocate the file using the fallocate=3Dposix<br>
option. This will move the initial overhead to IO completion, so<br>
won&#39;t block submission, and the file will not end up a fragmented<br>
mess as the written areas will merge back into large single extents<br>
as more of the file is written.<br>
<span class=3D""><br>
&gt; yesterday was partial.=C2=A0 I used the same test file several times, =
the<br>
&gt; results degraded because of the test file was not fill to the full)<br=
>
&gt;<br>
&gt; I try to remake the filesystem using the following command to increase=
 the<br>
&gt; internal log size , inode size and agcount num:<br>
&gt; mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D2048,align=3D1 -d agcou=
nt=3D2045 -l<br>
&gt; size=3D512m<br>
&gt; but it has no help to the result.<br>
<br>
</span>Of course it won&#39;t. Turning random knobs without knowing what th=
ey<br>
do will not solve the problem. Indeed, if you&#39;re workload is<br>
performance limited because it is running out of log space, then<br>
*reducing the log size* will not solve the issue.<br>
<br>
Users who tweaking knobs without understanding what they do or how<br>
they affect the application is the leading cause of filesystem<br>
performance and reliability issues on XFS. Just don&#39;t do it - all<br>
you&#39;ll do is cause something to go wrong when you can least afford<br>
it to happen.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--001a11c015ba44ce260530611642--


--===============7899678672283224358==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7899678672283224358==--
