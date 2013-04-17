Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE2A77F54
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:28:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4AE52AC004
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:28:30 -0700 (PDT)
Received: from na3sys009aog110.obsmtp.com (na3sys009aog110.obsmtp.com
	[74.125.149.203]) by cuda.sgi.com with SMTP id C3smip4pA0A0xanN
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:28:27 -0700 (PDT)
Received: by mail-gg0-f197.google.com with SMTP id k5so2270058ggn.8
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516EA959.6090205@gmail.com>
References: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
	<516EA959.6090205@gmail.com>
From: Robert Bennett <rbennett@mail.crawford.com>
Date: Wed, 17 Apr 2013 10:28:06 -0400
Message-ID: <CAFcHYYCHr20vkDnJrwB3sRrwHy323UsfivyXr7V+ABcvEimwXA@mail.gmail.com>
Subject: Re: Practical file system size question
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1484826075287107198=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com

--===============1484826075287107198==
Content-Type: multipart/alternative; boundary=001a11c2f47c91e55b04da8f4ca3

--001a11c2f47c91e55b04da8f4ca3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Thanks for the quick replies.  It's very nice.

We are using LSI MegaRAID 9280-8E cards.  I got bit by the LSI firmware bug
a while back and chased what appeared to be a memory issue before
discovering that a firmware upgrade solved all my problems.  I don't
remember how many grey hairs were a result of that exercise, but it wasn't
just a few.

We build our own storage from Super Micro Components.

Why not look at 4TB drives?  Short sightedness.  Fear.  Baby Steps.  Take
your pick.  With that being said - I will look into it.

Thanks for all the insights.

-bob

*Bob Bennett*
Director of IT
Crawford Media Services, Inc.
d: 678.536.4906 | e: rbennett@mail.crawford.com | w: www.crawford.com

6 West Druid Hills Drive, NE

Atlanta, GA 30329

view map<http://maps.google.com/maps/ms?ie=3DUTF8&msa=3D0&msid=3D2037949789=
81965716430.00049801625e306a428e2&ll=3D33.831714,-84.339152&spn=3D0.001845,=
0.004289&t=3Dh&z=3D19&iwloc=3D00049801625fe86307c32>

*Create ******** **=95** Manage ********** **=95** Serve*


On Wed, Apr 17, 2013 at 9:53 AM, Joe Landman <joe.landman@gmail.com> wrote:

> On 04/17/2013 09:18 AM, Robert Bennett wrote:
>
> [...]
>
>
>  The question is - does anyone have experience with this type of
>> configuration and in particular with 3TB HDDs and a file system size of
>> 99TB?  The rebuild time with 2TB drives is ~ 24 hours.  Should I expect
>>
>
> Yes, we've built up to 240TB raw (180TB usable) xfs systems for our
> customers on our units.  Very doable, though there are some consideration=
s.
>
> First off, why 3TB when 4TB are in market, pretty stable ... ?  Unless
> there is a budgetary limitation you are working against, I'd advise at
> least looking at those.
>
> Second, which LSI controllers are you using?  Firmware updates for the
> controllers to use 3TB and higher drives are pretty much mandated.  Our
> experience with various LSI cards has ranged from not so good to pretty
> good, and this is a firmware version revision dependent (along with drive=
r)
> issue from what we found.
>
>
>  the rebuild time for the 3TB drives to be ~ 36 hours?
>>
>
> Not in our experience.  Typically 5-10 hours depending upon RAID card
> used, RAID configuration, drives chosen, and other issues.  Its pretty
> complex, and hard to predict in advance without trying it.
>
>
> --
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics, Inc.
> email: landman@scalableinformatics.**com <landman@scalableinformatics.com=
>
> web  : http://scalableinformatics.com
>        http://scalableinformatics.**com/siflash<http://scalableinformatic=
s.com/siflash>
> phone: +1 734 786 8423 x121
> fax  : +1 866 888 3112
> cell : +1 734 612 4615
>
> ______________________________**_________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/**listinfo/xfs<http://oss.sgi.com/mailman/list=
info/xfs>
>

--001a11c2f47c91e55b04da8f4ca3
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>Thanks for the quick replies.=A0 =
It&#39;s very nice.<br><br></div>We are using LSI MegaRAID 9280-8E cards.=
=A0 I got bit by the LSI firmware bug a while back and chased what appeared=
 to be a memory issue before discovering that a firmware upgrade solved all=
 my problems.=A0 I don&#39;t remember how many grey hairs were a result of =
that exercise, but it wasn&#39;t just a few.<br>

<br></div>We build our own storage from Super Micro Components.<br><br></di=
v>Why not look at 4TB drives?=A0 Short sightedness.=A0 Fear.=A0 Baby Steps.=
=A0 Take your pick.=A0 With that being said - I will look into it.<br><br><=
/div>
Thanks for all the insights.<br>
<br></div>-bob<br></div><div class=3D"gmail_extra"><br clear=3D"all"><div><=
div dir=3D"ltr"><p><b><span style=3D"color:#1f497d">Bob Bennett</span></b><=
span style=3D"font-size:9.5pt;color:#1f497d"><br>
</span><span style=3D"font-size:10.0pt;color:#888888">Director of IT</span>=
<span style=3D"font-size:9.5pt;color:#1f497d"><br></span><span style=3D"fon=
t-size:10.0pt;color:#1f497d">Crawford Media Services, Inc.</span><span styl=
e=3D"font-size:9.5pt;color:#1f497d"><br>


</span><span style=3D"font-size:10.0pt;color:#888888">d:=A0</span><span sty=
le=3D"font-size:10.0pt;color:#3366ff"><a value=3D"+16785364906">678.536.490=
6</a> </span><span style=3D"font-size:10.0pt;color:#1f497d">|=A0</span><spa=
n style=3D"font-size:10.0pt;color:#888888">e:</span><span style=3D"font-siz=
e:10.0pt;color:#1f497d">=A0<a href=3D"mailto:rbennett@mail.crawford.com" ta=
rget=3D"_blank"><span style=3D"color:#2a5db0">rbennett@mail.crawford.com</s=
pan></a>=A0|=A0</span><span style=3D"font-size:10.0pt;color:#888888">w:</sp=
an><span style=3D"font-size:10pt;color:rgb(31,73,125)">=A0<a href=3D"http:/=
/www.crawford.com" target=3D"_blank"><span style=3D"color:rgb(42,93,176)">w=
ww.crawford.com</span></a></span></p>

<div>
<p><span style=3D"font-size:7.5pt;color:#3366ff">6 West Druid Hills Drive, =
NE</span></p>
<p><span style=3D"font-size:7.5pt;color:#3366ff">Atlanta, GA 30329</span></=
p><p><span style=3D"font-size:7.5pt;color:#3366ff"><a href=3D"http://maps.g=
oogle.com/maps/ms?ie=3DUTF8&amp;msa=3D0&amp;msid=3D203794978981965716430.00=
049801625e306a428e2&amp;ll=3D33.831714,-84.339152&amp;spn=3D0.001845,0.0042=
89&amp;t=3Dh&amp;z=3D19&amp;iwloc=3D00049801625fe86307c32" target=3D"_blank=
"><span style=3D"color:#2a5db0">view map</span></a></span></p>


<span style=3D"font-size:7.0pt;color:#1f497d"><br></span></div><b><span sty=
le=3D"font-size:10.0pt;color:#1f497d">Create </span></b><b><span style=3D"f=
ont-size:10.0pt;color:#888888"></span></b><b><span style=3D"font-size:10.0p=
t;color:#1f497d"></span></b><b><span style=3D"font-size:10.0pt;color:#88888=
8"></span></b><b><span style=3D"font-size:10.0pt;color:#1f497d"> </span></b=
><b><span style=3D"font-size:10.0pt;color:#888888">=95</span></b><b><span s=
tyle=3D"font-size:10pt;color:rgb(31,73,125)">=A0Manage </span></b><b><span =
style=3D"font-size:10.0pt;color:#1f497d"></span></b><b><span style=3D"font-=
size:10.0pt;color:#888888"></span></b><b><span style=3D"font-size:10.0pt;co=
lor:#1f497d"></span></b><b><span style=3D"font-size:10.0pt;color:#888888"><=
/span></b><b><span style=3D"font-size:10.0pt;color:#1f497d"> </span></b><b>=
<span style=3D"font-size:10.0pt;color:#888888">=95</span></b><b><span style=
=3D"font-size:10.0pt;color:#1f497d"> Serve</span></b></div>

</div>
<br><br><div class=3D"gmail_quote">On Wed, Apr 17, 2013 at 9:53 AM, Joe Lan=
dman <span dir=3D"ltr">&lt;<a href=3D"mailto:joe.landman@gmail.com" target=
=3D"_blank">joe.landman@gmail.com</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">

On 04/17/2013 09:18 AM, Robert Bennett wrote:<br>
<br>
[...]<div class=3D"im"><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
The question is - does anyone have experience with this type of<br>
configuration and in particular with 3TB HDDs and a file system size of<br>
99TB? =A0The rebuild time with 2TB drives is ~ 24 hours. =A0Should I expect=
<br>
</blockquote>
<br></div>
Yes, we&#39;ve built up to 240TB raw (180TB usable) xfs systems for our cus=
tomers on our units. =A0Very doable, though there are some considerations.<=
br>
<br>
First off, why 3TB when 4TB are in market, pretty stable ... ? =A0Unless th=
ere is a budgetary limitation you are working against, I&#39;d advise at le=
ast looking at those.<br>
<br>
Second, which LSI controllers are you using? =A0Firmware updates for the co=
ntrollers to use 3TB and higher drives are pretty much mandated. =A0Our exp=
erience with various LSI cards has ranged from not so good to pretty good, =
and this is a firmware version revision dependent (along with driver) issue=
 from what we found.<div class=3D"im">

<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
the rebuild time for the 3TB drives to be ~ 36 hours?<br>
</blockquote>
<br></div>
Not in our experience. =A0Typically 5-10 hours depending upon RAID card use=
d, RAID configuration, drives chosen, and other issues. =A0Its pretty compl=
ex, and hard to predict in advance without trying it.<br>
<br>
<br>
-- <br>
Joseph Landman, Ph.D<br>
Founder and CEO<br>
Scalable Informatics, Inc.<br>
email: <a href=3D"mailto:landman@scalableinformatics.com" target=3D"_blank"=
>landman@scalableinformatics.<u></u>com</a><br>
web =A0: <a href=3D"http://scalableinformatics.com" target=3D"_blank">http:=
//scalableinformatics.com</a><br>
=A0 =A0 =A0 =A0<a href=3D"http://scalableinformatics.com/siflash" target=3D=
"_blank">http://scalableinformatics.<u></u>com/siflash</a><br>
phone: <a href=3D"tel:%2B1%20734%20786%208423%20x121" value=3D"+17347868423=
" target=3D"_blank">+1 734 786 8423 x121</a><br>
fax =A0: <a href=3D"tel:%2B1%20866%20888%203112" value=3D"+18668883112" tar=
get=3D"_blank">+1 866 888 3112</a><br>
cell : <a href=3D"tel:%2B1%20734%20612%204615" value=3D"+17346124615" targe=
t=3D"_blank">+1 734 612 4615</a><br>
<br>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</blockquote></div><br></div>

--001a11c2f47c91e55b04da8f4ca3--


--===============1484826075287107198==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1484826075287107198==--
