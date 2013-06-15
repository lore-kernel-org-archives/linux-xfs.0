Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6390029DF8
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 11:22:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEBB5AC002
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 09:22:37 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id kqKax7J24jp3cQDZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 15 Jun 2013 09:22:35 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id n20so708234qaj.6
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 09:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
Date: Sat, 15 Jun 2013 12:22:35 -0400
Message-ID: <CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0635328067555141016=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

--===============0635328067555141016==
Content-Type: multipart/alternative; boundary=047d7b33d8926d5a2f04df33c543

--047d7b33d8926d5a2f04df33c543
Content-Type: text/plain; charset=ISO-8859-1

I was thinking a little color commentary might be helpful from a
perspective of what the functionally is that's driving the need for
fallocate.  I think I mentioned somewhere in this thread that the
application is OpenStack Swift, which is  a highly scalable cloud object
store.  If you're not familiar with it, it doesn't do successive sequential
writes to a preallocated file but rather writes out a full object in one
shot.  In other words, object = file.  The whole purpose of preallocation,
at least my understanding of it, is to make sure there is enough room when
the time comes to write the actual object so if there isn't, a redundant
server elsewhere can do it instead.  This then makes the notion of
speculative preallocation for future sequential writes moot, the ideal
being to only preallocate the object size with minimal extra I/O.  Does
that help?
-mark



On Sat, Jun 15, 2013 at 6:35 AM, Mark Seger <mjseger@gmail.com> wrote:

> Basically everything do it with collectl, a tool I wrote and opensourced
> almost 10 years ago.  it's numbers are very accurate - I've compared with
> iostat on numerous occasions whenever I might have had doubts and they
> always agree.  Since both tools get their data from the same place,
> /proc/diskstats, it's hard for them not to agree AND its numbers also agree
> with /proc/fs/xfs.
>
> Here's an example of comparing the two on a short run, leaving off the -m
> since collectl reports its output in KB.
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz
> avgqu-sz   await r_await w_await  svctm  %util
> sdc               0.00     0.00    0.00  494.00     0.00 126464.00
> 512.00     0.11    0.22    0.00    0.22   0.22  11.00
>
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size
>  RWSize  QLen  Wait SvcTim Util
> 10:18:32 sdc1             0      0    0    0  127488      0  498  256
> 256     1     0      0    7
> 10:18:33 sdc1             0      0    0    0  118784      0  464  256
> 256     1     0      0    4
>
> for grins I also ran a set of numbers at a monitoring interval of 0.2
> seconds just to see if they were steady and they are:
>
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time         Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size
>  RWSize  QLen  Wait SvcTim Util
> 10:19:50.601 sdc1             0      0    0    0     768      0    3  256
>     256     0     0      0    0
> 10:19:50.801 sdc1             0      0    0    0   23296      0   91  256
>     256     1     0      0   19
> 10:19:51.001 sdc1             0      0    0    0   32256      0  126  256
>     256     1     0      0   14
> 10:19:51.201 sdc1             0      0    0    0   29696      0  116  256
>     256     1     0      0   19
> 10:19:51.401 sdc1             0      0    0    0   30464      0  119  256
>     256     1     0      0    4
> 10:19:51.601 sdc1             0      0    0    0   32768      0  128  256
>     256     1     0      0   14
>
> but back to the problem at hand and that's the question why is this
> happening?
>
> To restate what's going on, I have a very simple script that I'm
> duplicating what openstack swift is doing, namely to create a file with
> mkstmp and than running an falloc against it.  The files are being created
> with a size of zero but it seems that xfs is generating a ton of logging
> activity.  I had read your posted back in 2011 about speculative
> preallocation and can't help but wonder if that's what hitting me here.  I
> also saw where system memory can come into play and this box has 192GB and
> 12 hyperthreaded cores.
>
> I also tried one more run without falloc, this is creating 10000 1K files,
> which should be about 10MB and it looks like it's still doing 140MB of I/O
> which still feels like a lot but at least it's less than the
>
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size
>  RWSize  QLen  Wait SvcTim Util
> 10:29:20 sdc1             0      0    0    0   89608      0  351  255
> 255     1     0      0   11
> 10:29:21 sdc1             0      0    0    0   55296      0  216  256
> 256     1     0      0    5
>
> and to repeat the full run with falloc:
>
> # DISK STATISTICS (/sec)
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size
>  RWSize  QLen  Wait SvcTim Util
> 10:30:50 sdc1             0      0    0    0   56064      0  219  256
> 256     1     0      0    2
> 10:30:51 sdc1             0      0    0    0  409720    148 1622  253
> 252     1     0      0   26
> 10:30:52 sdc1             0      0    0    0  453240    144 1796  252
> 252     1     0      0   36
> 10:30:53 sdc1             0      0    0    0  441768    298 1800  245
> 245     1     0      0   37
> 10:30:54 sdc1             0      0    0    0  455576    144 1813  251
> 251     1     0      0   25
> 10:30:55 sdc1             0      0    0    0  453532    145 1805  251
> 251     1     0      0   35
> 10:30:56 sdc1             0      0    0    0  307352    145 1233  249
> 249     1     0      0   17
> 10:30:57 sdc1             0      0    0    0       0      0    0    0
>   0     0     0      0    0
>
> If there is anything more I can provide I'll be happy to do so.  Actually
> I should point out I can easily generate graphs and if you'd like to see
> some examples I can provide those too.  Also, if there is anything I can
> report from /proc/fs/xfs I can relatively easily do that as well and
> display it side by side with the disk I/O.
>
> -mark
>
>
> On Fri, Jun 14, 2013 at 10:04 PM, Dave Chinner <david@fromorbit.com>wrote:
>
>> On Fri, Jun 14, 2013 at 09:55:17PM -0400, Mark Seger wrote:
>> > I'm doing 1 second samples and the rates are very steady.  The reason I
>> > ended up at this level of testing was I had done a sustained test for 2
>> > minutes at about 5MB/sec and was seeing over 500MB/sec going to the
>> disk,
>> > again sampling at 1-second intervals.  I'd be happy to provide detailed
>> > output and can even sample more frequently if you like.
>>
>> Where are you getting your IO throughput numbers from?
>>
>> How do they compare to, say, the output of `iostat -d -x -m 1`?
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>

--047d7b33d8926d5a2f04df33c543
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I was thinking a little color commentary might be helpful =
from a perspective of what the functionally is that&#39;s driving the need =
for fallocate. =A0I think I mentioned somewhere in this thread that the app=
lication is OpenStack Swift, which is =A0a highly scalable cloud object sto=
re. =A0If you&#39;re not familiar with it, it doesn&#39;t do successive seq=
uential writes to a preallocated file but rather writes out a full object i=
n one shot. =A0In other words, object =3D file. =A0The whole purpose of pre=
allocation, at least my understanding of it, is to make sure there is enoug=
h room when the time comes to write the actual object so if there isn&#39;t=
, a redundant server elsewhere can do it instead. =A0This then makes the no=
tion of speculative preallocation for future sequential writes moot, the id=
eal being to only preallocate the object size with minimal extra I/O. =A0Do=
es that help?<div style>
-mark</div><div style>=A0</div></div><div class=3D"gmail_extra"><br><br><di=
v class=3D"gmail_quote">On Sat, Jun 15, 2013 at 6:35 AM, Mark Seger <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:mjseger@gmail.com" target=3D"_blank">mjseg=
er@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Basically everything do it =
with collectl, a tool I wrote and opensourced almost 10 years ago. =A0it&#3=
9;s numbers are very accurate - I&#39;ve compared with iostat on numerous o=
ccasions whenever I might have had doubts and they always agree. =A0Since b=
oth tools get their data from the same place, /proc/diskstats, it&#39;s har=
d for them not to agree AND its numbers also agree with /proc/fs/xfs.<div>

<div><br></div></div><div>Here&#39;s an example of comparing the two on a s=
hort run, leaving off the -m since collectl reports its output in KB.</div>=
<div><br></div><div><div><font face=3D"courier new, monospace">Device: =A0 =
=A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 =A0rkB/s =A0 =A0w=
kB/s avgrq-sz avgqu-sz =A0 await r_await w_await =A0svctm =A0%util</font></=
div>

<div><font face=3D"courier new, monospace">sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0.00 =A0 =A0 0.00 =A0 =A00.00 =A0494.00 =A0 =A0 0.00 126464.00 =A0 512.00 =
=A0 =A0 0.11 =A0 =A00.22 =A0 =A00.00 =A0 =A00.22 =A0 0.22 =A011.00</font></=
div><div><font face=3D"courier new, monospace"><br>

</font></div><div><div><font face=3D"courier new, monospace"># =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &lt;---------reads---------&gt;&lt;---------writes-=
--------&gt;&lt;--------averages--------&gt; Pct</font></div><div><font fac=
e=3D"courier new, monospace">#Time =A0 =A0 Name =A0 =A0 =A0 KBytes Merged =
=A0IOs Size =A0KBytes Merged =A0IOs Size =A0RWSize =A0QLen =A0Wait SvcTim U=
til</font></div>

<div><font face=3D"courier new, monospace">10:18:32 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0127488 =A0 =A0 =A00 =A0498 =A02=
56 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 =A07</font></div><div><=
font face=3D"courier new, monospace">10:18:33 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =
0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0118784 =A0 =A0 =A00 =A0464 =A0256 =A0 =
=A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 =A04</font><br>

</div></div><div><br></div><div>for grins I also ran a set of numbers at a =
monitoring interval of 0.2 seconds just to see if they were steady and they=
 are:</div><div><br></div><div><div><font face=3D"courier new, monospace">#=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &lt;---------reads---------&gt=
;&lt;---------writes---------&gt;&lt;--------averages--------&gt; Pct</font=
></div>

<div><font face=3D"courier new, monospace">#Time =A0 =A0 =A0 =A0 Name =A0 =
=A0 =A0 KBytes Merged =A0IOs Size =A0KBytes Merged =A0IOs Size =A0RWSize =
=A0QLen =A0Wait SvcTim Util</font></div><div><font face=3D"courier new, mon=
ospace">10:19:50.601 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =
=A0 =A00 =A0 =A0 768 =A0 =A0 =A00 =A0 =A03 =A0256 =A0 =A0 256 =A0 =A0 0 =A0=
 =A0 0 =A0 =A0 =A00 =A0 =A00<br>

</font></div><div><font face=3D"courier new, monospace">10:19:50.801 sdc1 =
=A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 23296 =A0 =A0 =
=A00 =A0 91 =A0256 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 19</fon=
t></div><div><font face=3D"courier new, monospace">10:19:51.001 sdc1 =A0 =
=A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 32256 =A0 =A0 =A00=
 =A0126 =A0256 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 14</font></=
div>

<div><font face=3D"courier new, monospace">10:19:51.201 sdc1 =A0 =A0 =A0 =
=A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 29696 =A0 =A0 =A00 =A0116 =
=A0256 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 19</font></div><div=
><font face=3D"courier new, monospace">10:19:51.401 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 30464 =A0 =A0 =A00 =A0119 =A02=
56 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 =A04</font></div>

<div><font face=3D"courier new, monospace">10:19:51.601 sdc1 =A0 =A0 =A0 =
=A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 32768 =A0 =A0 =A00 =A0128 =
=A0256 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 14</font></div><div=
><br></div><div>but back to the problem at hand and that&#39;s the question=
 why is this happening?</div>

<div><br></div><div>To restate what&#39;s going on, I have a very simple sc=
ript that I&#39;m duplicating what openstack swift is doing, namely to crea=
te a file with mkstmp and than running an falloc against it. =A0The files a=
re being created with a size of zero but it seems that xfs is generating a =
ton of logging activity. =A0I had read your posted back in 2011 about specu=
lative preallocation and can&#39;t help but wonder if that&#39;s what hitti=
ng me here. =A0I also saw where system memory can come into play and this b=
ox has 192GB and 12 hyperthreaded cores.</div>

<div><br></div><div>I also tried one more run without falloc, this is creat=
ing 10000 1K files, which should be about 10MB and it looks like it&#39;s s=
till doing 140MB of I/O which still feels like a lot but at least it&#39;s =
less than the=A0</div>

<div><br></div><div><div><font face=3D"courier new, monospace"># =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 &lt;---------reads---------&gt;&lt;---------wri=
tes---------&gt;&lt;--------averages--------&gt; Pct</font></div><div><font=
 face=3D"courier new, monospace">#Time =A0 =A0 Name =A0 =A0 =A0 KBytes Merg=
ed =A0IOs Size =A0KBytes Merged =A0IOs Size =A0RWSize =A0QLen =A0Wait SvcTi=
m Util</font></div>

<div><font face=3D"courier new, monospace">10:29:20 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 89608 =A0 =A0 =A00 =A0351 =A02=
55 =A0 =A0 255 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 11</font></div><div><fo=
nt face=3D"courier new, monospace">10:29:21 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =
=A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 55296 =A0 =A0 =A00 =A0216 =A0256 =A0 =A0=
 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 =A05</font></div>

</div><div><br></div><div>and to repeat the full run with falloc:</div><div=
><br></div><div><div><font face=3D"courier new, monospace"># DISK STATISTIC=
S (/sec)</font></div><div><font face=3D"courier new, monospace"># =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 &lt;---------reads---------&gt;&lt;---------wri=
tes---------&gt;&lt;--------averages--------&gt; Pct</font></div>

<div><font face=3D"courier new, monospace">#Time =A0 =A0 Name =A0 =A0 =A0 K=
Bytes Merged =A0IOs Size =A0KBytes Merged =A0IOs Size =A0RWSize =A0QLen =A0=
Wait SvcTim Util</font></div><div><font face=3D"courier new, monospace">10:=
30:50 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 560=
64 =A0 =A0 =A00 =A0219 =A0256 =A0 =A0 256 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =
=A0 =A02</font></div>

<div><font face=3D"courier new, monospace">10:30:51 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0409720 =A0 =A0148 1622 =A0253 =
=A0 =A0 252 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 26</font></div><div><font =
face=3D"courier new, monospace">10:30:52 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0=
 =A0 =A00 =A0 =A00 =A0 =A00 =A0453240 =A0 =A0144 1796 =A0252 =A0 =A0 252 =
=A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 36</font></div>

<div><font face=3D"courier new, monospace">10:30:53 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0441768 =A0 =A0298 1800 =A0245 =
=A0 =A0 245 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 37</font></div><div><font =
face=3D"courier new, monospace">10:30:54 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0=
 =A0 =A00 =A0 =A00 =A0 =A00 =A0455576 =A0 =A0144 1813 =A0251 =A0 =A0 251 =
=A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 25</font></div>

<div><font face=3D"courier new, monospace">10:30:55 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0453532 =A0 =A0145 1805 =A0251 =
=A0 =A0 251 =A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 35</font></div><div><font =
face=3D"courier new, monospace">10:30:56 sdc1 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0=
 =A0 =A00 =A0 =A00 =A0 =A00 =A0307352 =A0 =A0145 1233 =A0249 =A0 =A0 249 =
=A0 =A0 1 =A0 =A0 0 =A0 =A0 =A00 =A0 17</font></div>

<div><font face=3D"courier new, monospace">10:30:57 sdc1 =A0 =A0 =A0 =A0 =
=A0 =A0 0 =A0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A0=
0 =A0 =A00 =A0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A00</font></=
div><div><br></div><div>If there is anything more I can provide I&#39;ll be=
 happy to do so. =A0Actually I should point out I can easily generate graph=
s and if you&#39;d like to see some examples I can provide those too. =A0Al=
so, if there is anything I can report from /proc/fs/xfs I can relatively ea=
sily do that as well and display it side by side with the disk I/O.</div>
<span class=3D"HOEnZb"><font color=3D"#888888">
<div><br></div><div>-mark</div></font></span></div></div></div></div><div c=
lass=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_extra"><br><br><div c=
lass=3D"gmail_quote">On Fri, Jun 14, 2013 at 10:04 PM, Dave Chinner <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">dav=
id@fromorbit.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On Fri, Jun 14, 2013 at 09:55:17PM -040=
0, Mark Seger wrote:<br>
&gt; I&#39;m doing 1 second samples and the rates are very steady. =A0The r=
eason I<br>
&gt; ended up at this level of testing was I had done a sustained test for =
2<br>
&gt; minutes at about 5MB/sec and was seeing over 500MB/sec going to the di=
sk,<br>
&gt; again sampling at 1-second intervals. =A0I&#39;d be happy to provide d=
etailed<br>
&gt; output and can even sample more frequently if you like.<br>
<br>
</div>Where are you getting your IO throughput numbers from?<br>
<br>
How do they compare to, say, the output of `iostat -d -x -m 1`?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--047d7b33d8926d5a2f04df33c543--


--===============0635328067555141016==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0635328067555141016==--
