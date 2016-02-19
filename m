Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4221C7CA3
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 10:16:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 275DA304039
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 08:16:49 -0800 (PST)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	3uyIMNDRn7ddkvSz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 08:16:47 -0800 (PST)
Received: by mail-io0-f176.google.com with SMTP id g203so114277800iof.2
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 08:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160219154347.GA27263@bfoster.bfoster>
References: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
	<20160219154347.GA27263@bfoster.bfoster>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 19 Feb 2016 17:16:28 +0100
Message-ID: <CACj3i72wijiApA0gD0mRrMvPomDC5pEAr1Mvv6e3vi4HU1S_sw@mail.gmail.com>
Subject: Re: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3845294711760575919=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============3845294711760575919==
Content-Type: multipart/alternative; boundary=001a114157c6539612052c21cf27

--001a114157c6539612052c21cf27
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 19, 2016 at 4:43 PM, Brian Foster <bfoster@redhat.com> wrote:

> On Fri, Feb 19, 2016 at 02:34:52PM +0100, Jan Tulak wrote:
> > Hi guys,
> >
> > what is the meaning of XLOG_MIN_RECORD_BSIZE in libxfs/xfs_log_format.h=
?
> > It is not used anywhere. I thought it might be related to -l su/sunit
> > option, but seeing tests with -l su=3D4096 (the macro is set to 16k), i=
t
> > looks more like a forgotten value.
> >
>
> It's the minimum log buffer size allowed in the kernel. It's used in
> xfs_super.c at mount time to validate the logbsize option:
>
>         if (mp->m_logbsize !=3D -1 &&
>             mp->m_logbsize !=3D  0 &&
>             (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
>              mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
>              !is_power_of_2(mp->m_logbsize))) {
>                 xfs_warn(mp,
>                         "invalid logbufsize: %d [not 16k,32k,64k,128k or
> 256k]",
>                         mp->m_logbsize);
>                 return -EINVAL;
>         }
>
> I suspect it's not relevant in userspace.
>

This is ok, then. Thank you for pointing me to kernel space, I didn't
realised I should check it there too. :-)
=E2=80=8B


>
> > There is no check for a minimal value, so I can do -l su=3D1 (or su=3D0=
). Are
> > there some caveat=E2=80=8Bs (other than performance) with such a small =
value? Can
> > it be that we are missing a check? Because
> > XLOG_BIG_RECORD_BSIZE
> > =E2=80=8B and XLOG_MAX_RECORD_BSIZE are used and the upper bound is lim=
ited.=E2=80=8B..
> >
>
> On a quick test, it looks like mkfs just ignores certain log stripe unit
> values that aren't block aligned. I'd probably expect this to behave
> similar to the '-d su' option and complain about invalid input..?
>

=E2=80=8BSounds logical and like what I expected and didn't found. I will s=
end a
patch adding this check... the only question is, what should be the minimal
value? Should I check it against block size and forbid smaller sizes?
Aligning a stripe unit with length 1024 on 4096 blocks doesn't looks like a
nice thing. :-)
(And on a quick check, it seems that -d su is doing just that.)

Thanks,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a114157c6539612052c21cf27
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Fe=
b 19, 2016 at 4:43 PM, Brian Foster </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:bfoster@redhat.com" target=
=3D"_blank">bfoster@redhat.com</a>&gt;</span><span style=3D"font-family:ari=
al,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div clas=
s=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex"><span>On Fri, Feb 19, 2016=
 at 02:34:52PM +0100, Jan Tulak wrote:<br>
&gt; Hi guys,<br>
&gt;<br>
&gt; what is the meaning of XLOG_MIN_RECORD_BSIZE in libxfs/xfs_log_format.=
h?<br>
&gt; It is not used anywhere. I thought it might be related to -l su/sunit<=
br>
&gt; option, but seeing tests with -l su=3D4096 (the macro is set to 16k), =
it<br>
&gt; looks more like a forgotten value.<br>
&gt;<br>
<br>
</span>It&#39;s the minimum log buffer size allowed in the kernel. It&#39;s=
 used in<br>
xfs_super.c at mount time to validate the logbsize option:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;m_logbsize !=3D -1 &amp;&amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;m_logbsize !=3D=C2=A0 0 &a=
mp;&amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mp-&gt;m_logbsize &lt; XLOG_MIN_=
RECORD_BSIZE ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;m_logbsize &gt; XLOG=
_MAX_RECORD_BSIZE ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!is_power_of_2(mp-&gt;m_log=
bsize))) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_warn(mp,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &quot;invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]&quot=
;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mp-&gt;m_logbsize);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
I suspect it&#39;s not relevant in userspace.<br></blockquote><div><br></di=
v><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline">This is ok, then. Thank you for pointing me to ker=
nel space, I didn&#39;t realised I should check it there too. :-)</div></di=
v><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline">=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">
<span><br>
&gt; There is no check for a minimal value, so I can do -l su=3D1 (or su=3D=
0). Are<br>
&gt; there some caveat=E2=80=8Bs (other than performance) with such a small=
 value? Can<br>
&gt; it be that we are missing a check? Because<br>
&gt; XLOG_BIG_RECORD_BSIZE<br>
&gt; =E2=80=8B and XLOG_MAX_RECORD_BSIZE are used and the upper bound is li=
mited.=E2=80=8B..<br>
&gt;<br>
<br>
</span>On a quick test, it looks like mkfs just ignores certain log stripe =
unit<br>
values that aren&#39;t block aligned. I&#39;d probably expect this to behav=
e<br>
similar to the &#39;-d su&#39; option and complain about invalid input..?<b=
r></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BSounds logica=
l and like what I expected and didn&#39;t found. I will send a patch adding=
 this check... the only question is, what should be the minimal value? Shou=
ld I check it against block size and forbid smaller sizes? Aligning a strip=
e unit with length 1024 on 4096 blocks doesn&#39;t looks like a nice thing.=
 :-)</div></div><div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif;display:inline">(And on a quick check, it seems that=
 -d su is doing just that.)</div></div><div><div class=3D"gmail_default" st=
yle=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div></d=
iv><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif;display:inline">Thanks,</div></div><div><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif;display:inline">Jan</di=
v></div></div><div><br></div>-- <br><div><div dir=3D"ltr"><div><div dir=3D"=
ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D=
"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" targe=
t=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a114157c6539612052c21cf27--


--===============3845294711760575919==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3845294711760575919==--
