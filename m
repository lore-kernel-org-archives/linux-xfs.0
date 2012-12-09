Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB97HBgN082802 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 01:17:11 -0600
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id 9ZJVlz08A0Gl90We
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 08 Dec 2012 23:19:38 -0800 (PST)
Received: by mail-qa0-f46.google.com with SMTP id r4so857446qaq.5
	for <xfs@oss.sgi.com>; Sat, 08 Dec 2012 23:19:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121208195304.GA20044@citd.de>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <5955806.tSHc7WOiJd@saturn>
	<20121208195304.GA20044@citd.de>
Date: Sun, 9 Dec 2012 08:19:37 +0100
Message-ID: <CAA_rkDeU2ycYPhS0RKPMf_WP4CVWMvXTwQ-O8Wq-HTVWwiPGnw@mail.gmail.com>
Subject: Re: XFS write cache flush policy
From: Lin Li <sdeber@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5906612618868922321=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

--===============5906612618868922321==
Content-Type: multipart/alternative; boundary=047d7b6da40c7c784804d066450f

--047d7b6da40c7c784804d066450f
Content-Type: text/plain; charset=ISO-8859-1

I used to JFS. JFS used to (maybe still) have the problem of indefinite
cache flush that is the write cache will not be flushed until the "flush
trigger" is fired. But in case of JFS, if I copy a lot of reasonable large
files, it seems that only the last one will have part of the content remain
in the cache. But with XFS, it "seems" to me that the file system dedicates
some cache space to the meta data, even new data is loading into the cache,
the meta data part seems not to be flushed.

At least, in your case, xfs_repair can detect errors, but in my case, it
does not find anything.

On Sat, Dec 8, 2012 at 8:53 PM, Matthias Schniedermeyer <ms@citd.de> wrote:

> On 08.12.2012 20:40, Michael Monnerie wrote:
> > Am Samstag, 8. Dezember 2012, 20:29:27 schrieb Matthias Schniedermeyer:
> > > I have the same problem, several times.
> >
> > I'd like to chime in here, with a similar issue: I have Linux on my
> > desktop, xfs is the home partition, 16G RAM. One day my system froze, no
> > chance to do a buffer flush via SYS-S/U/B, I had to press the reset
> > button (no power off, just reset). Upon restart, *lots* of files were
> > gone, destroyed, etc, and my KDE desktop wouldn't work anymore. Luckily
> > I have backups, and could restore - but this just shouldn't happen, and
> > it was *much* better with older kernels. What is the problem that
> > metadata isn't written to disk occasionally? I was on 3.6.6 when that
> > happened, now on 3.6.8, so very recent.
>
> Now that you say it, this is what happend one of the other times,
> luckily i had done a backup just before i rebooted, so after
> xfs_repair'ing the partition (the only time i had to repair something
> for as long as i'm using XFS) i had to restore my home-directory from
> backup to get my desktop in a usable state again.
>
>
>
>
> --
>
> Matthias
>

--047d7b6da40c7c784804d066450f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I used to JFS. JFS used to (maybe still) have the problem of indefinite cac=
he flush that is the write cache will not be flushed until the &quot;flush =
trigger&quot; is fired. But in case of JFS, if I copy a lot of reasonable l=
arge files, it seems that only the last one will have part of the content r=
emain in the cache. But with XFS, it &quot;seems&quot; to me that the file =
system dedicates some cache space to the meta data, even new data is loadin=
g into the cache, the meta data part seems not to be flushed. <br>
<br>At least, in your case, xfs_repair can detect errors, but in my case, i=
t does not find anything. <br>
<br><div class=3D"gmail_quote">On Sat, Dec 8, 2012 at 8:53 PM, Matthias Sch=
niedermeyer <span dir=3D"ltr">&lt;<a href=3D"mailto:ms@citd.de" target=3D"_=
blank">ms@citd.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div>On 08.12.2012 20:40, Michael Monnerie wrote:<br>
&gt; Am Samstag, 8. Dezember 2012, 20:29:27 schrieb Matthias Schniedermeyer=
:<br>
&gt; &gt; I have the same problem, several times.<br>
&gt;<br>
&gt; I&#39;d like to chime in here, with a similar issue: I have Linux on m=
y<br>
&gt; desktop, xfs is the home partition, 16G RAM. One day my system froze, =
no<br>
&gt; chance to do a buffer flush via SYS-S/U/B, I had to press the reset<br=
>
&gt; button (no power off, just reset). Upon restart, *lots* of files were<=
br>
&gt; gone, destroyed, etc, and my KDE desktop wouldn&#39;t work anymore. Lu=
ckily<br>
&gt; I have backups, and could restore - but this just shouldn&#39;t happen=
, and<br>
&gt; it was *much* better with older kernels. What is the problem that<br>
&gt; metadata isn&#39;t written to disk occasionally? I was on 3.6.6 when t=
hat<br>
&gt; happened, now on 3.6.8, so very recent.<br>
<br>
</div>Now that you say it, this is what happend one of the other times,<br>
luckily i had done a backup just before i rebooted, so after<br>
xfs_repair&#39;ing the partition (the only time i had to repair something<b=
r>
for as long as i&#39;m using XFS) i had to restore my home-directory from<b=
r>
backup to get my desktop in a usable state again.<br>
<span><font color=3D"#888888"><br>
<br>
<br>
<br>
--<br>
<br>
Matthias<br>
</font></span></blockquote></div><br>

--047d7b6da40c7c784804d066450f--


--===============5906612618868922321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5906612618868922321==--
