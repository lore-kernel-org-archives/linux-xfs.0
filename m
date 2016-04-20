Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 119A77CA1
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 08:17:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFB798F8039
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 06:17:47 -0700 (PDT)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180]) by cuda.sgi.com with ESMTP id
	s0HbNjhArodqGCQu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2016 06:17:45 -0700 (PDT)
Received: by mail-ig0-f180.google.com with SMTP id g8so48138389igr.0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 06:17:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i71Ff2KS682DRP8zG76ee6rhz3X-NZKst1qsruMZKWaHJA@mail.gmail.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
	<CACj3i71Ff2KS682DRP8zG76ee6rhz3X-NZKst1qsruMZKWaHJA@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 20 Apr 2016 15:17:25 +0200
Message-ID: <CACj3i73jk5HjRuRRF7hnX0WoOv0amq-CduAwoHbhoT-=+hTREA@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8604946153965014244=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8604946153965014244==
Content-Type: multipart/alternative; boundary=047d7b451282545f700530ea6b1a

--047d7b451282545f700530ea6b1a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 11:51 AM, Jan Tulak <jtulak@redhat.com> wrote:

> On Thu, Apr 14, 2016 at 11:49 AM, Jan Tulak <jtulak@redhat.com> wrote:
>
>> On Fri, Apr 8, 2016 at 4:58 PM, Jan Tulak <jtulak@redhat.com> wrote:
>>
>>> On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen <sandeen@sandeen.net>
>>> wrote:
>>>
>> [
>>>> =E2=80=8Bsnip]=E2=80=8B
>>>>
>>>> I still think this patch might need a reset though :)
>>>>
>>>> Thanks,
>>>> -Eric
>>>>
>>>>
>>> =E2=80=8BOn few places, the original patch looked as if files had direc=
t IO
>>> still enabled=E2=80=8B (using platform_findsize...), and I think it was=
 causing
>>> some failures - fixing issues is why I did most of the changes.
>>>
>>> I will revert to the original version and see what exactly fails. But
>>> with being Friday late afternoon, the results will be available the nex=
t
>>> week (Wednesday and further, all my courses at university are stuffed i=
n
>>> Mon/Tue).
>>>
>>>
>> =E2=80=8BAll right. So I run the tests on the set with both this and the=
 original
>> version of this patch and there is no change in results. Here and there
>> some tests failed on one run, but on other runs they are ok and I can't =
get
>> them to fail again (namely, xfs/033, 073 and 085 did this).
>>
>> It looks like whatever the issues were to start the changes, they are
>> already resolved. Thus, I will send the original patch in the next batch=
.
>>
>>
>> =E2=80=8BI'm taking it back, one tests fails, most likely it happened wh=
en I
> removed patch 17 - xfsprogs: disable truncating of files.
> If I do "mkfs.xfs $file", it doesn't know the old size to recreate it. I'=
m
> working on a change for this patch to fix this issue, but I'm not entirel=
y
> certain how to proceed. The right place to get the size seems to be
> get_topology(). I could save it into xi.dsize, but then libxfs_init()
> zeroes it.
>
> So I think that I might rather convert the measured size do char *dsize
> and pretend that it is an user-given value. But this looks to me more lik=
e
> a hack. On the other side, any other way would require further changes in
> the code to convert the char* to int as soon as possible - which does not
> belong to this patch...
>
> Diff of the change:
>
> @@ -999,7 +999,7 @@ static void get_topology(
>
>                 fd =3D open(dfile, flags, 0666);
>                 if (fd >=3D 0) {
> -                       platform_findsizes(dfile, fd, &dummy,
> &ft->lsectorsize);
> +                       platform_findsizes(dfile, fd, &xi->dsize,
> &ft->lsectorsize);
>                         close(fd);
>                         ft->psectorsize =3D ft->lsectorsize;
>                 } else
> @@ -2273,6 +2273,18 @@ _("Minimum block size for CRC enabled filesystems
> is %d bytes.\n"),
>         memset(&ft, 0, sizeof(ft));
>         get_topology(&xi, &ft, force_overwrite);
>
> +       /*
> +        * If it is an existing file and we have no info about it
> +        * like in case of "mkfs.xfs some-file", we need to save the size
> +        * of the file to somewhere where it can be read later.
> +        */
> +       if (xi.disfile && !xi.dcreat && xi.dsize) {
> +               long long num =3D xi.dsize * ft.lsectorsize;
> +               int length =3D snprintf(NULL, 0,"%lld", num);
> +               dsize =3D calloc( length + 1 ,sizeof(char));
> +               sprintf(dsize, "%lld", num);
> +       }
> +
>         if (!ssflag) {
>                 /*
>                  * Unless specified manually on the command line use the
>
> So, what do you think about this?
>
> =E2=80=8B
And before anyone will reply, I found that putting a platform_findsizes=E2=
=80=8B
into libxfs_init will fix it too. Which is nice, especially because for
block devices, the findsizes is already used there. So ignore the previous
hack. :-)

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7b451282545f700530ea6b1a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 20, 2016 at 11:51 AM, Jan Tulak </span><span dir=3D"ltr" style=3D"font-fa=
mily:arial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_=
blank">jtulak@redhat.com</a>&gt;</span><span style=3D"font-family:arial,san=
s-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div class=3D"g=
mail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><span class=3D"=
"><div style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"font=
-family:arial,sans-serif">On Thu, Apr 14, 2016 at 11:49 AM, Jan Tulak </spa=
n><span dir=3D"ltr" style=3D"font-family:arial,sans-serif">&lt;<a href=3D"m=
ailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>&gt;</span>=
<span style=3D"font-family:arial,sans-serif"> wrote:</span><br></div></span=
><div class=3D"gmail_extra"><div class=3D"gmail_quote"><span class=3D""><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padd=
ing-left:1ex"><div dir=3D"ltr"><span><div style=3D"font-family:arial,helvet=
ica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Apr 8,=
 2016 at 4:58 PM, Jan Tulak </span><span dir=3D"ltr" style=3D"font-family:a=
rial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_blank"=
>jtulak@redhat.com</a>&gt;</span><span style=3D"font-family:arial,sans-seri=
f"> wrote:</span><br></div></span><div class=3D"gmail_extra"><div class=3D"=
gmail_quote"><span><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div style=
=3D"font-family:arial,helvetica,sans-serif"><span style=3D"font-family:aria=
l,sans-serif">On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen </span><span dir=
=3D"ltr" style=3D"font-family:arial,sans-serif">&lt;<a href=3D"mailto:sande=
en@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span s=
tyle=3D"font-family:arial,sans-serif"> wrote:</span><span style=3D"font-fam=
ily:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span><span style=3D"font-=
family:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span></div></div></div=
></div></blockquote></span><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204=
);border-left-style:solid;padding-left:1ex"><div dir=3D"ltr"><div class=3D"=
gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rg=
b(204,204,204);border-left-style:solid;padding-left:1ex"><div><div><span>[<=
div style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=
=8Bsnip]=E2=80=8B</div><span><br style=3D"color:rgb(34,34,34)"><span style=
=3D"color:rgb(34,34,34)">I still think this patch might need a reset though=
 :)</span><br style=3D"color:rgb(34,34,34)"><br style=3D"color:rgb(34,34,34=
)"><span style=3D"color:rgb(34,34,34)">Thanks,</span><br style=3D"color:rgb=
(34,34,34)"><span style=3D"color:rgb(34,34,34)">-Eric</span><br style=3D"co=
lor:rgb(34,34,34)"></span></span><span style=3D"color:rgb(34,34,34)"><span>=
<br></span></span></div></div></blockquote><div><br></div><span><div style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BOn few places, the ori=
ginal patch looked as if files had direct IO still enabled=E2=80=8B (using =
platform_findsize...), and I think it was causing some failures - fixing is=
sues is why I did most of the changes.</div><div style=3D"font-family:arial=
,helvetica,sans-serif"><br></div><div style=3D"font-family:arial,helvetica,=
sans-serif">I will revert to the original version and see what exactly fail=
s. But with being Friday late afternoon, the results will be available the =
next week (Wednesday and further, all my courses at university are stuffed =
in Mon/Tue).</div><div style=3D"font-family:arial,helvetica,sans-serif"><br=
></div></span></div></div></div></blockquote><div><br></div><div><div style=
=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BAll rig=
ht. So I run the tests on the set with both this and the original version o=
f this patch and there is no change in results. Here and there some tests f=
ailed on one run, but on other runs they are ok and I can&#39;t get them to=
 fail again (namely, xfs/033, 073 and 085 did this).</div></div><div><div s=
tyle=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div></=
div><div><div style=3D"font-family:arial,helvetica,sans-serif;display:inlin=
e">It looks like whatever the issues were to start the changes, they are al=
ready resolved. Thus, I will send the original patch in the next batch.</di=
v><br></div><div><br></div></div></div></div></blockquote></span><div style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BI&#39;m taking it back=
, one tests fails, most likely it happened when I removed patch 17 - xfspro=
gs: disable truncating of files.</div><div style=3D"font-family:arial,helve=
tica,sans-serif">If I do &quot;mkfs.xfs $file&quot;, it doesn&#39;t know th=
e old size to recreate it. I&#39;m working on a change for this patch to fi=
x this issue, but I&#39;m not entirely certain how to proceed. The right pl=
ace to get the size seems to be get_topology(). I could save it into xi.dsi=
ze, but then=C2=A0libxfs_init() zeroes it.</div><div style=3D"font-family:a=
rial,helvetica,sans-serif"><br></div><div style=3D"font-family:arial,helvet=
ica,sans-serif">So I think that I might rather convert the measured size do=
 char *dsize and pretend that it is an user-given value. But this looks to =
me more like a hack. On the other side, any other way would require further=
 changes in the code to convert the char* to int as soon as possible - whic=
h does not belong to this patch...</div><div style=3D"font-family:arial,hel=
vetica,sans-serif"><br></div><div style=3D"font-family:arial,helvetica,sans=
-serif">Diff of the change:</div><div style=3D"font-family:arial,helvetica,=
sans-serif"><br></div><div><div><div><font face=3D"arial, helvetica, sans-s=
erif">@@ -999,7 +999,7 @@ static void get_topology(</font></div><span class=
=3D""><div><font face=3D"arial, helvetica, sans-serif"><br></font></div><di=
v><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D open(dfile, flags, 0666);</font></div></=
span><span class=3D""><div><font face=3D"arial, helvetica, sans-serif">=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fd &gt;=3D 0) {</f=
ont></div><div><font face=3D"arial, helvetica, sans-serif">- =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 platform_fin=
dsizes(dfile, fd, &amp;dummy, &amp;ft-&gt;lsectorsize);</font></div></span>=
<div><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 platform_findsizes(dfi=
le, fd, &amp;xi-&gt;dsize, &amp;ft-&gt;lsectorsize);</font></div><div><font=
 face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(fd);</font></div><sp=
an class=3D""><div><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 f=
t-&gt;psectorsize =3D ft-&gt;lsectorsize;</font></div></span><div><font fac=
e=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 } else</font></div><div><font face=3D"arial, helvetica, s=
ans-serif">@@ -2273,6 +2273,18 @@ _(&quot;Minimum block size for CRC enable=
d filesystems is %d bytes.\n&quot;),</font></div><span class=3D""><div><fon=
t face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(=
&amp;ft, 0, sizeof(ft));</font></div><div><font face=3D"arial, helvetica, s=
ans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 get_topology(&amp;xi, &amp;ft, force=
_overwrite);</font></div><div><font face=3D"arial, helvetica, sans-serif"><=
br></font></div></span><div><font face=3D"arial, helvetica, sans-serif">+ =
=C2=A0 =C2=A0 =C2=A0 /*</font></div><div><font face=3D"arial, helvetica, sa=
ns-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* If it is an existing file and we h=
ave no info about it</font></div><div><font face=3D"arial, helvetica, sans-=
serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* like in case of &quot;mkfs.xfs some-f=
ile&quot;, we need to save the size</font></div><div><font face=3D"arial, h=
elvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* of the file to somewhe=
re where it can be read later.</font></div><div><font face=3D"arial, helvet=
ica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0*/</font></div><div><font fac=
e=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 if (xi.disfile &a=
mp;&amp; !xi.dcreat &amp;&amp; xi.dsize) {</font></div><div><font face=3D"a=
rial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 long long num =3D xi.dsize * ft.lsectorsize;</font></div><div><font =
face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 int length =3D snprintf(NULL, 0,&quot;%lld&quot;, num);</font=
></div><div><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dsize =3D calloc( length + 1 ,sizeof(char))=
;</font></div><div><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(dsize, &quot;%lld&quot;, num=
);</font></div><div><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =
=C2=A0 =C2=A0 }</font></div><div><font face=3D"arial, helvetica, sans-serif=
">+</font></div><div><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 if (!ssflag) {</font></div><div><font face=3D"arial, helv=
etica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
/*</font></div><div><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Unless specified manu=
ally on the command line use the</font></div><div><font face=3D"arial, helv=
etica, sans-serif"><br></font></div><div><font face=3D"arial, helvetica, sa=
ns-serif">So, what do you think about this?</font></div><div><br></div></di=
v></div></div></div></div></blockquote></div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif">=E2=80=8B</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">And bef=
ore anyone will reply, I found that putting a platform_findsizes=E2=80=8B i=
nto libxfs_init will fix it too. Which is nice, especially because for bloc=
k devices, the findsizes is already used there. So ignore the previous hack=
. :-)</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:a=
rial,helvetica,sans-serif">Cheers,</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">Jan</div><br clear=3D"all"><div=
><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div=
 dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" t=
arget=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.m=
e" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--047d7b451282545f700530ea6b1a--


--===============8604946153965014244==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8604946153965014244==--
