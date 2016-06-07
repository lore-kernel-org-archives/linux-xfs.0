Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E82297CAF
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 06:07:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD47E304032
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 04:07:11 -0700 (PDT)
Received: from mail-qt0-f177.google.com (mail-qt0-f177.google.com
	[209.85.216.177]) by cuda.sgi.com with ESMTP id
	SzuvHV64DJzehps8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 04:07:09 -0700 (PDT)
Received: by mail-qt0-f177.google.com with SMTP id 23so20644098qtq.0
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2016 04:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
Date: Tue, 7 Jun 2016 05:07:08 -0600
Message-ID: <CAAA5faFV6p4dyM5qz_AAWzBdWcu1ghqMpGC3SqcXE1iuM7hUcg@mail.gmail.com>
Subject: Re: crash in xfs in current
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0508819272834698201=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Daniel Wagner <wagi@monom.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

--===============0508819272834698201==
Content-Type: multipart/alternative; boundary=001a113fe944a835110534ae3030

--001a113fe944a835110534ae3030
Content-Type: text/plain; charset=UTF-8

On Jun 7, 2016 4:52 AM, "Daniel Wagner" <wagi@monom.org> wrote:
>
> >> I try to reproduce it on 4.6. My steps do not always trigger the crash.
> >> So I can't be really sure if 4.6 doesn't show it, it does not happen.
> >
> > I have never been able to trigger this in 4.6 and it's my failsafe
> > reboot (4.6.0).
> > In 4.7-rc1 it's just a matter of time before I hit it.
> > I do a lot of transactions, using git, extraction of tar.xz etc
normally.
>
> This rings a bell. I though the lockperf tests triggered it. Before I
> compiled a new kernel I did a 'git checkout' step.

Yeah, could well be. During big git operations I get into this and while I
was trying to compile GCC 6.1.0 and I was moving mpfc dir into gcc/mpfc for
example. The move never completed. I do use git to get the latest kernel
sources for wireless testing. With the 4.6.0 I didn't hit problems. Ever
since I started using 4.7 I kept crashing on asserts in xfs. :) As I hit
this frequently I can instrument. I did write some instrumentation to
display the args flags before the assert, but from Eric's work, it doesn't
seem these are important at all as it might be a locking issue. I will say
that it sounds most likely a locking issue to me , because sometimes I just
hang in an fs operation and it never completes. Even trying to kill the mv
operation doesn't work. I can try to reproduce tomorrow and either reach
the assert or get stuck in a lock in which case trace-cmd might help.
Thanks,

Reinoud.

--001a113fe944a835110534ae3030
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jun 7, 2016 4:52 AM, &quot;Daniel Wagner&quot; &lt;<a href=3D"mailto:wag=
i@monom.org">wagi@monom.org</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;&gt; I try to reproduce it on 4.6. My steps do not always trigger =
the crash.<br>
&gt; &gt;&gt; So I can&#39;t be really sure if 4.6 doesn&#39;t show it, it =
does not happen.<br>
&gt; &gt;<br>
&gt; &gt; I have never been able to trigger this in 4.6 and it&#39;s my fai=
lsafe<br>
&gt; &gt; reboot (4.6.0).<br>
&gt; &gt; In 4.7-rc1 it&#39;s just a matter of time before I hit it.<br>
&gt; &gt; I do a lot of transactions, using git, extraction of tar.xz etc n=
ormally.<br>
&gt;<br>
&gt; This rings a bell. I though the lockperf tests triggered it. Before I<=
br>
&gt; compiled a new kernel I did a &#39;git checkout&#39; step.</p>
<p dir=3D"ltr">Yeah, could well be. During big git operations I get into th=
is and while I was trying to compile GCC 6.1.0 and I was moving mpfc dir in=
to gcc/mpfc for example. The move never completed. I do use git to get the =
latest kernel sources for wireless testing. With the 4.6.0 I didn&#39;t hit=
 problems. Ever since I started using 4.7 I kept crashing on asserts in xfs=
. :) As I hit this frequently I can instrument. I did write some instrument=
ation to display the args flags before the assert, but from Eric&#39;s work=
, it doesn&#39;t seem these are important at all as it might be a locking i=
ssue. I will say that it sounds most likely a locking issue to me , because=
 sometimes I just hang in an fs operation and it never completes. Even tryi=
ng to kill the mv operation doesn&#39;t work. I can try to reproduce tomorr=
ow and either reach the assert or get stuck in a lock in which case trace-c=
md might help.<br>
Thanks,</p>
<p dir=3D"ltr">Reinoud.<br>
</p>

--001a113fe944a835110534ae3030--


--===============0508819272834698201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0508819272834698201==--
