Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2FDA7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38B5630405F
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 07:07:54 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com
	[209.85.161.182]) by cuda.sgi.com with ESMTP id
	u25skcKqjlIZmalz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 07:07:46 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id o66so25078154ywc.3
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 07:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160411231056.GD9088@dastard>
References: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
	<20160411231056.GD9088@dastard>
Date: Tue, 12 Apr 2016 22:07:45 +0800
Message-ID: <CAG=-QKoptGYwyAg3VntWFxz5R9+Q3i-G9iQCcbYJKcZT7OSjSw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1812826087976803124=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1812826087976803124==
Content-Type: multipart/alternative; boundary=001a11490f0279db9205304a2f01

--001a11490f0279db9205304a2f01
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thank you for your reply. I did some test today and described those as
follows:

Delete the existing test file , and redo the test : fio -ioengine=3Dlibaio
-bs=3D4k -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/t=
est
-name=3D"EBS 4KB randwrite test" -iodepth=3D64 -runtime=3D60
The iops resultes is 19k=C2=B1(per second);  I continue to fio this test fi=
le
untill it was filled to the full. Then I did another test using the same
test case, the results was 210k=C2=B1(per second).(The results mentioned
yesterday was partial.  I used the same test file several times, the
results degraded because of the test file was not fill to the full)

I try to remake the filesystem using the following command to increase the
internal log size , inode size and agcount num:
mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D2048,align=3D1 -d agcount=3D=
2045 -l
size=3D512m
but it has no help to the result.


Any suggestion to deal with this problems ?
I very appreciate your feedback.

songbo





2016-04-12 7:10 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Mon, Apr 11, 2016 at 10:14:06PM +0800, Songbo Wang wrote:
> > Hi xfsers:
> >
> > I got some troubles on the performance of  xfs.
> > The environment is ,
> >      xfs version is 3.2.1,
> >      centos 7.1,
> >      kernel version:3.10.0-229.el7.x86_64.
> >      pcie-ssd card,
> >      mkfs: mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D512 -d agcoun=
t=3D40
> -l
> > size=3D1024m.
> >      mount: mount /dev/hioa2 /mnt/  -t xfs -o
> >
> rw,noexec,nodev,noatime,nodiratime,nobarrier,discard,inode64,logbsize=3D2=
56k,delaylog
> > I use the following command to test iops: fio -ioengine=3Dlibaio -bs=3D=
4k
> > -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/test -=
name=3D"EBS
> > 4KB randwrite test" -iodepth=3D64 -runtime=3D60
> > The results is normal at the beginning which is about 210k=C2=B1=EF=BC=
=8Cbut some
> > seconds later, the results down to 19k=C2=B1.
>
> Looks like the workload runs out of log space due to all the
> allocation transactions being logged, which then causes new
> transactions to start tail pushing the log to flush dirty metadata.
> This is needed to to make more space in the log for on incoming dio
> writes that require allocation transactions. This will block IO
> submission until there is space available in the log.
>
> Let's face it, all that test does is create a massively fragmented
> 50GB file, so you're going to have a lot of metadata to log. Do the
> maths - if it runs at 200kiops for a few seconds, it's created a
> million extents.
>
> And it's doing random insert on the extent btree, so
> it's repeatedly dirtying the entire extent btree. This will trigger
> journal commits quite frequently as this is a large amount of
> metadata that is being dirtied. e.g. at 500 extent records per 4k
> block, a million extents will require 2000 leaf blocks to store them
> all. That's 80MB of metadata per million extents that this workload
> is generating and repeatedly dirtying.
>
> Then there's also other metadata, like the free space btrees, that
> is also being repeatedly dirtied, etc, so it would not be unexpected
> to see a workload like this on high IOPS devices allocating 100MB of
> metadata every few seconds and the amount being journalled steadily
> increasing until the file is fully populated.
>
> > I did a senond test ,
> >      umount the /dev/hioa2,
> >      fio -ioengine=3Dlibaio -bs=3D4k -direct=3D1  -thread -rw=3Drandwri=
te
> > -filename=3D/dev/hioa2  -name=3D"EBS 8KB randwrite test" -iodepth=3D64
> -runtime=3D60
> > The results was normal, the iops is about 210k=C2=B1 all the time.
>
> That's not an equivalent test - it's being run direct to the block
> device, not to a file on the filesytem on the block device, and so
> you won't see artifacts taht are a result of creating worst case
> file fragmentation....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11490f0279db9205304a2f01
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div><br></div><div>Thank you for your reply. I di=
d some test today and described those as follows:</div><div><br></div><div>=
D<font color=3D"#500050"><span style=3D"font-size:14px">elete the existing =
test file , and redo the test :=C2=A0</span></font><span style=3D"color:rgb=
(80,0,80);font-size:14px">fio -ioengine=3Dlibaio -bs=3D4k=C2=A0</span><span=
 style=3D"color:rgb(80,0,80);font-size:14px">-direct=3D1 -thread -rw=3Drand=
write -size=3D50G -filename=3D/mnt/test -name=3D&quot;EBS=C2=A0</span><span=
 style=3D"color:rgb(80,0,80);font-size:14px">4KB randwrite test&quot; -iode=
pth=3D64 -runtime=3D60</span></div><div><span style=3D"color:rgb(80,0,80);f=
ont-size:14px">The iops resultes is 19k=C2=B1</span><span style=3D"color:rg=
b(80,0,80);font-size:14px">(per second)</span><span style=3D"color:rgb(80,0=
,80);font-size:14px">; =C2=A0I continue to fio this test file untill it was=
 filled to the full. Then I did another test using the same test case, the =
results was 210k=C2=B1(per second).(The results mentioned yesterday was=C2=
=A0</span><font color=3D"#500050"><span style=3D"font-size:14px">partial.=
=C2=A0 I used the same test file several times,=C2=A0</span></font><span st=
yle=3D"font-size:14px">the results degraded because of the test file was no=
t fill to the full</span><span style=3D"color:rgb(80,0,80);font-size:14px">=
)=C2=A0</span></div><div><br></div><div><font color=3D"#500050"><span style=
=3D"font-size:14px">I try to remake the filesystem using the following comm=
and to increase the internal log size , inode size and agcount num:</span><=
/font></div><div><font color=3D"#500050"><span style=3D"font-size:14px">mkf=
s.xfs /dev/hioa2 -f -n size=3D64k -i size=3D2048,align=3D1 -d agcount=3D204=
5 -l size=3D512m</span></font></div><div><font color=3D"#500050"><span styl=
e=3D"font-size:14px">but it has no help to the result.</span></font></div><=
div><font color=3D"#500050"><span style=3D"font-size:14px"><br></span></fon=
t></div><div><br></div><div>Any suggestion to deal with this problems ?<br>=
</div><div>I very appreciate your feedback.</div><div><span style=3D"color:=
rgb(80,0,80);font-size:14px">=C2=A0 =C2=A0=C2=A0</span><br></div><div><span=
 style=3D"color:rgb(80,0,80);font-size:14px">songbo</span></div><div><br></=
div><div>=C2=A0 =C2=A0=C2=A0</div><div><span style=3D"color:rgb(80,0,80);fo=
nt-size:14px">=C2=A0 =C2=A0=C2=A0</span></div><div><br></div></div><div cla=
ss=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-04-12 7:10 GMT+08:00=
 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" =
target=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Mon, Apr 11, 2016 at 10:14:06PM +0800, So=
ngbo Wang wrote:<br>
&gt; Hi xfsers:<br>
&gt;<br>
&gt; I got some troubles on the performance of=C2=A0 xfs.<br>
&gt; The environment is ,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 xfs version is 3.2.1,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 centos 7.1,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 kernel version:3.10.0-229.el7.x86_64.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 pcie-ssd card,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mkfs: mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=
=3D512 -d agcount=3D40 -l<br>
&gt; size=3D1024m.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mount: mount /dev/hioa2 /mnt/=C2=A0 -t xfs -o<br>
&gt; rw,noexec,nodev,noatime,nodiratime,nobarrier,discard,inode64,logbsize=
=3D256k,delaylog<br>
&gt; I use the following command to test iops: fio -ioengine=3Dlibaio -bs=
=3D4k<br>
&gt; -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/test =
-name=3D&quot;EBS<br>
&gt; 4KB randwrite test&quot; -iodepth=3D64 -runtime=3D60<br>
&gt; The results is normal at the beginning which is about 210k=C2=B1=EF=BC=
=8Cbut some<br>
&gt; seconds later, the results down to 19k=C2=B1.<br>
<br>
</span>Looks like the workload runs out of log space due to all the<br>
allocation transactions being logged, which then causes new<br>
transactions to start tail pushing the log to flush dirty metadata.<br>
This is needed to to make more space in the log for on incoming dio<br>
writes that require allocation transactions. This will block IO<br>
submission until there is space available in the log.<br>
<br>
Let&#39;s face it, all that test does is create a massively fragmented<br>
50GB file, so you&#39;re going to have a lot of metadata to log. Do the<br>
maths - if it runs at 200kiops for a few seconds, it&#39;s created a<br>
million extents.<br>
<br>
And it&#39;s doing random insert on the extent btree, so<br>
it&#39;s repeatedly dirtying the entire extent btree. This will trigger<br>
journal commits quite frequently as this is a large amount of<br>
metadata that is being dirtied. e.g. at 500 extent records per 4k<br>
block, a million extents will require 2000 leaf blocks to store them<br>
all. That&#39;s 80MB of metadata per million extents that this workload<br>
is generating and repeatedly dirtying.<br>
<br>
Then there&#39;s also other metadata, like the free space btrees, that<br>
is also being repeatedly dirtied, etc, so it would not be unexpected<br>
to see a workload like this on high IOPS devices allocating 100MB of<br>
metadata every few seconds and the amount being journalled steadily<br>
increasing until the file is fully populated.<br>
<span class=3D""><br>
&gt; I did a senond test ,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 umount the /dev/hioa2,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 fio -ioengine=3Dlibaio -bs=3D4k -direct=3D1=C2=A0 =
-thread -rw=3Drandwrite<br>
&gt; -filename=3D/dev/hioa2=C2=A0 -name=3D&quot;EBS 8KB randwrite test&quot=
; -iodepth=3D64 -runtime=3D60<br>
&gt; The results was normal, the iops is about 210k=C2=B1 all the time.<br>
<br>
</span>That&#39;s not an equivalent test - it&#39;s being run direct to the=
 block<br>
device, not to a file on the filesytem on the block device, and so<br>
you won&#39;t see artifacts taht are a result of creating worst case<br>
file fragmentation....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a11490f0279db9205304a2f01--


--===============1812826087976803124==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1812826087976803124==--
