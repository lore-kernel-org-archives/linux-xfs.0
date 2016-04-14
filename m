Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55F2E7CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 04:49:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 241A08F8035
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 02:49:36 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	SYvkWOe3DttvxrGX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 02:49:34 -0700 (PDT)
Received: by mail-ig0-f178.google.com with SMTP id kb1so1862932igb.0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 02:49:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 14 Apr 2016 11:49:14 +0200
Message-ID: <CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1515491942979797515=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============1515491942979797515==
Content-Type: multipart/alternative; boundary=089e01538da0c6a8a905306ecf8d

--089e01538da0c6a8a905306ecf8d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 8, 2016 at 4:58 PM, Jan Tulak <jtulak@redhat.com> wrote:

> On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
[
>> =E2=80=8Bsnip]=E2=80=8B
>>
>> I still think this patch might need a reset though :)
>>
>> Thanks,
>> -Eric
>>
>>
> =E2=80=8BOn few places, the original patch looked as if files had direct =
IO still
> enabled=E2=80=8B (using platform_findsize...), and I think it was causing=
 some
> failures - fixing issues is why I did most of the changes.
>
> I will revert to the original version and see what exactly fails. But wit=
h
> being Friday late afternoon, the results will be available the next week
> (Wednesday and further, all my courses at university are stuffed in
> Mon/Tue).
>
>
=E2=80=8BAll right. So I run the tests on the set with both this and the or=
iginal
version of this patch and there is no change in results. Here and there
some tests failed on one run, but on other runs they are ok and I can't get
them to fail again (namely, xfs/033, 073 and 085 did this).

It looks like whatever the issues were to start the changes, they are
already resolved. Thus, I will send the original patch in the next batch.


Cheers,
=E2=80=8BJan=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01538da0c6a8a905306ecf8d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 8, 2016 at 4:58 PM, Jan Tulak </span><span dir=3D"ltr" style=3D"font-fami=
ly:arial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_bl=
ank">jtulak@redhat.com</a>&gt;</span><span style=3D"font-family:arial,sans-=
serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div class=3D"gma=
il_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div st=
yle=3D"font-family:arial,helvetica,sans-serif"><span style=3D"font-family:a=
rial,sans-serif">On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen </span><span =
dir=3D"ltr" style=3D"font-family:arial,sans-serif">&lt;<a href=3D"mailto:sa=
ndeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><spa=
n style=3D"font-family:arial,sans-serif"> wrote:</span><span style=3D"font-=
family:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span><span style=3D"fo=
nt-family:arial,sans-serif;color:rgb(34,34,34)">=C2=A0</span></div></div></=
div></div></blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bo=
rder-left-style:solid;padding-left:1ex"><div dir=3D"ltr"><div class=3D"gmai=
l_extra"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><div><div><span>[<div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">=E2=80=8Bsnip]=E2=80=8B</div><br style=3D"color:rgb(34,34,34)"=
><span style=3D"color:rgb(34,34,34)">I still think this patch might need a =
reset though :)</span><br style=3D"color:rgb(34,34,34)"><br style=3D"color:=
rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)">Thanks,</span><br style=
=3D"color:rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)">-Eric</span><b=
r style=3D"color:rgb(34,34,34)"></span><span style=3D"color:rgb(34,34,34)">=
<span><br></span></span></div></div></blockquote><div><br></div><div style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BOn few places, the ori=
ginal patch looked as if files had direct IO still enabled=E2=80=8B (using =
platform_findsize...), and I think it was causing some failures - fixing is=
sues is why I did most of the changes.</div><div style=3D"font-family:arial=
,helvetica,sans-serif"><br></div><div style=3D"font-family:arial,helvetica,=
sans-serif">I will revert to the original version and see what exactly fail=
s. But with being Friday late afternoon, the results will be available the =
next week (Wednesday and further, all my courses at university are stuffed =
in Mon/Tue).</div><div style=3D"font-family:arial,helvetica,sans-serif"><br=
></div></div></div></div></blockquote><div><br></div><div><div class=3D"gma=
il_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline"=
>=E2=80=8BAll right. So I run the tests on the set with both this and the o=
riginal version of this patch and there is no change in results. Here and t=
here some tests failed on one run, but on other runs they are ok and I can&=
#39;t get them to fail again (namely, xfs/033, 073 and 085 did this).</div>=
</div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif;display:inline"><br></div></div><div><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif;display:inline">It look=
s like whatever the issues were to start the changes, they are already reso=
lved. Thus, I will send the original patch in the next batch.</div><br></di=
v><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline"><br></div></div><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;display:inline">Cheers,</di=
v></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif">=E2=80=8BJan=E2=80=8B</div><br></div></div><br clear=3D"all=
"><div><br></div>-- <br><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Ja=
n Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtu=
lak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank"=
>jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01538da0c6a8a905306ecf8d--


--===============1515491942979797515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1515491942979797515==--
