Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o66LwKSC203786 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 16:58:21 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AADE1B2663D
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 15:01:10 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id DhQJozGbAyFlO8lN
	for <xfs@oss.sgi.com>; Tue, 06 Jul 2010 15:01:10 -0700 (PDT)
Received: by vws15 with SMTP id 15so7545657vws.26
	for <xfs@oss.sgi.com>; Tue, 06 Jul 2010 15:01:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
From: Shaun Adolphson <shaun@adolphson.net>
Date: Wed, 7 Jul 2010 08:00:50 +1000
Message-ID: <AANLkTik62CyM_YTf2WvqKLkkPzqmZXnfF7nvUfUj9eBX@mail.gmail.com>
Subject: Re: Re: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2523778879738462038=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2523778879738462038==
Content-Type: multipart/alternative; boundary=0016e6475534e0874f048abf30f5

--0016e6475534e0874f048abf30f5
Content-Type: text/plain; charset=ISO-8859-1

>>* Software:*
>>* - Fresh install of CentOS 5.5 64bit all patches up to date*
>>* - Kernel 2.6.18-194.3.1.el5.centos.plus*
>
> First thing that comes to mind is the fact that 2.6.18 is about 3 years old.
> I'm not familiar with CentOS patching policies, but even if you've received
> and applied some XFS patches, they'd still probably be rather old.
>
> If CentOS 5.5 doesn't have a much newer kernel package available, say 2.6.30
> or later, if I were you, I'd grab the kernel source from kernel.org and roll
> your own 2.6.33.6 or 2.6.34.1.


Currently that is the latest and greatest kernel available on CentOS. So we
may need to investigate rolling our own kernel if there are no configuration
changes that we can make to resolve the problem.

Thanks,

Shaun

--0016e6475534e0874f048abf30f5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><span class=3D"Apple-style-span" style=3D"font-family: Times; font-siz=
e: medium; -webkit-border-horizontal-spacing: 1px; -webkit-border-vertical-=
spacing: 1px; "><pre>&gt;&gt;<i> Software:</i>
&gt;&gt;<i> - Fresh install of CentOS 5.5 64bit all patches up to date</i>
&gt;&gt;<i> - Kernel 2.6.18-194.3.1.el5.centos.plus</i>
&gt;
&gt; First thing that comes to mind is the fact that 2.6.18 is about 3 year=
s old.
&gt; I&#39;m not familiar with CentOS patching policies, but even if you&#3=
9;ve received
&gt; and applied some XFS patches, they&#39;d still probably be rather old.
&gt;
&gt; If CentOS 5.5 doesn&#39;t have a much newer kernel package available, =
say 2.6.30
&gt; or later, if I were you, I&#39;d grab the kernel source from <a href=
=3D"http://kernel.org">kernel.org</a> and roll
&gt; your own 2.6.33.6 or 2.6.34.1.</pre></span></div><div><br></div>Curren=
tly=A0that is the=A0latest=A0and greatest kernel=A0available=A0on CentOS. S=
o we may need to investigate rolling our own kernel if there are no configu=
ration changes that we can make to resolve the problem.<div>

<br></div><div>Thanks,</div><div><br></div><div>Shaun</div>

--0016e6475534e0874f048abf30f5--


--===============2523778879738462038==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2523778879738462038==--
