Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 229487CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 04:51:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7D4AAC003
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 02:51:28 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	HJVF1wTu2jFr4DgY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2016 02:51:27 -0700 (PDT)
Received: by mail-ig0-f176.google.com with SMTP id f1so123590657igr.1
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 02:51:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 20 Apr 2016 11:51:06 +0200
Message-ID: <CACj3i71Ff2KS682DRP8zG76ee6rhz3X-NZKst1qsruMZKWaHJA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5035789896943987481=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============5035789896943987481==
Content-Type: multipart/alternative; boundary=089e01538da0833bcd0530e789d4

--089e01538da0833bcd0530e789d4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 14, 2016 at 11:49 AM, Jan Tulak <jtulak@redhat.com> wrote:

> On Fri, Apr 8, 2016 at 4:58 PM, Jan Tulak <jtulak@redhat.com> wrote:
>
>> On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen <sandeen@sandeen.net> wrote=
:
>>
>>
> [
>>> =E2=80=8Bsnip]=E2=80=8B
>>>
>>> I still think this patch might need a reset though :)
>>>
>>> Thanks,
>>> -Eric
>>>
>>>
>> =E2=80=8BOn few places, the original patch looked as if files had direct=
 IO still
>> enabled=E2=80=8B (using platform_findsize...), and I think it was causin=
g some
>> failures - fixing issues is why I did most of the changes.
>>
>> I will revert to the original version and see what exactly fails. But
>> with being Friday late afternoon, the results will be available the next
>> week (Wednesday and further, all my courses at university are stuffed in
>> Mon/Tue).
>>
>>
> =E2=80=8BAll right. So I run the tests on the set with both this and the =
original
> version of this patch and there is no change in results. Here and there
> some tests failed on one run, but on other runs they are ok and I can't g=
et
> them to fail again (namely, xfs/033, 073 and 085 did this).
>
> It looks like whatever the issues were to start the changes, they are
> already resolved. Thus, I will send the original patch in the next batch.
>
>
> =E2=80=8BI'm taking it back, one tests fails, most likely it happened whe=
n I
removed patch 17 - xfsprogs: disable truncating of files.
If I do "mkfs.xfs $file", it doesn't know the old size to recreate it. I'm
working on a change for this patch to fix this issue, but I'm not entirely
certain how to proceed. The right place to get the size seems to be
get_topology(). I could save it into xi.dsize, but then libxfs_init()
zeroes it.

So I think that I might rather convert the measured size do char *dsize and
pretend that it is an user-given value. But this looks to me more like a
hack. On the other side, any other way would require further changes in the
code to convert the char* to int as soon as possible - which does not
belong to this patch...

Diff of the change:

@@ -999,7 +999,7 @@ static void get_topology(

                fd =3D open(dfile, flags, 0666);
                if (fd >=3D 0) {
-                       platform_findsizes(dfile, fd, &dummy,
&ft->lsectorsize);
+                       platform_findsizes(dfile, fd, &xi->dsize,
&ft->lsectorsize);
                        close(fd);
                        ft->psectorsize =3D ft->lsectorsize;
                } else
@@ -2273,6 +2273,18 @@ _("Minimum block size for CRC enabled filesystems is
%d bytes.\n"),
        memset(&ft, 0, sizeof(ft));
        get_topology(&xi, &ft, force_overwrite);

+       /*
+        * If it is an existing file and we have no info about it
+        * like in case of "mkfs.xfs some-file", we need to save the size
+        * of the file to somewhere where it can be read later.
+        */
+       if (xi.disfile && !xi.dcreat && xi.dsize) {
+               long long num =3D xi.dsize * ft.lsectorsize;
+               int length =3D snprintf(NULL, 0,"%lld", num);
+               dsize =3D calloc( length + 1 ,sizeof(char));
+               sprintf(dsize, "%lld", num);
+       }
+
        if (!ssflag) {
                /*
                 * Unless specified manually on the command line use the

So, what do you think about this?

Thanks,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01538da0833bcd0530e789d4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 14, 2016 at 11:49 AM, Jan Tulak </span><span dir=3D"ltr" style=3D"font-fa=
mily:arial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_=
blank">jtulak@redhat.com</a>&gt;</span><span style=3D"font-family:arial,san=
s-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div class=3D"g=
mail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-s=
tyle:solid;padding-left:1ex"><div dir=3D"ltr"><span><div style=3D"font-fami=
ly:arial,helvetica,sans-serif"><span style=3D"font-family:arial,sans-serif"=
>On Fri, Apr 8, 2016 at 4:58 PM, Jan Tulak </span><span dir=3D"ltr" style=
=3D"font-family:arial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" =
target=3D"_blank">jtulak@redhat.com</a>&gt;</span><span style=3D"font-famil=
y:arial,sans-serif"> wrote:</span><br></div></span><div class=3D"gmail_extr=
a"><div class=3D"gmail_quote"><span><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><div dir=3D"ltr"><div>=
<div><div style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"f=
ont-family:arial,sans-serif">On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen <=
/span><span dir=3D"ltr" style=3D"font-family:arial,sans-serif">&lt;<a href=
=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&g=
t;</span><span style=3D"font-family:arial,sans-serif"> wrote:</span><span s=
tyle=3D"font-family:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span><spa=
n style=3D"font-family:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span><=
/div></div></div></div></blockquote></span><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color=
:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div dir=3D"ltr=
"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">=
<div><div><span>[<div style=3D"font-family:arial,helvetica,sans-serif;displ=
ay:inline">=E2=80=8Bsnip]=E2=80=8B</div><span><br style=3D"color:rgb(34,34,=
34)"><span style=3D"color:rgb(34,34,34)">I still think this patch might nee=
d a reset though :)</span><br style=3D"color:rgb(34,34,34)"><br style=3D"co=
lor:rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)">Thanks,</span><br st=
yle=3D"color:rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)">-Eric</span=
><br style=3D"color:rgb(34,34,34)"></span></span><span style=3D"color:rgb(3=
4,34,34)"><span><br></span></span></div></div></blockquote><div><br></div><=
span><div style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BOn few =
places, the original patch looked as if files had direct IO still enabled=
=E2=80=8B (using platform_findsize...), and I think it was causing some fai=
lures - fixing issues is why I did most of the changes.</div><div style=3D"=
font-family:arial,helvetica,sans-serif"><br></div><div style=3D"font-family=
:arial,helvetica,sans-serif">I will revert to the original version and see =
what exactly fails. But with being Friday late afternoon, the results will =
be available the next week (Wednesday and further, all my courses at univer=
sity are stuffed in Mon/Tue).</div><div style=3D"font-family:arial,helvetic=
a,sans-serif"><br></div></span></div></div></div></blockquote><div><br></di=
v><div><div style=3D"font-family:arial,helvetica,sans-serif;display:inline"=
>=E2=80=8BAll right. So I run the tests on the set with both this and the o=
riginal version of this patch and there is no change in results. Here and t=
here some tests failed on one run, but on other runs they are ok and I can&=
#39;t get them to fail again (namely, xfs/033, 073 and 085 did this).</div>=
</div><div><div style=3D"font-family:arial,helvetica,sans-serif;display:inl=
ine"><br></div></div><div><div style=3D"font-family:arial,helvetica,sans-se=
rif;display:inline">It looks like whatever the issues were to start the cha=
nges, they are already resolved. Thus, I will send the original patch in th=
e next batch.</div><br></div><div><br></div></div></div></div></blockquote>=
<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-seri=
f">=E2=80=8BI&#39;m taking it back, one tests fails, most likely it happene=
d when I removed patch 17 - xfsprogs: disable truncating of files.</div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
If I do &quot;mkfs.xfs $file&quot;, it doesn&#39;t know the old size to rec=
reate it. I&#39;m working on a change for this patch to fix this issue, but=
 I&#39;m not entirely certain how to proceed. The right place to get the si=
ze seems to be get_topology(). I could save it into xi.dsize, but then=C2=
=A0libxfs_init() zeroes it.</div><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif">So I think that I might ra=
ther convert the measured size do char *dsize and pretend that it is an use=
r-given value. But this looks to me more like a hack. On the other side, an=
y other way would require further changes in the code to convert the char* =
to int as soon as possible - which does not belong to this patch...</div><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"=
><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif">Diff of the change:</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D""><div class=3D"gmail_default" style=3D""><div class=3D"gm=
ail_default"><font face=3D"arial, helvetica, sans-serif">@@ -999,7 +999,7 @=
@ static void get_topology(</font></div><div class=3D"gmail_default"><font =
face=3D"arial, helvetica, sans-serif"><br></font></div><div class=3D"gmail_=
default"><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D open(dfile, flags, 0666);</font><=
/div><div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-seri=
f">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fd &gt;=3D 0=
) {</font></div><div class=3D"gmail_default"><font face=3D"arial, helvetica=
, sans-serif">- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 platform_findsizes(dfile, fd, &amp;dummy, &amp;ft-&gt;lse=
ctorsize);</font></div><div class=3D"gmail_default"><font face=3D"arial, he=
lvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 platform_findsizes(dfile, fd, &amp;xi-&gt;dsize, &=
amp;ft-&gt;lsectorsize);</font></div><div class=3D"gmail_default"><font fac=
e=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(fd);</font></div><div c=
lass=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ft-&gt;psectorsize =3D ft-&gt;lsectorsize;</font></div><div class=3D"gm=
ail_default"><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else</font></div><div class=3D"gma=
il_default"><font face=3D"arial, helvetica, sans-serif">@@ -2273,6 +2273,18=
 @@ _(&quot;Minimum block size for CRC enabled filesystems is %d bytes.\n&q=
uot;),</font></div><div class=3D"gmail_default"><font face=3D"arial, helvet=
ica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;ft, 0, sizeof(ft))=
;</font></div><div class=3D"gmail_default"><font face=3D"arial, helvetica, =
sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 get_topology(&amp;xi, &amp;ft, forc=
e_overwrite);</font></div><div class=3D"gmail_default"><font face=3D"arial,=
 helvetica, sans-serif"><br></font></div><div class=3D"gmail_default"><font=
 face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 /*</font></di=
v><div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">=
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* If it is an existing file and we have no inf=
o about it</font></div><div class=3D"gmail_default"><font face=3D"arial, he=
lvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* like in case of &quot;m=
kfs.xfs some-file&quot;, we need to save the size</font></div><div class=3D=
"gmail_default"><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* of the file to somewhere where it can be read later.</font>=
</div><div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-ser=
if">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0*/</font></div><div class=3D"gmail_default=
"><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 if (xi=
.disfile &amp;&amp; !xi.dcreat &amp;&amp; xi.dsize) {</font></div><div clas=
s=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 long long num =3D xi.dsize * ft.l=
sectorsize;</font></div><div class=3D"gmail_default"><font face=3D"arial, h=
elvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in=
t length =3D snprintf(NULL, 0,&quot;%lld&quot;, num);</font></div><div clas=
s=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dsize =3D calloc( length + 1 ,siz=
eof(char));</font></div><div class=3D"gmail_default"><font face=3D"arial, h=
elvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sp=
rintf(dsize, &quot;%lld&quot;, num);</font></div><div class=3D"gmail_defaul=
t"><font face=3D"arial, helvetica, sans-serif">+ =C2=A0 =C2=A0 =C2=A0 }</fo=
nt></div><div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-=
serif">+</font></div><div class=3D"gmail_default"><font face=3D"arial, helv=
etica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ssflag) {</font></div><=
div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*</font></div><div cl=
ass=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Unless specified m=
anually on the command line use the</font></div><div class=3D"gmail_default=
"><font face=3D"arial, helvetica, sans-serif"><br></font></div><div class=
=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">So, what do =
you think about this?</font></div><div class=3D"gmail_default"><font face=
=3D"arial, helvetica, sans-serif"><br></font></div><div class=3D"gmail_defa=
ult"><font face=3D"arial, helvetica, sans-serif">Thanks,</font></div><div c=
lass=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">Jan</fon=
t></div><div class=3D"gmail_default"><font face=3D"arial, helvetica, sans-s=
erif"><br></font></div></div></div></div>-- <br><div><div dir=3D"ltr"><div>=
<div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.co=
m" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tul=
ak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01538da0833bcd0530e789d4--


--===============5035789896943987481==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5035789896943987481==--
