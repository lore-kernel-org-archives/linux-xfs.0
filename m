Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8947F29DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 10:01:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25A7CAC002
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 08:01:14 -0700 (PDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	Ucdfl72VG1b0UXZK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 08:01:12 -0700 (PDT)
Received: by mail-lb0-f175.google.com with SMTP id w20so3459772lbh.20
	for <xfs@oss.sgi.com>; Mon, 06 May 2013 08:01:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5187BF8A.2040303@sandeen.net>
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
From: Filippo Stenico <filippo.stenico@gmail.com>
Date: Mon, 6 May 2013 17:00:30 +0200
Message-ID: <CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
Subject: Re: Xfs_repair segfaults.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7692659274613718032=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============7692659274613718032==
Content-Type: multipart/alternative; boundary=001a11c33af0a1faec04dc0df824

--001a11c33af0a1faec04dc0df824
Content-Type: text/plain; charset=ISO-8859-1

On Mon, May 6, 2013 at 4:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 5/6/13 7:06 AM, Filippo Stenico wrote:
> > Hello, I've had an issue on a raid5 volume (2 disks failing at same
> > time, and buggy NAS firmware trying hard to sync then stop for I/O
> > error then retryes to sync leading (!?) to lost raid and an xfs data
> > corruption.
>
> Sooo bad storage hardware, first off \o/  :(
>
>
>
> I've recreated raid, mounted the xfs filesystem, copied about 6TB of
> > data out of 8TB, the rest of data being unreachable with "structrure
> > needs cleaning" error. Thus I tried to unmount/mount and still got
> > same error, then dumped metadata and tried various xfs_repair with
> > different options but it always reaches a same point where it always
> > segfaults.
>
> OK, what version of xfsprogs?
> If not latest usptream, please try that next.
>
> It was the one included in debian squeeze, I believe v.3.1.4
I figured segfault could be fixed in newer releases, so I added testing and
unstable sources, and tryied with those (3.1.7 and 3.1.9) but same segfault.


> If upstream still segfaults, you could provide a core and associated
> binary debug info, or (maybe) an xfs_metadump for analysis.  It sounds
> like this fs is in pretty bad shape though, so even the xfs_metadump
> might fail and/or not gather enough information.
>
> As suggested on IRC chat, I built from xfsprogs-3.1.9 source, I will
restore "original" metadata and make same steps I took first time, so that
you can get a detailed report.
Of course I will include as much as info I can (metadump - gdb backtrace on
eventual segfault).

Thanx for now,

-Eric
>
> > If someone is interested of investigating what's going on here and
> > helping me recover more data I would be happy to send in in more
> > details....
> >
> > Cheers
> >
> > -- F
> >
> >
> > _______________________________________________ xfs mailing list
> > xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> >
>
>

-- 
F

--001a11c33af0a1faec04dc0df824
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, May 6, 2013 at 4:34 PM, Eric San=
deen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D=
"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">

<div class=3D"im">On 5/6/13 7:06 AM, Filippo Stenico wrote:<br>
&gt; Hello, I&#39;ve had an issue on a raid5 volume (2 disks failing at sam=
e<br>
&gt; time, and buggy NAS firmware trying hard to sync then stop for I/O<br>
&gt; error then retryes to sync leading (!?) to lost raid and an xfs data<b=
r>
&gt; corruption.<br>
<br>
</div>Sooo bad storage hardware, first off \o/ =A0:(<br>
<div><br>=A0</div></blockquote><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D=
"im">
&gt; I&#39;ve recreated raid, mounted the xfs filesystem, copied about 6TB =
of<br>
&gt; data out of 8TB, the rest of data being unreachable with &quot;structr=
ure<br>
&gt; needs cleaning&quot; error. Thus I tried to unmount/mount and still go=
t<br>
&gt; same error, then dumped metadata and tried various xfs_repair with<br>
&gt; different options but it always reaches a same point where it always<b=
r>
&gt; segfaults.<br>
<br>
</div>OK, what version of xfsprogs?<br>
If not latest usptream, please try that next.<br>
<br></blockquote><div>It was the one included in debian squeeze, I believe =
v.3.1.4 <br>I figured segfault could be fixed in newer releases, so I added=
 testing and unstable sources, and tryied with those (3.1.7 and 3.1.9) but =
same segfault.<br>

=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">
If upstream still segfaults, you could provide a core and associated<br>
binary debug info, or (maybe) an xfs_metadump for analysis. =A0It sounds<br=
>
like this fs is in pretty bad shape though, so even the xfs_metadump<br>
might fail and/or not gather enough information.<br>
<br></blockquote><div>As suggested on IRC chat, I built from xfsprogs-3.1.9=
 source, I will restore &quot;original&quot; metadata and make same steps I=
 took first time, so that you can get a detailed report.<br>Of course I wil=
l include as much as info I can (metadump - gdb backtrace on eventual segfa=
ult).<br>

<br>Thanx for now,<br><br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
-Eric<br>
<div class=3D"im"><br>
&gt; If someone is interested of investigating what&#39;s going on here and=
<br>
&gt; helping me recover more data I would be happy to send in in more<br>
&gt; details....<br>
&gt;<br>
&gt; Cheers<br>
&gt;<br>
&gt; -- F<br>
&gt;<br>
&gt;<br>
</div>&gt; _______________________________________________ xfs mailing list=
<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a> <a href=3D"http=
://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http://oss.sgi.com/m=
ailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</blockquote></div><br><br>-- <br>F

--001a11c33af0a1faec04dc0df824--


--===============7692659274613718032==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7692659274613718032==--
