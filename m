Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B5777CA0
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2016 02:46:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21B608F8033
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2016 00:46:53 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	5Kgq0TESbwF3PvB7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Apr 2016 00:46:49 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id u185so111069064iod.3
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2016 00:46:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57193483.8000700@sandeen.net>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-16-git-send-email-jtulak@redhat.com>
	<CACj3i73aW53YyEsZERZnSWHJ3y9cW85sA15KdoesCbx9wKsbPg@mail.gmail.com>
	<57193483.8000700@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 22 Apr 2016 09:46:29 +0200
Message-ID: <CACj3i72t8Ed3Mv3wBMCr_K_GQabKNmoQQRyW8Pz7Es6WNj09ng@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6973141819828140211=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6973141819828140211==
Content-Type: multipart/alternative; boundary=001a113ecdbe8410de05310e07f3

--001a113ecdbe8410de05310e07f3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2016 at 10:13 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> On 4/21/16 8:43 AM, Jan Tulak wrote:
> > On Thu, Apr 21, 2016 at 11:39 AM, Jan Tulak <jtulak@redhat.com <mailto:
> jtulak@redhat.com>>wrote:
> >
> >     From: Dave Chinner <dchinner@redhat.com <mailto:dchinner@redhat.com
> >>
> >
> >     THIS PATCH HAS KNOWN ISSUES - it fails xfs/206 and xfs/216 tests, a=
s
> it
> >     shrinks a file instead just not using it entirely, when -d size is
> used.
> >
> >
> > =E2=80=8BSo the shrinking is happening here:
> > 3127        /*
> > 3128         * If the data area is a file, then grow it out to its fina=
l
> size
> > 3129         * so that the reads for the end of the device in the mount
> code
> > 3130         * will succeed.
> > 3131         */
> > 3132        if (xi.disfile && ftruncate64(xi.dfd, dblocks * blocksize) =
<
> 0) {=E2=80=8B
> >
> >
> > Before the patch, xi.disfile was 0 and so it didn't shrink the file
> > to the size of the new FS. Now, what is the correct solve to this?
> > Tests are written for the old behaviour, but this shrinking seems to
> > be an intentional thing. It seems that the FS works ok even when this
> > truncating is not applied, so I think that I should remove this chunk
> > (or change it to xi.dcreate=3D1 only), and keep the old behaviour.
> >
> > What do you think about it, guys?
>
> Can't remove it; that would break the other side of things, if you try
> to mkfs.xfs -d size=3D2g on an existing 1g file... mount tries to do
> IO to the last block, and if it's not truncated out, that will fail
> (as the comment says).
>
> I suppose the simple way to fix it is to only truncate up, never down.
>
> i.e. truncate to max(dblocks * blocksize, st_size) or
> if (xi.disfile && st_size <  dblocks * blocksize) { truncate ... }
>

All right, it seems that I should have read the man page, and not just
 look on the first sentence or two... <emoticon of me hitting a wall with
my head repeatedly>.

Now it works, thanks.

Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ecdbe8410de05310e07f3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 21, 2016 at 10:13 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font=
-family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><br>
<br>
On 4/21/16 8:43 AM, Jan Tulak wrote:<br>
&gt; On Thu, Apr 21, 2016 at 11:39 AM, Jan Tulak &lt;<a href=3D"mailto:jtul=
ak@redhat.com">jtulak@redhat.com</a> &lt;mailto:<a href=3D"mailto:jtulak@re=
dhat.com">jtulak@redhat.com</a>&gt;&gt;wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0From: Dave Chinner &lt;<a href=3D"mailto:dchinner@r=
edhat.com">dchinner@redhat.com</a> &lt;mailto:<a href=3D"mailto:dchinner@re=
dhat.com">dchinner@redhat.com</a>&gt;&gt;<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0THIS PATCH HAS KNOWN ISSUES - it fails xfs/206 and =
xfs/216 tests, as it<br>
&gt;=C2=A0 =C2=A0 =C2=A0shrinks a file instead just not using it entirely, =
when -d size is used.<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BSo the shrinking is happening here:<br>
&gt; 3127=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
&gt; 3128=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the data area is a file, th=
en grow it out to its final size<br>
&gt; 3129=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* so that the reads for the end =
of the device in the mount code<br>
&gt; 3130=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* will succeed.<br>
&gt; 3131=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; 3132=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (xi.disfile &amp;&amp; ftruncate64(=
xi.dfd, dblocks * blocksize) &lt; 0) {=E2=80=8B<br>
&gt;<br>
&gt;<br>
&gt; Before the patch, xi.disfile was 0 and so it didn&#39;t shrink the fil=
e<br>
&gt; to the size of the new FS. Now, what is the correct solve to this?<br>
&gt; Tests are written for the old behaviour, but this shrinking seems to<b=
r>
&gt; be an intentional thing. It seems that the FS works ok even when this<=
br>
&gt; truncating is not applied, so I think that I should remove this chunk<=
br>
&gt; (or change it to xi.dcreate=3D1 only), and keep the old behaviour.<br>
&gt;<br>
&gt; What do you think about it, guys?<br>
<br>
</span>Can&#39;t remove it; that would break the other side of things, if y=
ou try<br>
to mkfs.xfs -d size=3D2g on an existing 1g file... mount tries to do<br>
IO to the last block, and if it&#39;s not truncated out, that will fail<br>
(as the comment says).<br>
<br>
I suppose the simple way to fix it is to only truncate up, never down.<br>
<br>
i.e. truncate to max(dblocks * blocksize, st_size) or<br>
if (xi.disfile &amp;&amp; st_size &lt;=C2=A0 dblocks * blocksize) { truncat=
e ... }<br></blockquote><div><br></div><div><div class=3D"gmail_default" st=
yle=3D"font-family:arial,helvetica,sans-serif">All right, it seems that I s=
hould have read the man page, and not just =C2=A0look on the first sentence=
 or two... &lt;emoticon of me hitting a wall with my head repeatedly&gt;.=
=C2=A0</div><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif">Now it works, thanks.</div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan<=
/div><br></div><div>=C2=A0</div></div>-- <br><div class=3D"gmail_signature"=
><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"=
mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a=
 href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div=
></div></div>
</div></div>

--001a113ecdbe8410de05310e07f3--


--===============6973141819828140211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6973141819828140211==--
