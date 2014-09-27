Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 551D17F81
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 12:24:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 326158F804C
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 10:24:10 -0700 (PDT)
Received: from mail-ie0-f182.google.com (mail-ie0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	6yHROG7qGC1qw2eb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Sep 2014 10:24:08 -0700 (PDT)
Received: by mail-ie0-f182.google.com with SMTP id tp5so12189423ieb.27
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 10:24:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOj3taPvqEsxgKauGudL58KLoUkoLPPL9VghedruoqKnYiPi4w@mail.gmail.com>
References: <CAOj3taPoXpVktWJxmYKLZrvfe7T1qYArLsoQ39gsMdj_T1hNYg@mail.gmail.com>
	<20140927143859.GA60739@bfoster.bfoster>
	<CAOj3taPvqEsxgKauGudL58KLoUkoLPPL9VghedruoqKnYiPi4w@mail.gmail.com>
Date: Sat, 27 Sep 2014 09:53:25 -0700
Message-ID: <CAOj3taPBPR86TMg+MwQXRK7T3ch2AXdoC27rc86ac2i62Ums=Q@mail.gmail.com>
Subject: Re: blktrace and xfs_db block offset mismatch
From: Sushma R <gsushma@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6019530281450462613=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============6019530281450462613==
Content-Type: multipart/alternative; boundary=089e0149c67a42aae705040edf99

--089e0149c67a42aae705040edf99
Content-Type: text/plain; charset=UTF-8

Please ignore my last comment. It doesn't make sense since file system is
mounted on a disk partition.

>>Also, I'm not familiar enough with blktrace output off the top of my
>>head so perhaps not an issue, but it's not clear to me whether the
>>output above could have been converted/adjusted to a raw address based
>>on a device partition.

Yes, it appears that blktrace adds device partition offset.

Thanks!!


On Sat, Sep 27, 2014 at 8:40 AM, Sushma R <gsushma@gmail.com> wrote:

> Thanks Brian.
>
> I'm trying to understand how the internal XFS structures affect this
> mapping (
> http://oss.sgi.com/projects/xfs/papers/xfs_filesystem_structure.pdf)
>
> xfs_bmap on the file matches that reported by extents in the file inode
> using xfs_db.
>
> Other conversions under xfs_db
> xfs_db> convert fsb 2621481 agno
> 0x0 (0)
> xfs_db> convert fsb 2621481 agbno
> 0x280029 (2621481)
> xfs_db> convert fsb 2621481 daddr
> 0x1400148 (20971848)
>
> I tried dd command with directio option and still blktrace reports the
> same raw block number as earlier.
> 8,17   3        1     0.000000000  6999  D   R 20973896 + 1 [dd]
>
> I'm using xfs_db with the partition i.e. "xfs_db -r /dev/sdb1"
> However, if I use it on the whole disk "xfs_db -r /dev/sdb", it gives the
> following error
> xfs_db: cannot init perag data (117)
>
> Does this suggest something?
>
> Thanks,
> Sushma
>
> On Sat, Sep 27, 2014 at 7:38 AM, Brian Foster <bfoster@redhat.com> wrote:
>
>> On Sat, Sep 27, 2014 at 12:32:21AM -0700, Sushma R wrote:
>> > Hi,
>> >
>> > I ran blktrace while reading a file on XFS partition and here's it's
>> output.
>> >
>> > 8,17   3        1    22.065944956  5489  D   R 20973896 + 8 [cat]
>> >
>> > Using xfs_db, I dumped the inode for the same file and it shows the
>> > following as its data extents.
>> >
>> > u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,2621481,1,0]
>> >
>> > I understand that blktrace reports in 512-byte sectors while xfs_db in
>> > filesystem block size (which is the default 4KB on my setup).
>> > Converting blktrace offset to fs block = 2621737 which is close to the
>> data
>> > extent startblock (2621481), but still off by 256 fs blocks.
>> >
>> > Could someone please help understand the reason for this mismatch?
>> >
>>
>> I believe you are comparing a raw read of a device to an internal XFS
>> fsb, the latter of which is encoded to account for the internal
>> structure of XFS (e.g., allocation groups). You might want to take a
>> look at xfs_bmap on the file to see the actual disk blocks.
>>
>> The fsb to daddr conversion depends on the geometry of the fs, but you
>> can get the various values with xfs_db as well. E.g.:
>>
>> convert fsb 2621481 agno        # ag number
>> convert fsb 2621481 agbno       # relative ag block nr
>> convert fsb 2621481 daddr       # disk address
>>
>> Also, I'm not familiar enough with blktrace output off the top of my
>> head so perhaps not an issue, but it's not clear to me whether the
>> output above could have been converted/adjusted to a raw address based
>> on a device partition.
>>
>> You might also want to verify you're looking at the actual file read vs.
>> a directory/inode lookup or block mapping lookup or something else. I
>> see you're running cat, a direct I/O read via dd might ensure you aren't
>> just pulling file data from cache.
>>
>> Brian
>>
>> > Thanks,
>> > Sushma
>>
>> > _______________________________________________
>> > xfs mailing list
>> > xfs@oss.sgi.com
>> > http://oss.sgi.com/mailman/listinfo/xfs
>>
>>
>

--089e0149c67a42aae705040edf99
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Please ignore my last comment. It doesn&#39;t make sense s=
ince file system is mounted on a disk partition.<div><br></div><div><span s=
tyle=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-size:13px">&gt=
;&gt;Also, I&#39;m not familiar enough with blktrace output off the top of =
my</span><br style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-=
size:13px"><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;f=
ont-size:13px">&gt;&gt;head so perhaps not an issue, but it&#39;s not clear=
 to me whether the</span><br style=3D"color:rgb(80,0,80);font-family:arial,=
sans-serif;font-size:13px"><span style=3D"color:rgb(80,0,80);font-family:ar=
ial,sans-serif;font-size:13px">&gt;&gt;output above could have been convert=
ed/adjusted to a raw address based</span><br style=3D"color:rgb(80,0,80);fo=
nt-family:arial,sans-serif;font-size:13px"><span style=3D"color:rgb(80,0,80=
);font-family:arial,sans-serif;font-size:13px">&gt;&gt;on a device partitio=
n.</span><br></div><div><span style=3D"color:rgb(80,0,80);font-family:arial=
,sans-serif;font-size:13px"><br></span></div><div><font color=3D"#500050" f=
ace=3D"arial, sans-serif">Yes, it appears that blktrace adds device partiti=
on offset.</font></div><div><font color=3D"#500050" face=3D"arial, sans-ser=
if"><br></font></div><div><font color=3D"#500050" face=3D"arial, sans-serif=
">Thanks!!</font></div><div><br></div></div><div class=3D"gmail_extra"><br>=
<div class=3D"gmail_quote">On Sat, Sep 27, 2014 at 8:40 AM, Sushma R <span =
dir=3D"ltr">&lt;<a href=3D"mailto:gsushma@gmail.com" target=3D"_blank">gsus=
hma@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span=
 class=3D""><div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;fo=
nt-size:13px">Thanks Brian.</span><div style=3D"font-family:arial,sans-seri=
f;font-size:13px"><br><div>I&#39;m trying to understand how the internal XF=
S structures affect this mapping (<a href=3D"http://oss.sgi.com/projects/xf=
s/papers/xfs_filesystem_structure.pdf" target=3D"_blank">http://oss.sgi.com=
/projects/xfs/papers/xfs_filesystem_structure.pdf</a>)</div><div><br></div>=
<div>xfs_bmap on the file matches that reported by extents in the file inod=
e using xfs_db.</div><div><br></div><div>Other conversions under xfs_db</di=
v><div><div>xfs_db&gt; convert fsb 2621481 agno<br></div><div><div>0x0 (0)<=
/div><div>xfs_db&gt; convert fsb 2621481 agbno</div><div>0x280029 (2621481)=
</div><div>xfs_db&gt; convert fsb 2621481 daddr</div><div>0x1400148 (209718=
48)</div></div><div><br></div></div></div><div style=3D"font-family:arial,s=
ans-serif;font-size:13px">I tried dd command with directio option and still=
 blktrace reports the same raw block number as earlier.</div><div style=3D"=
font-family:arial,sans-serif;font-size:13px">8,17 =C2=A0 3 =C2=A0 =C2=A0 =
=C2=A0 =C2=A01 =C2=A0 =C2=A0 0.000000000 =C2=A06999 =C2=A0D =C2=A0 R 209738=
96 + 1 [dd]<br></div><div style=3D"font-family:arial,sans-serif;font-size:1=
3px"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">I=
&#39;m using xfs_db with the partition i.e. &quot;xfs_db -r /dev/sdb1&quot;=
</div><div style=3D"font-family:arial,sans-serif;font-size:13px">However, i=
f I use it on the whole disk &quot;xfs_db -r /dev/sdb&quot;, it gives the f=
ollowing error</div><div style=3D"font-family:arial,sans-serif;font-size:13=
px">xfs_db: cannot init perag data (117)<br></div><div style=3D"font-family=
:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial=
,sans-serif;font-size:13px">Does this suggest something?</div><div style=3D=
"font-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-=
family:arial,sans-serif;font-size:13px">Thanks,</div><div style=3D"font-fam=
ily:arial,sans-serif;font-size:13px">Sushma</div></div></span><div class=3D=
"gmail_extra"><br><div class=3D"gmail_quote"><span class=3D"">On Sat, Sep 2=
7, 2014 at 7:38 AM, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bf=
oster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wrote=
:<br></span><div><div class=3D"h5"><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><di=
v>On Sat, Sep 27, 2014 at 12:32:21AM -0700, Sushma R wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I ran blktrace while reading a file on XFS partition and here&#39;s it=
&#39;s output.<br>
&gt;<br>
&gt; 8,17=C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 22.065944=
956=C2=A0 5489=C2=A0 D=C2=A0 =C2=A0R 20973896 + 8 [cat]<br>
&gt;<br>
&gt; Using xfs_db, I dumped the inode for the same file and it shows the<br=
>
&gt; following as its data extents.<br>
&gt;<br>
&gt; u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] 0:[0,2621481,=
1,0]<br>
&gt;<br>
&gt; I understand that blktrace reports in 512-byte sectors while xfs_db in=
<br>
&gt; filesystem block size (which is the default 4KB on my setup).<br>
&gt; Converting blktrace offset to fs block =3D 2621737 which is close to t=
he data<br>
&gt; extent startblock (2621481), but still off by 256 fs blocks.<br>
&gt;<br>
&gt; Could someone please help understand the reason for this mismatch?<br>
&gt;<br>
<br>
</div></div>I believe you are comparing a raw read of a device to an intern=
al XFS<br>
fsb, the latter of which is encoded to account for the internal<br>
structure of XFS (e.g., allocation groups). You might want to take a<br>
look at xfs_bmap on the file to see the actual disk blocks.<br>
<br>
The fsb to daddr conversion depends on the geometry of the fs, but you<br>
can get the various values with xfs_db as well. E.g.:<br>
<br>
convert fsb 2621481 agno=C2=A0 =C2=A0 =C2=A0 =C2=A0 # ag number<br>
convert fsb 2621481 agbno=C2=A0 =C2=A0 =C2=A0 =C2=A0# relative ag block nr<=
br>
convert fsb 2621481 daddr=C2=A0 =C2=A0 =C2=A0 =C2=A0# disk address<br>
<br>
Also, I&#39;m not familiar enough with blktrace output off the top of my<br=
>
head so perhaps not an issue, but it&#39;s not clear to me whether the<br>
output above could have been converted/adjusted to a raw address based<br>
on a device partition.<br>
<br>
You might also want to verify you&#39;re looking at the actual file read vs=
.<br>
a directory/inode lookup or block mapping lookup or something else. I<br>
see you&#39;re running cat, a direct I/O read via dd might ensure you aren&=
#39;t<br>
just pulling file data from cache.<br>
<br>
Brian<br>
<br>
&gt; Thanks,<br>
&gt; Sushma<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div></div></div><br></div>
</blockquote></div><br></div>

--089e0149c67a42aae705040edf99--


--===============6019530281450462613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6019530281450462613==--
