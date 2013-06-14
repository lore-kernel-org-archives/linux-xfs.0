Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A97707F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 17:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31C2CAC00A
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 15:37:04 -0700 (PDT)
Received: from mail-qa0-f41.google.com (mail-qa0-f41.google.com
	[209.85.216.41]) by cuda.sgi.com with ESMTP id KzC51G46AXuG1cyd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 15:37:02 -0700 (PDT)
Received: by mail-qa0-f41.google.com with SMTP id f14so466638qak.7
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 15:37:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <91017249.1356192.1371248207334.JavaMail.root@redhat.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
Date: Fri, 14 Jun 2013 18:37:01 -0400
Message-ID: <CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6025589322769041182=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@redhat.com>
Cc: xfs@oss.sgi.com

--===============6025589322769041182==
Content-Type: multipart/alternative; boundary=001a1133dde6af0fde04df24e25e

--001a1133dde6af0fde04df24e25e
Content-Type: text/plain; charset=ISO-8859-1

actually I have since found a decoder ring here -
http://xfs.org/index.php/Runtime_Stats and have been incorporating a lot of
the data so I can look at things in real time.  I'd still love to know why
writing 1000 1K files results in 200MB/sec of disk I/O though.  clearly
something weird is going on. both PCP as well as collectl (now that I have
incorporated some of the counters) are both telling me that I/O is in the
logging, but why remains a mystery.  can anyone offer some suggestions as
to why?
-mark



On Fri, Jun 14, 2013 at 6:16 PM, Nathan Scott <nathans@redhat.com> wrote:

> Hi Mark,
>
> ----- Original Message -----
> > I've been thinking about adding xfs support to collectl but am having a
> hard
> > time trying to decode he data in the stat file. can someone point me to a
> > decoder ring? thanks.
>
> Using Performance Co-Pilot, "pminfo -T xfs" will give you the answers you
> seek.
> [ http://oss.sgi.com/projects/pcp/ ]
>
> cheers.
>
> --
> Nathan
>

--001a1133dde6af0fde04df24e25e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">actually I have since found a decoder ring here -=A0<a hre=
f=3D"http://xfs.org/index.php/Runtime_Stats">http://xfs.org/index.php/Runti=
me_Stats</a>=A0and have been incorporating a lot of the data so I can look =
at things in real time. =A0I&#39;d still love to know why writing 1000 1K f=
iles results in 200MB/sec of disk I/O though. =A0clearly something weird is=
 going on. both PCP as well as collectl (now that I have incorporated some =
of the counters) are both telling me that I/O is in the logging, but why re=
mains a mystery. =A0can anyone offer some suggestions as to why?<div style>
-mark</div><div style><br></div></div><div class=3D"gmail_extra"><br><br><d=
iv class=3D"gmail_quote">On Fri, Jun 14, 2013 at 6:16 PM, Nathan Scott <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:nathans@redhat.com" target=3D"_blank">n=
athans@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Mark,<br>
<div><div class=3D"h5"><br>
----- Original Message -----<br>
&gt; I&#39;ve been thinking about adding xfs support to collectl but am hav=
ing a hard<br>
&gt; time trying to decode he data in the stat file. can someone point me t=
o a<br>
&gt; decoder ring? thanks.<br>
<br>
</div></div>Using Performance Co-Pilot, &quot;pminfo -T xfs&quot; will give=
 you the answers you seek.<br>
[ <a href=3D"http://oss.sgi.com/projects/pcp/" target=3D"_blank">http://oss=
.sgi.com/projects/pcp/</a> ]<br>
<br>
cheers.<br>
<br>
--<br>
Nathan<br>
</blockquote></div><br></div>

--001a1133dde6af0fde04df24e25e--


--===============6025589322769041182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6025589322769041182==--
