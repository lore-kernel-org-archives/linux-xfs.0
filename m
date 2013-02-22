Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1FAA7F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 17:27:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3ED2304032
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 15:27:21 -0800 (PST)
Received: from mail-oa0-f51.google.com (mail-oa0-f51.google.com
	[209.85.219.51]) by cuda.sgi.com with ESMTP id Oq2Yuw6BTNZ7ouei
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Feb 2013 15:27:20 -0800 (PST)
Received: by mail-oa0-f51.google.com with SMTP id h2so1114928oag.38
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 15:27:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130222202518.GX22182@sgi.com>
References: <CAGot=x-aiATNxBty7FXxV_td7Wx1_Mh8c8ta=mr4hpHxtmv6Nw@mail.gmail.com>
	<20130222202518.GX22182@sgi.com>
Date: Sat, 23 Feb 2013 00:27:20 +0100
Message-ID: <CAGot=x_AcX-ajiPyCcqmdNrUiRzPwy1Tn1hxoj_chkbbULP+4w@mail.gmail.com>
Subject: Re: dozens of xfsaild threads
From: Erik Knight <kutuzof@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1054474804584217774=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============1054474804584217774==
Content-Type: multipart/alternative; boundary=f46d04462b6e5e6dc204d6588860

--f46d04462b6e5e6dc204d6588860
Content-Type: text/plain; charset=ISO-8859-1

Hi Ben,

Thanks for the help. The workload is a typical ETL processing. Building a
DataWarehouse. I'll get you the rest of that information as soon as I can
the tip about the metadata is already very interesting.

Thanks,
Erik


On Fri, Feb 22, 2013 at 9:25 PM, Ben Myers <bpm@sgi.com> wrote:

> Hi Erik,
>
> On Fri, Feb 22, 2013 at 02:04:17PM +0100, Erik Knight wrote:
> > We've recently noticed that our system is experiencing extreme
> performance
> > problems when running large workloads. The problem seems to come from
> > excessive System CPU time. Specifically dozens of xfsaild threads. We
> used
> > to have SSD drives but recently switched to HDD, so some of us are
> thinking
> > that there may be a configuration issue within XFS that is optimized for
> > SSD but performs terribly slow on HDD.
> >
> > Can anyone explain what these threads do, what would cause so many of
> them
> > to be running simultaneously or consume so much CPU?
>
> AIL stands for Active Item List.  These guys sync metadata which has been
> logged to its final location on disk.  You'll have one daemon per
> filesystem.
>
> If you have a very metadata intensive workload they could get a workout.
>  It
> would help to know a bit more about your workload and configuration.  Can
> you
> provide the relevant information listed here?
>
>
> http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Regards,
>         Ben
>

--f46d04462b6e5e6dc204d6588860
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Ben,=A0<div><br></div><div>Thanks for the help. The wor=
kload is a typical ETL processing. Building a DataWarehouse. I&#39;ll get y=
ou the rest of that information as soon as I can the tip about the metadata=
 is already very interesting.</div>
<div><br></div><div>Thanks,</div><div>Erik</div></div><div class=3D"gmail_e=
xtra"><br><br><div class=3D"gmail_quote">On Fri, Feb 22, 2013 at 9:25 PM, B=
en Myers <span dir=3D"ltr">&lt;<a href=3D"mailto:bpm@sgi.com" target=3D"_bl=
ank">bpm@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Erik,<br>
<div><div class=3D"h5"><br>
On Fri, Feb 22, 2013 at 02:04:17PM +0100, Erik Knight wrote:<br>
&gt; We&#39;ve recently noticed that our system is experiencing extreme per=
formance<br>
&gt; problems when running large workloads. The problem seems to come from<=
br>
&gt; excessive System CPU time. Specifically dozens of xfsaild threads. We =
used<br>
&gt; to have SSD drives but recently switched to HDD, so some of us are thi=
nking<br>
&gt; that there may be a configuration issue within XFS that is optimized f=
or<br>
&gt; SSD but performs terribly slow on HDD.<br>
&gt;<br>
&gt; Can anyone explain what these threads do, what would cause so many of =
them<br>
&gt; to be running simultaneously or consume so much CPU?<br>
<br>
</div></div>AIL stands for Active Item List. =A0These guys sync metadata wh=
ich has been<br>
logged to its final location on disk. =A0You&#39;ll have one daemon per fil=
esystem.<br>
<br>
If you have a very metadata intensive workload they could get a workout. =
=A0It<br>
would help to know a bit more about your workload and configuration. =A0Can=
 you<br>
provide the relevant information listed here?<br>
<br>
<a href=3D"http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_=
I_include_when_reporting_a_problem.3F" target=3D"_blank">http://www.xfs.org=
/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_pr=
oblem.3F</a><br>

<br>
Regards,<br>
=A0 =A0 =A0 =A0 Ben<br>
</blockquote></div><br></div>

--f46d04462b6e5e6dc204d6588860--


--===============1054474804584217774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1054474804584217774==--
