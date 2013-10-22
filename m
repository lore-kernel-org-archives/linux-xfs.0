Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BF8E7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 06:25:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26CBBAC003
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 04:25:07 -0700 (PDT)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id knzHGd2balkaRlUI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Oct 2013 04:25:05 -0700 (PDT)
Received: by mail-oa0-f47.google.com with SMTP id i18so3342853oag.34
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 04:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPU9cc2EsoeNE+mMQSwmLVXyyPoE9jLVhDRcQLJxvWYTNU-33w@mail.gmail.com>
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
	<20131022001218.GH4446@dastard>
	<CAPU9cc2EsoeNE+mMQSwmLVXyyPoE9jLVhDRcQLJxvWYTNU-33w@mail.gmail.com>
Date: Tue, 22 Oct 2013 13:25:04 +0200
Message-ID: <CAPU9cc3JXedegmC3MgzjtOaRLTtMZoT5C=gkS0zwTCySBqQhew@mail.gmail.com>
Subject: Re: 128 bits extent bmap for file format 2
From: Pradeep Kumar <praks411@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2824386254557333860=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2824386254557333860==
Content-Type: multipart/alternative; boundary=001a11c20a72f7306404e952a60c

--001a11c20a72f7306404e952a60c
Content-Type: text/plain; charset=ISO-8859-1

I was able to resolve the issue. This was indeed related to conversion
between FSB to actual data block in image file. I would like to thanks Dave
for showing the direction.
So to summarize the extent data (128 bits, format =2) gives absolute block
number which is in term of XFS file system block this need to be converted
into actual disk block.

I've used two macros for it.
1. #define XFS_FSB_TO_AGNO<http://lxr.free-electrons.com/ident?i=XFS_FSB_TO_AGNO>
(mp,fsbno)
2.#define XFS_FSB_TO_AGBNO<http://lxr.free-electrons.com/ident?i=XFS_FSB_TO_AGBNO>
(mp,fsbno).

First one give the actual AG number and the second one gives the block
number in that AG.

Now coming back to my previous example which I posted
My extent data was.
 00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)

After unpacking, absolute block number = 9420 (0x24cc).
Converting to actual data block using above two macros gives me AG No. = 1,
AG Block No = 1228. So final block (1*6400 + 1228 = 7628) which is
correct.(I was able to get correct file contents)
Please let me know if above computation is correct. It seems correct to me
as I'm able to retrieve all the files.

Still I couldn't get two macros.
1. #define XFS_FSS_TO_BB<http://lxr.free-electrons.com/ident?i=XFS_FSS_TO_BB>
(mp,sec <http://lxr.free-electrons.com/ident?i=sec>)
((sec<http://lxr.free-electrons.com/ident?i=sec>)
<< (mp)->m_sectbb_log).
*2. *#define XFS_BB_TO_FSBT<http://lxr.free-electrons.com/ident?i=XFS_BB_TO_FSBT>
(mp,bb <http://lxr.free-electrons.com/ident?i=bb>)
((bb<http://lxr.free-electrons.com/ident?i=bb>)
>> (mp)->m_blkbb_log).

I couldn't find m_sectbb_log and m_blkbb_log fields. Please someone share
more knowledge on above
macros like where they are used and also description of input and output
field

Thanks and Regards,
Pradeep





On 22 October 2013 10:08, Pradeep Kumar <praks411@gmail.com> wrote:

> Hi Dave,
>
> Thanks for the reply. I think I may get my solution. Can you explain the
> difference between the two?
> I've created sample xfs file using mkfs.xfs with mostly default parameter
> 1. Sector Size = 512
> 2. Block size = 4096
> 3. AG Number = 2
> 4. Number of blocks per AG = 6400.
>
> So when I get absolute block 9420 from file extent data  I'm going to
> (6400 + 3020) , 3020 block of second AG which is wrong. The file start from
> 7628 absolute block or (6400 + 1228), 1228 block of second AG.
> Please describe in some detail above the conversion which you are talking
> about.
>
> Thanks and Regards,
> Pradeep
>
>
>
> On 22 October 2013 02:12, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar wrote:
>> > Hi,
>> >
>> > I'm writing a small utility to parse XFS fs image on windows.
>> > I'm able to fetch the files in the first AG (0).
>> > However when it comes to the files which are in different AG I'm facing
>> > some problem in parsing extent bmap 128bits data of file inode (format
>> ==
>> > 2).
>>
>> Extents use filesystem block encodings, not disk addresses. Look up
>> the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.
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

--001a11c20a72f7306404e952a60c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I was able to resolve the issue. This was indeed related t=
o conversion between FSB to actual data block in image file. I would like t=
o thanks Dave for showing the direction.=A0<div>So to summarize the extent =
data (128 bits, format =3D2) gives absolute block number which is in term o=
f XFS file system block this need to be converted into actual disk block.</=
div>

<div><br></div><div>I&#39;ve used two macros for it.</div><div>1.=A0<span s=
tyle=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier New&#39;,Cou=
rier,monospace;font-size:14px;font-weight:bold">#define </span><a href=3D"h=
ttp://lxr.free-electrons.com/ident?i=3DXFS_FSB_TO_AGNO" style=3D"border-bot=
tom-style:dotted;border-bottom-width:1px;font-size:14px;text-decoration:non=
e;font-family:Monaco,&#39;Courier New&#39;,Courier,monospace;font-weight:bo=
ld;border-bottom-color:rgb(153,153,153)" target=3D"_blank">XFS_FSB_TO_AGNO<=
/a><span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier Ne=
w&#39;,Courier,monospace;font-size:14px;font-weight:bold">(mp,fsbno)</span>=
<span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier New&#=
39;,Courier,monospace;font-size:14px;font-weight:bold">=A0</span></div>

<div><span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier =
New&#39;,Courier,monospace;font-size:14px;font-weight:bold">2.#define </spa=
n><a href=3D"http://lxr.free-electrons.com/ident?i=3DXFS_FSB_TO_AGBNO" styl=
e=3D"border-bottom-style:dotted;border-bottom-width:1px;font-size:14px;text=
-decoration:none;font-family:Monaco,&#39;Courier New&#39;,Courier,monospace=
;font-weight:bold;border-bottom-color:rgb(153,153,153)" target=3D"_blank">X=
FS_FSB_TO_AGBNO</a><span style=3D"color:rgb(120,120,120);font-family:Monaco=
,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weight:bold">(=
mp,fsbno).</span></div>

<div><br></div><div>First one give the actual AG number and the second one =
gives the block number in that AG.</div><div><br></div><div>Now coming back=
 to my previous example which I posted</div><div>My extent data was.</div>
<div><span style=3D"font-family:arial,sans-serif;font-size:12.7272720336914=
06px">=A000 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)</span><br></=
div><div><span style=3D"font-family:arial,sans-serif;font-size:12.727272033=
691406px"><br>
</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:12.=
727272033691406px">After unpacking, absolute block number =3D 9420 (0x24cc)=
.</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:12=
.727272033691406px">Converting to actual data block using above two macros =
gives me AG No. =3D 1, AG Block No =3D 1228. So final block (1*6400 + 1228 =
=3D 7628) which is correct.(I was able to get correct file contents)</span>=
</div>
<div><font face=3D"arial, sans-serif">Please let me know if above computati=
on is correct. It seems correct to me as I&#39;m able to retrieve all the f=
iles.</font></div><div><span style=3D"font-family:arial,sans-serif;font-siz=
e:12.727272033691406px"><br>
</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:12.=
727272033691406px">Still I couldn&#39;t get two macros.</span></div><div><s=
pan style=3D"font-family:arial,sans-serif;font-size:12.727272033691406px">1=
.=A0</span><span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Co=
urier New&#39;,Courier,monospace;font-size:14px;font-weight:bold">#define <=
/span><a href=3D"http://lxr.free-electrons.com/ident?i=3DXFS_FSS_TO_BB" sty=
le=3D"font-family:Monaco,&#39;Courier New&#39;,Courier,monospace;font-size:=
14px;font-weight:bold;text-decoration:none;border-bottom-width:1px;border-b=
ottom-style:dotted;border-bottom-color:rgb(153,153,153);color:black">XFS_FS=
S_TO_BB</a><span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Co=
urier New&#39;,Courier,monospace;font-size:14px;font-weight:bold">(mp,</spa=
n><a href=3D"http://lxr.free-electrons.com/ident?i=3Dsec" style=3D"font-fam=
ily:Monaco,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weig=
ht:bold;text-decoration:none;border-bottom-width:1px;border-bottom-style:do=
tted;border-bottom-color:rgb(153,153,153);color:black">sec</a><span style=
=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier New&#39;,Courier=
,monospace;font-size:14px;font-weight:bold">)   ((</span><a href=3D"http://=
lxr.free-electrons.com/ident?i=3Dsec" style=3D"font-family:Monaco,&#39;Cour=
ier New&#39;,Courier,monospace;font-size:14px;font-weight:bold;text-decorat=
ion:none;border-bottom-width:1px;border-bottom-style:dotted;border-bottom-c=
olor:rgb(153,153,153);color:black">sec</a><span style=3D"color:rgb(120,120,=
120);font-family:Monaco,&#39;Courier New&#39;,Courier,monospace;font-size:1=
4px;font-weight:bold">) &lt;&lt; (mp)-&gt;m_sectbb_log).</span></div>
<div><font color=3D"#787878" face=3D"Monaco, Courier New, Courier, monospac=
e"><b>2.=A0</b></font><span style=3D"color:rgb(120,120,120);font-family:Mon=
aco,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weight:bold=
">#define </span><a href=3D"http://lxr.free-electrons.com/ident?i=3DXFS_BB_=
TO_FSBT" style=3D"font-family:Monaco,&#39;Courier New&#39;,Courier,monospac=
e;font-size:14px;font-weight:bold;text-decoration:none;border-bottom-width:=
1px;border-bottom-style:dotted;border-bottom-color:rgb(153,153,153);color:b=
lack">XFS_BB_TO_FSBT</a><span style=3D"color:rgb(120,120,120);font-family:M=
onaco,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weight:bo=
ld">(mp,</span><a href=3D"http://lxr.free-electrons.com/ident?i=3Dbb" style=
=3D"font-family:Monaco,&#39;Courier New&#39;,Courier,monospace;font-size:14=
px;font-weight:bold;text-decoration:none;border-bottom-width:1px;border-bot=
tom-style:dotted;border-bottom-color:rgb(153,153,153);color:black">bb</a><s=
pan style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier New&#39=
;,Courier,monospace;font-size:14px;font-weight:bold">)   ((</span><a href=
=3D"http://lxr.free-electrons.com/ident?i=3Dbb" style=3D"font-family:Monaco=
,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weight:bold;te=
xt-decoration:none;border-bottom-width:1px;border-bottom-style:dotted;borde=
r-bottom-color:rgb(153,153,153);color:black">bb</a><span style=3D"color:rgb=
(120,120,120);font-family:Monaco,&#39;Courier New&#39;,Courier,monospace;fo=
nt-size:14px;font-weight:bold">) &gt;&gt; (mp)-&gt;m_blkbb_log).</span></di=
v>
<div><span style=3D"color:rgb(120,120,120);font-family:Monaco,&#39;Courier =
New&#39;,Courier,monospace;font-size:14px;font-weight:bold"><br></span></di=
v><div>I couldn&#39;t find m_sectbb_log and m_blkbb_log fields. Please some=
one share more knowledge on above=A0</div>
<div>macros like where they are used and also description of input and outp=
ut field</div><div><br></div><div>Thanks and Regards,</div><div>Pradeep</di=
v><div><br></div><div><span style=3D"color:rgb(120,120,120);font-family:Mon=
aco,&#39;Courier New&#39;,Courier,monospace;font-size:14px;font-weight:bold=
"><br>
</span></div><div><br></div></div><div class=3D"gmail_extra"><br><br><div c=
lass=3D"gmail_quote">On 22 October 2013 10:08, Pradeep Kumar <span dir=3D"l=
tr">&lt;<a href=3D"mailto:praks411@gmail.com" target=3D"_blank">praks411@gm=
ail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi Dave,<div><br><div>Thank=
s for the reply. I think I may get my solution. Can you explain the differe=
nce between the two?</div>
<div>I&#39;ve created sample xfs file using mkfs.xfs with mostly default pa=
rameter=A0</div>
<div>1. Sector Size =3D 512</div><div>2. Block size =3D 4096</div><div>3. A=
G Number =3D 2</div><div>4. Number of blocks per AG =3D 6400.</div><div><br=
></div><div>So when I get absolute block 9420 from file extent data =A0I&#3=
9;m going to (6400 + 3020) , 3020 block of second AG which is wrong. The fi=
le start from 7628 absolute block or (6400 + 1228), 1228 block of second AG=
.=A0</div>

<div>Please describe in some detail above the conversion which you are talk=
ing about.</div><div><br></div><div>Thanks and Regards,</div><div>Pradeep</=
div><div><br></div></div></div><div class=3D"HOEnZb"><div class=3D"h5"><div=
 class=3D"gmail_extra">
<br><br><div class=3D"gmail_quote">
On 22 October 2013 02:12, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">

<div>On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;m writing a small utility to parse XFS fs image on windows.<br>
&gt; I&#39;m able to fetch the files in the first AG (0).<br>
&gt; However when it comes to the files which are in different AG I&#39;m f=
acing<br>
&gt; some problem in parsing extent bmap 128bits data of file inode (format=
 =3D=3D<br>
&gt; 2).<br>
<br>
</div>Extents use filesystem block encodings, not disk addresses. Look up<b=
r>
the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.<br>
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

--001a11c20a72f7306404e952a60c--


--===============2824386254557333860==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2824386254557333860==--
