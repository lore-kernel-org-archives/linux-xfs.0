Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E49A37F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 05:54:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DF33AC013
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 03:54:29 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	xxYpqohKJ0H10pGm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 03:54:27 -0700 (PDT)
Received: by iofh134 with SMTP id h134so15265568iof.0
	for <xfs@oss.sgi.com>; Wed, 02 Sep 2015 03:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150831190005.GJ349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-8-git-send-email-jtulak@redhat.com>
	<20150831190005.GJ349@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 2 Sep 2015 12:54:06 +0200
Message-ID: <CACj3i71rAFFsbX2UgAv_SNfTW9Q_LacHaiAT9QqkbDbFyVZRcA@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfsprogs: Add a timer implementation for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6422592587430492800=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6422592587430492800==
Content-Type: multipart/alternative; boundary=001a1141bd887b8d9f051ec17d71

--001a1141bd887b8d9f051ec17d71
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2015 at 9:00 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Wed, Aug 26, 2015 at 02:02:32PM +0200, Jan Tulak wrote:
> > OS X does not have the timer used in xfs_repair.
> > Add a simple implementation providing the required
> > capabilities.
>
> This doesn't look like it would actually work.
>

=E2=80=8BAs I understand the timer usage, it should periodically send a sig=
nal. The
timer code I posted really does this, at least when I take the timer_*
functions "as it is" outside and test them, calling them in the same order
as in the repair code. I tested that before sending the patch.

I have to try it in xfs_repair yet - this is limited by having small
storage space for a filesystem, where the reporting interval would be
noticeable. The best thing for this I have now is an old USB2 8 GB flash
drive, filled with multiple copies of installed Debian. However, even on a
raspberry pi, it still runs quickly. I guess few hundreds of GB would do
it, but I need to dig out an old USB2-sata reduction somewhere and a HDD...
(And I didn't noticed any difference in output.)

So in meantime, why do you think this won't work?

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a1141bd887b8d9f051ec17d71
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Aug 31, 2015 at 9:00 PM, Christoph Hellwig <span dir=
=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@inf=
radead.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><span>On Wed, Aug 26, =
2015 at 02:02:32PM +0200, Jan Tulak wrote:<br>
&gt; OS X does not have the timer used in xfs_repair.<br>
&gt; Add a simple implementation providing the required<br>
&gt; capabilities.<br>
<br>
</span>This doesn&#39;t look like it would actually work.<br>
</blockquote></div><br><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif">=E2=80=8BAs I understand the timer usage, it shou=
ld periodically send a signal. The timer code I posted really does this, at=
 least when I take the=C2=A0<span style=3D"font-size:12.8000001907349px;fon=
t-family:arial,sans-serif">timer_* functions &quot;as it is&quot; outside a=
nd test them, calling them in the same order as in the repair code. I teste=
d that before sending the patch.</span></div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif"><span style=3D"font-size:12=
.8000001907349px;font-family:arial,sans-serif"><br></span></div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">I have =
to try it in xfs_repair yet - this is limited by having small storage space=
 for a filesystem, where the reporting interval would be noticeable. The be=
st thing for this I have now is an old USB2 8 GB flash drive, filled with m=
ultiple copies of installed Debian. However, even on a raspberry pi, it sti=
ll runs quickly. I guess few hundreds of GB would do it, but I need to dig =
out an old USB2-sata reduction somewhere and a HDD... (And I didn&#39;t not=
iced any difference in output.)</div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif"><span style=3D"font-size:12.8000001=
907349px;font-family:arial,sans-serif"><br></span></div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"f=
ont-size:12.8000001907349px;font-family:arial,sans-serif">So in meantime, w=
</span><span style=3D"font-family:arial,sans-serif;font-size:12.80000019073=
49px">hy do you think this won&#39;t work?</span></div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"fo=
nt-family:arial,sans-serif;font-size:12.8000001907349px"><br></span></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
"><span style=3D"font-family:arial,sans-serif;font-size:12.8000001907349px"=
>Cheers,</span></div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif"><span style=3D"font-family:arial,sans-serif;font-si=
ze:12.8000001907349px">Jan</span></div><div><br></div>-- <br><div><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"=
mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></=
div>
</div></div>

--001a1141bd887b8d9f051ec17d71--


--===============6422592587430492800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6422592587430492800==--
