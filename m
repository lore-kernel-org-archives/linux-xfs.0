Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AFA67F4E
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 13:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BE2BAC001
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 11:59:49 -0800 (PST)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	YJr07ZYnF9jyLGtq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 30 Nov 2014 11:59:47 -0800 (PST)
Received: by mail-ig0-f176.google.com with SMTP id l13so12851447iga.15
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 11:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF3jHnqRp9HCuXcgv7SBE=kNJ036GysLAx+dgL6v2V_jN2Nrng@mail.gmail.com>
References: <BLU402-EAS378FD8635CA1BB0E77ED211E1890@phx.gbl>
	<CAFhuFEf9MsLBEpc7xYoFNY9F_VwZAUzTQCwhH_zgRZUZX89A0Q@mail.gmail.com>
	<CAJAKVEHjveuH0TDjk_L291ADd242K-Zq1nMaEHsrAhO-c7mLbg@mail.gmail.com>
	<CAFhuFEfr=JrFv4=4E2RG_5qr4GLqGovFLh+OxnkOnfzgmNbCVQ@mail.gmail.com>
	<CAFhuFEfPzJcgr=60k=FZ_K0kcLxmr=F0w1idRtLheLLUOQfFKQ@mail.gmail.com>
	<BLU402-EAS63BA21BE641D092688C4CAE1700@phx.gbl>
	<CAJAKVEFdkSEMW84=TvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A@mail.gmail.com>
	<CAFhuFEd3eVhKy1Jg7qL-ycw4XHnAd16kkstpOhOUpwVsAPN5mw@mail.gmail.com>
	<CAJAKVEHs=FczXUnAYfhbdav1o6JONmD7y0Kgc1xUo1t9g3=63Q@mail.gmail.com>
	<CAJAKVEFk5oc98gqF8CnGzz7Vsat-i=0da+aYwJh-EGX8eX9sgw@mail.gmail.com>
	<CAFhuFEc+mbGqZtDVY_wT99dd=FPUKDKZkHN3FYaBgzaVEb=q_A@mail.gmail.com>
	<CAJAKVEFD0PuFW0eF_Csk1oQJnzZ2eYW=pywHFKJb-ArroRq_cA@mail.gmail.com>
	<CAJAKVEE2Lu=MReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw@mail.gmail.com>
	<CAF3jHnqRp9HCuXcgv7SBE=kNJ036GysLAx+dgL6v2V_jN2Nrng@mail.gmail.com>
Date: Mon, 1 Dec 2014 01:29:47 +0530
Message-ID: <CAJAKVEEAAaf-sA+jbTr8A_HAUMcToo6Esd8ithPvE4tY4TW2NA@mail.gmail.com>
Subject: Re: Meeting
From: Somdeep Dey <somdeepdey10@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5553009007964826517=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5553009007964826517==
Content-Type: multipart/alternative; boundary=001a113fbe2e9a6ad1050918ef76

--001a113fbe2e9a6ad1050918ef76
Content-Type: text/plain; charset=UTF-8

Hi,

We've now resumed working on the xfs_fsr utility as discussed before, after
our exams.

The first task that we undertook was to use fiemap to get file extent
mappings and tried to correlate the output with the information obtained
from xfs_bmap. For this we used the two underlying structures fiemap
and fiemap_extent. We're now trying to use the available free space mapping
patches to get free spaces in the file system.

We also wanted to ask about the current status of the rmap, as we'll
be required to define the interfaces that query it, as a key component of
our
work.

Regards,
A-DRS.


On Mon, Dec 1, 2014 at 1:01 AM, Swapnil Pimpale <pimpale.swapnil@gmail.com>
wrote:

> Just say that you have resumed work on the project after the exam.
>
> On Sun, Nov 30, 2014 at 2:16 PM, Somdeep Dey <somdeepdey10@gmail.com>
> wrote:
>
>> This is the final draft :
>> Hi,
>> We were occupied with our exams for the last two months.
>> We've now resumed working on the xfs_fsr utility as discussed before.
>>
>> The first task that we undertook was to use fiemap to get file extent
>> mappings and tried to correlate the output with the information obtained
>> from xfs_bmap. For this we used the two underlying structures fiemap
>> and fiemap_extent. We're now trying to use the available free space
>> mapping
>> patches to get free spaces in the file system.
>>
>> We also wanted to ask about the current status of the rmap, as we'll
>> be required to define the interfaces that query it, as a key component of
>> our
>> work.
>>
>> Regards,
>> A-DRS.
>>
>> On Sun, Nov 30, 2014 at 11:55 PM, Somdeep Dey <somdeepdey10@gmail.com>
>> wrote:
>>
>>> Hi,
>>> We were occupied with our exams for the last two months.
>>> We've now resumed working on the xfs_fsr utility as discussed before.
>>>
>>> The first task that we undertook was to use fiemap to get file extent
>>> mappings and tried to correlate the output with the information obtained
>>> from xfs_bmap. For this we used the two underlying structures fiemap
>>> and fiemap_extent. We're now trying to use the available free space
>>> mapping
>>> patches to get free spaces in the file system.
>>>
>>> We also wanted to ask about the current status of the rmap, as we'll
>>> be required to define the interfaces that query it, as a key component
>>> of our
>>> work.
>>>
>>> Regards,
>>> A-DRS.
>>>
>>> On Sun, Nov 30, 2014 at 9:37 PM, Nafisa Mandliwala <
>>> nafisa.mandliwala@gmail.com> wrote:
>>>
>>>> Umm, no need to apologize.
>>>>
>>>> What you showed me on Thursday was the standard fiemap ioctl that gives
>>>> the extents used by a file.
>>>> Say that you're now trying to use Dave's freespace mapping patches to
>>>> get free spaces in the file system.
>>>> Also, you're going to *define* the interfaces needed to query the
>>>> rmap, not just query them.
>>>>
>>>> Looks fine otherwise.
>>>>
>>>> On Sun, Nov 30, 2014 at 9:16 PM, Somdeep Dey <somdeepdey10@gmail.com>
>>>> wrote:
>>>>
>>>>> Hi,
>>>>> This is the mail we drafted for Dave :
>>>>>
>>>>> Hi,
>>>>> We'd like to apologise for our unavailability over the last two months
>>>>> given the occurrence of our exams. We've now resumed working on the
>>>>> xfs_fsr utility as discussed before.
>>>>>
>>>>> The first task that we undertook was to use fiemap to get file extent
>>>>> mappings and tried to correlate the output with the information
>>>>> obtained
>>>>> from xfs_bmap. For this we used the two underlying structures fiemap
>>>>> and fiemap_extent.
>>>>>
>>>>> We also wanted to ask about the current status of the rmap, as we'll
>>>>> be required to query the interfaces of that as a key component of our
>>>>> work.
>>>>>
>>>>> Regards,
>>>>> A-DRS.
>>>>>
>>>>>
>>>>> Do tell us if this will suffice.
>>>>> Thanks,
>>>>> A-DRS.
>>>>>
>>>>> On Sun, Nov 30, 2014 at 9:05 PM, Somdeep Dey <somdeepdey10@gmail.com>
>>>>> wrote:
>>>>>
>>>>>> Hi,
>>>>>> This is the mail we drafted for Dave :
>>>>>>
>>>>>> Hi,
>>>>>> We'd like to apologise for our unavailability over the last two months
>>>>>> given the occurrence of our exams. We've now resumed working on the
>>>>>> xfs_fsr utility as discussed before.
>>>>>>
>>>>>> The first task that we undertook was to use fiemap to get file extent
>>>>>> mappings and tried to correlate the output with the information
>>>>>> obtained
>>>>>> from xfs_bmap. For this we used the two underlying structures fiemap
>>>>>> and fiemap_extent.
>>>>>>
>>>>>> We also wanted to ask about the current status of the rmap, as we'll
>>>>>> be required to query the interfaces of that as a key component of our
>>>>>> work.
>>>>>>
>>>>>> Regards,
>>>>>> A-DRS.
>>>>>>
>>>>>>
>>>>>> Do tell us if this will suffice.
>>>>>> Thanks,
>>>>>> A-DRS.
>>>>>>
>>>>>> On Thu, Nov 27, 2014 at 9:39 PM, Nafisa Mandliwala <
>>>>>> nafisa.mandliwala@gmail.com> wrote:
>>>>>>
>>>>>>> Guys, you can find the xfs_alloc.h, xfs_alloc.c and xfs_iops.c in
>>>>>>> linux-x.x.x/fs/xfs/
>>>>>>> Please check if it has the changes we're looking for.
>>>>>>>
>>>>>>> I couldn't find anything on rmap, you should write a mail asap.
>>>>>>>
>>>>>>> On Thu, Nov 27, 2014 at 2:40 AM, Somdeep Dey <somdeepdey10@gmail.com
>>>>>>> > wrote:
>>>>>>>
>>>>>>>> Hi,
>>>>>>>> We ran the code for fiemap on files, that included  the following
>>>>>>>> three types :
>>>>>>>> 1) A non-fragmented file
>>>>>>>> 2) A fragmented file before using xfs_fsr
>>>>>>>> 3) The defragmeneted equivalent of the above file after using
>>>>>>>> xfs_fsr
>>>>>>>>
>>>>>>>>
>>>>>>>> Thereafter we examined the data by printing the fiemap structure
>>>>>>>> and fiemap_extents struct. The logs for the process followed is also
>>>>>>>> attached here.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> A-DRS.
>>>>>>>>
>>>>>>>> --
>>>>>>>> You received this message because you are subscribed to the Google
>>>>>>>> Groups "ADRScube" group.
>>>>>>>> To unsubscribe from this group and stop receiving emails from it,
>>>>>>>> send an email to adrscube+unsubscribe@googlegroups.com.
>>>>>>>> To view this discussion on the web visit
>>>>>>>> https://groups.google.com/d/msgid/adrscube/CAJAKVEFdkSEMW84%3DTvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A%40mail.gmail.com
>>>>>>>> <https://groups.google.com/d/msgid/adrscube/CAJAKVEFdkSEMW84%3DTvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A%40mail.gmail.com?utm_medium=email&utm_source=footer>
>>>>>>>> .
>>>>>>>>
>>>>>>>> For more options, visit https://groups.google.com/d/optout.
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>  --
>> You received this message because you are subscribed to the Google Groups
>> "ADRScube" group.
>> To unsubscribe from this group and stop receiving emails from it, send an
>> email to adrscube+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit
>> https://groups.google.com/d/msgid/adrscube/CAJAKVEE2Lu%3DMReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw%40mail.gmail.com
>> <https://groups.google.com/d/msgid/adrscube/CAJAKVEE2Lu%3DMReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw%40mail.gmail.com?utm_medium=email&utm_source=footer>
>> .
>>
>> For more options, visit https://groups.google.com/d/optout.
>>
>
>
>
> --
>         Swapnil
>

--001a113fbe2e9a6ad1050918ef76
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D""><span class=3D"im"><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">Hi,</div><div style=3D=
"font-family:arial,sans-serif;font-size:13px"><br></div><span style=3D"font=
-family:arial,sans-serif;font-size:13px"><div>We&#39;ve now resumed working=
 on the xfs_fsr utility as discussed before, after our exams.</div><div><br=
></div><div>The first task that we undertook was to use fiemap to get file =
extent=C2=A0</div></span><span style=3D"font-family:arial,sans-serif;font-s=
ize:13px">mappings and tried to correlate the output with the information o=
btained<br></span><div style=3D"font-family:arial,sans-serif;font-size:13px=
">from xfs_bmap. For this we used the two underlying structures fiemap<div>=
and fiemap_extent. We&#39;re now trying to use the available free space map=
ping</div><div>patches to get free spaces in the file system.</div><div><br=
></div>We also wanted to ask about the current status of the rmap, as we&#3=
9;ll<div>be required to define the interfaces that query it, as a key compo=
nent of our</div><div>work.</div><div><br></div><div>Regards,</div><div>A-D=
RS.</div><div><br></div></div></span></div></div><div class=3D""><div class=
=3D"adm" style=3D"font-family:arial,sans-serif;font-size:13px"></div><div c=
lass=3D"im" style=3D"font-family:arial,sans-serif;font-size:13px"></div></d=
iv></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, =
Dec 1, 2014 at 1:01 AM, Swapnil Pimpale <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:pimpale.swapnil@gmail.com" target=3D"_blank">pimpale.swapnil@gmail.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">J=
ust say that you have resumed work on the project after the exam.</div><div=
 class=3D"gmail_extra"><br><div class=3D"gmail_quote"><div><div class=3D"h5=
">On Sun, Nov 30, 2014 at 2:16 PM, Somdeep Dey <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:somdeepdey10@gmail.com" target=3D"_blank">somdeepdey10@gmail.co=
m</a>&gt;</span> wrote:<br></div></div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div>=
<div class=3D"h5"><div dir=3D"ltr"><div style=3D"font-family:arial,sans-ser=
if;font-size:13px;color:rgb(80,0,80)">This is the final draft :=C2=A0</div>=
<div style=3D"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80=
)">Hi,</div><div style=3D"font-family:arial,sans-serif;font-size:13px;color=
:rgb(80,0,80)">We were occupied with our exams for the last two months.</di=
v><span><span style=3D"font-family:arial,sans-serif;font-size:13px"><div>We=
&#39;ve now resumed working on the xfs_fsr utility as discussed before.</di=
v><div><br></div><div>The first task that we undertook was to use fiemap to=
 get file extent=C2=A0</div></span></span><span><span style=3D"font-family:=
arial,sans-serif;font-size:13px">mappings and tried to correlate the output=
 with the information obtained<br></span></span><div style=3D"font-family:a=
rial,sans-serif;font-size:13px;color:rgb(80,0,80)"><span><span>from xfs_bma=
p. For this we used the two underlying structures fiemap</span></span><div>=
and fiemap_extent. We&#39;re now trying to use the available free space map=
ping</div><span><span><div>patches to get free spaces in the file system.</=
div><div><br></div></span></span><span><span>We also wanted to ask about th=
e current status of the rmap, as we&#39;ll</span></span><div>be required to=
 define the interfaces that query it, as a key component of our</div><div>w=
ork.</div><div><br></div><div>Regards,</div><div>A-DRS.</div></div></div><d=
iv class=3D"gmail_extra"><br><div class=3D"gmail_quote"><span>On Sun, Nov 3=
0, 2014 at 11:55 PM, Somdeep Dey <span dir=3D"ltr">&lt;<a href=3D"mailto:so=
mdeepdey10@gmail.com" target=3D"_blank">somdeepdey10@gmail.com</a>&gt;</spa=
n> wrote:<br></span><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div st=
yle=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-size:13px">Hi,<=
/div><div style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-siz=
e:13px">We were occupied with our exams for the last two months.</div><span=
><span><div style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-s=
ize:13px">We&#39;ve now resumed working on the xfs_fsr utility as discussed=
 before.</div><div style=3D"color:rgb(80,0,80);font-family:arial,sans-serif=
;font-size:13px"><br></div><div style=3D"color:rgb(80,0,80);font-family:ari=
al,sans-serif;font-size:13px">The first task that we undertook was to use f=
iemap to get file extent=C2=A0</div></span></span><span><span><div style=3D=
"color:rgb(80,0,80);font-family:arial,sans-serif;font-size:13px">mappings a=
nd tried to correlate the output with the information obtained<br></div></s=
pan></span><div style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;fo=
nt-size:13px"><span><span><div>from xfs_bmap. For this we used the two unde=
rlying structures fiemap</div></span></span><div>and fiemap_extent. We&#39;=
re now trying to use the available free space mapping</div><span><span><div=
>patches to get free spaces in the file system.</div><div><br></div></span>=
</span><span><span><div>We also wanted to ask about the current status of t=
he rmap, as we&#39;ll</div></span></span><div>be required to define the int=
erfaces that query it, as a key component of our</div><div>work.</div><div>=
<br></div><div>Regards,</div><div>A-DRS.</div></div></div><div><div><div><d=
iv><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sun, Nov 30=
, 2014 at 9:37 PM, Nafisa Mandliwala <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:nafisa.mandliwala@gmail.com" target=3D"_blank">nafisa.mandliwala@gmail.co=
m</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">=
Umm, no need to apologize.<div><br></div><div>What you showed me on Thursda=
y was the standard fiemap ioctl that gives the extents used by a file.</div=
><div>Say that you&#39;re now trying to use Dave&#39;s freespace mapping pa=
tches to get free spaces in the file system.</div><div>Also, you&#39;re goi=
ng to=C2=A0<span style=3D"font-family:arial,sans-serif;font-size:13px"><b><=
i>define</i></b> the interfaces needed to query=C2=A0</span><span style=3D"=
font-family:arial,sans-serif;font-size:13px">the rmap, not just query them.=
</span></div><div><br></div><div>Looks fine otherwise.</div></div><div><div=
><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sun, Nov 30, =
2014 at 9:16 PM, Somdeep Dey <span dir=3D"ltr">&lt;<a href=3D"mailto:somdee=
pdey10@gmail.com" target=3D"_blank">somdeepdey10@gmail.com</a>&gt;</span> w=
rote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;borde=
r-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><span><div dir=3D"=
ltr" style=3D"font-family:arial,sans-serif;font-size:13px"><div>Hi,<br></di=
v><div>This is the mail we drafted for Dave :=C2=A0</div><div><br></div><di=
v>Hi,</div><div>We&#39;d like to apologise for our unavailability over the =
last two months</div><div>given the occurrence of our exams. We&#39;ve now =
resumed working on the xfs_fsr utility as discussed before.</div><div><br><=
/div><div>The first task that we undertook was to use fiemap to get file ex=
tent=C2=A0</div><div><img src=3D"https://ssl.gstatic.com/ui/v1/icons/mail/i=
mages/cleardot.gif"></div><div><div>mappings and tried to correlate the out=
put with the information obtained</div><div>from xfs_bmap. For this we used=
 the two underlying structures fiemap</div><div>and fiemap_extent.</div><di=
v><br></div><div>We also wanted to ask about the current status of the rmap=
, as we&#39;ll</div><div>be required to query the interfaces of that as a k=
ey component of our</div><div>work.</div><div><br></div><div>Regards,</div>=
<div>A-DRS.</div><div><br></div><div><br></div><div>Do tell us if this will=
 suffice.</div><div>Thanks,</div><div>A-DRS.</div></div></div></span><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px"><div><img src=3D"https=
://ssl.gstatic.com/ui/v1/icons/mail/images/cleardot.gif"></div></div></div>=
<div><div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sun,=
 Nov 30, 2014 at 9:05 PM, Somdeep Dey <span dir=3D"ltr">&lt;<a href=3D"mail=
to:somdeepdey10@gmail.com" target=3D"_blank">somdeepdey10@gmail.com</a>&gt;=
</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><span sty=
le=3D"font-family:arial,sans-serif;font-size:13px"><div>Hi,<br></div><div>T=
his is the mail we drafted for Dave :=C2=A0</div><div><br></div><div>Hi,</d=
iv><div>We&#39;d like to apologise for our unavailability over the last two=
 months</div></span><div style=3D"font-family:arial,sans-serif;font-size:13=
px">given the occurrence of our exams. We&#39;ve now resumed working on the=
 xfs_fsr utility as discussed before.</div><div style=3D"font-family:arial,=
sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial,sans-s=
erif;font-size:13px">The first task that we undertook was to use fiemap to =
get file extent=C2=A0</div><div style=3D"font-family:arial,sans-serif;font-=
size:13px"><div><img src=3D"https://ssl.gstatic.com/ui/v1/icons/mail/images=
/cleardot.gif"></div></div><div style=3D"font-family:arial,sans-serif;font-=
size:13px"><span><div>mappings and tried to correlate the output with the i=
nformation obtained</div><div>from xfs_bmap. For this we used the two under=
lying structures fiemap</div><div>and fiemap_extent.</div><div><br></div><d=
iv>We also wanted to ask about the current status of the rmap, as we&#39;ll=
</div><div>be required to query the interfaces of that as a key component o=
f our</div><div>work.</div><div><br></div><div>Regards,</div><div>A-DRS.</d=
iv><div><br></div><div><br></div><div>Do tell us if this will suffice.</div=
><div>Thanks,</div><div>A-DRS.</div></span></div></div><div><div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Nov 27, 2014 at 9:3=
9 PM, Nafisa Mandliwala <span dir=3D"ltr">&lt;<a href=3D"mailto:nafisa.mand=
liwala@gmail.com" target=3D"_blank">nafisa.mandliwala@gmail.com</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Guys, you can=
 find the xfs_alloc.h, xfs_alloc.c and xfs_iops.c in linux-x.x.x/fs/xfs/<di=
v>Please check if it has the changes we&#39;re looking for.<br><br>I couldn=
&#39;t find anything on rmap, you should write a mail asap.</div></div><div=
 class=3D"gmail_extra"><br><div class=3D"gmail_quote"><div><div>On Thu, Nov=
 27, 2014 at 2:40 AM, Somdeep Dey <span dir=3D"ltr">&lt;<a href=3D"mailto:s=
omdeepdey10@gmail.com" target=3D"_blank">somdeepdey10@gmail.com</a>&gt;</sp=
an> wrote:<br></div></div><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><div><div dir=
=3D"ltr">Hi,<div>We ran the code for fiemap on files, that included =C2=A0t=
he following three types :=C2=A0</div><div><div>1) A non-fragmented file</d=
iv><div>2) A fragmented file before using xfs_fsr</div><div>3) The defragme=
neted equivalent of the above file after using xfs_fsr</div></div><div><br>=
</div><div><br></div><div class=3D"gmail_extra">Thereafter we examined the =
data by printing the fiemap structure and fiemap_extents struct. The logs f=
or the process followed is also attached here.=C2=A0<br></div><div class=3D=
"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks,</div><div class=
=3D"gmail_extra">A-DRS.</div></div></div></div><span>

<p></p>

-- <br><span>
You received this message because you are subscribed to the Google Groups &=
quot;ADRScube&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:adrscube+unsubscribe@googlegroups.com" target=3D"=
_blank">adrscube+unsubscribe@googlegroups.com</a>.<br></span></span>
To view this discussion on the web visit <a href=3D"https://groups.google.c=
om/d/msgid/adrscube/CAJAKVEFdkSEMW84%3DTvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A%4=
0mail.gmail.com?utm_medium=3Demail&amp;utm_source=3Dfooter" target=3D"_blan=
k">https://groups.google.com/d/msgid/adrscube/CAJAKVEFdkSEMW84%3DTvRNqOQdNM=
z6nS_WRVGN-2MX5se9NUaV1A%40mail.gmail.com</a>.<span><div><div><br>
For more options, visit <a href=3D"https://groups.google.com/d/optout" targ=
et=3D"_blank">https://groups.google.com/d/optout</a>.<br>
</div></div></span></blockquote></div><br></div>
</blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></div></div></blockquote></div><br></div><div><div>

<p></p>

-- <br>
You received this message because you are subscribed to the Google Groups &=
quot;ADRScube&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:adrscube+unsubscribe@googlegroups.com" target=3D"=
_blank">adrscube+unsubscribe@googlegroups.com</a>.<br></div></div></div></d=
iv>
To view this discussion on the web visit <a href=3D"https://groups.google.c=
om/d/msgid/adrscube/CAJAKVEE2Lu%3DMReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw%4=
0mail.gmail.com?utm_medium=3Demail&amp;utm_source=3Dfooter" target=3D"_blan=
k">https://groups.google.com/d/msgid/adrscube/CAJAKVEE2Lu%3DMReV9fdg0L4OvWA=
ymJJv9qteNDm_1oHyNNcdKVw%40mail.gmail.com</a>.<span class=3D""><div><div><b=
r>
For more options, visit <a href=3D"https://groups.google.com/d/optout" targ=
et=3D"_blank">https://groups.google.com/d/optout</a>.<br>
</div></div></span></blockquote></div><span class=3D"HOEnZb"><font color=3D=
"#888888"><br><br clear=3D"all"><div><br></div>-- <br><div><div dir=3D"ltr"=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Swapnil</div></div>
</font></span></div>
</blockquote></div><br></div>

--001a113fbe2e9a6ad1050918ef76--


--===============5553009007964826517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5553009007964826517==--
