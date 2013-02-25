Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 400247F83
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:38:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 196B38F8033
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:38:24 -0800 (PST)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
	[209.85.217.176]) by cuda.sgi.com with ESMTP id
	1MeHGtDOaPWRf5pA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 14:38:22 -0800 (PST)
Received: by mail-lb0-f176.google.com with SMTP id s4so2600574lbc.21
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:38:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512BDA2A.5050600@hardwarefreak.com>
References: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
	<512BDA2A.5050600@hardwarefreak.com>
Date: Mon, 25 Feb 2013 16:38:21 -0600
Message-ID: <CAEWpfG_dn8ERCwntztHNh9B-WuS331DZ76=ejC-u4zjYv-Phnw@mail.gmail.com>
Subject: Re: Consistent throughput challenge -- fragmentation?
From: Brian Cain <brian.cain@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0165178977939229111=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============0165178977939229111==
Content-Type: multipart/alternative; boundary=bcaec554dbbeba8fc104d6943229

--bcaec554dbbeba8fc104d6943229
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 25, 2013 at 3:39 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 2/25/2013 10:01 AM, Brian Cain wrote:
> > All,
> >
> > I have been observing some odd behavior regarding write throughput to an
> > XFS partition (the baseline kernel version is 2.6.32.27).  I see
> > consistently high write throughput (close to the performance of the raw
> > block device) to the filesystem immediately after a mkfs, but after a few
> > test cycles, there is sporadic poor performance.
> >
> > The test mechanism is like so:
> >
> > [mkfs.xfs <blockdev>] (no flags/options, xfsprogs ver 3.1.1-0.1.36)
> > ...
> > 1. remove a previous test cycle's directory
> > 2. create a new directory
> > 3. open/write/close a small file (4kb) in this directory
> > 4. open/read/close this same small file (by the local NFS server)
> > 5. open[O_DIRECT]/write/write/write/.../close a large file (anywhere from
> > ~100MB to 200GB)
> >
>
>
It looks like omitting step #2 and putting all files in the root directory
(and modifying step #1 to remove only the files that were associated with
that previous test cycle) avoids the poor-performance problem as well.  At
least, that's the case in testing so far.

-- 
-Brian

--bcaec554dbbeba8fc104d6943229
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Mon, Feb 25, 2013 at 3:39 PM, Stan Hoeppner <span dir=3D"ltr">&l=
t;<a href=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardware=
freak.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On 2/25/2013 10:01 AM, Brian Cain wrote=
:<br>
&gt; All,<br>
&gt;<br>
&gt; I have been observing some odd behavior regarding write throughput to =
an<br>
&gt; XFS partition (the baseline kernel version is 2.6.32.27). =A0I see<br>
&gt; consistently high write throughput (close to the performance of the ra=
w<br>
&gt; block device) to the filesystem immediately after a mkfs, but after a =
few<br>
&gt; test cycles, there is sporadic poor performance.<br>
&gt;<br>
&gt; The test mechanism is like so:<br>
&gt;<br>
&gt; [mkfs.xfs &lt;blockdev&gt;] (no flags/options, xfsprogs ver 3.1.1-0.1.=
36)<br>
&gt; ...<br>
&gt; 1. remove a previous test cycle&#39;s directory<br>
&gt; 2. create a new directory<br>
&gt; 3. open/write/close a small file (4kb) in this directory<br>
&gt; 4. open/read/close this same small file (by the local NFS server)<br>
&gt; 5. open[O_DIRECT]/write/write/write/.../close a large file (anywhere f=
rom<br>
&gt; ~100MB to 200GB)<br>
&gt;<br>
</div><div><br></div></blockquote><div>=A0</div></div>It looks like omittin=
g step #2 and putting all files in the root directory (and modifying step #=
1 to remove only the files that were associated with that previous test cyc=
le) avoids the poor-performance problem as well. =A0At least, that&#39;s th=
e case in testing so far.<br>

<br></div><div class=3D"gmail_extra">-- <br>-Brian
</div></div>

--bcaec554dbbeba8fc104d6943229--


--===============0165178977939229111==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0165178977939229111==--
