Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C67DA7F59
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 09:46:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56678AC003
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 07:46:28 -0700 (PDT)
Received: from mail-vn0-f52.google.com (mail-vn0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id NfoY5tXVkexGeBGQ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 04 Jul 2015 07:46:25 -0700 (PDT)
Received: by vnbg1 with SMTP id g1so18613722vnb.7
	for <xfs@oss.sgi.com>; Sat, 04 Jul 2015 07:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150703235141.GQ7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
Date: Sat, 4 Jul 2015 10:46:24 -0400
Message-ID: <CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
From: Alex Gorbachev <ag@iss-integration.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6218430643359784524=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6218430643359784524==
Content-Type: multipart/alternative; boundary=20cf3030c5ff967f87051a0dbc02

--20cf3030c5ff967f87051a0dbc02
Content-Type: text/plain; charset=UTF-8

Hello Dave, thank you for the response.  I got some recommendations on the
ceph-users list that essentially pointed to the problem with
vm.swappiness=0 and its new behavior - described here
https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-new-kernel/

Basically setting it to 0 creates these OOM conditions due to never
swapping anything out.  So I changed these settings right away:

sysctl vm.swappiness=20 (can probably be 1 as per article)

sysctl vm.min_free_kbytes=262144


So far no issues, but I need to wait a week to see if anything shows up.
Thank you for reviewing the error codes.


Alex

On Fri, Jul 3, 2015 at 7:51 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jul 03, 2015 at 05:07:29AM -0400, Alex Gorbachev wrote:
> > Hello, we are seeing this and similar errors on multiple Supermicro nodes
> > running Ceph.  OS is Ubuntu 14.04.2 with kernel 4.1
> >
> > Thank you for any info and troubleshooting advice.
>
> Nothing to suggest that this is an XFS problem. Memory reclaim
> triggered by network stack memory pressure is causing inode
> eviction. While removing the page cache it's falling over in
> the generic truncate code doing a radix tree lookup. That's all
> generic code - XFS never touches the page cache radix tree directly.
>
> I haven't seen this before - is this a new problem since you
> upgraded your kernel to 4.1? Is it repeatable? if yes to both, then
> a bisect may be in order to isolate the problematic commit...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--20cf3030c5ff967f87051a0dbc02
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello Dave, thank you for the response.=C2=A0 I got some r=
ecommendations on the ceph-users list that essentially pointed to the probl=
em with vm.swappiness=3D0 and its new behavior - described here=C2=A0<a hre=
f=3D"https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-ne=
w-kernel/">https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappine=
ss0-new-kernel/</a><div><br></div><div>Basically setting it to 0 creates th=
ese OOM conditions due to never swapping anything out.=C2=A0 So I changed t=
hese settings right away:</div><div><br></div><div><p style=3D"margin:0px;p=
adding:0px;border:0px;outline:0px;font-size:16px;vertical-align:baseline;co=
lor:rgb(0,0,0);font-family:&#39;Segoe UI&#39;,helvetica,arial,sans-serif;li=
ne-height:21px;background-image:initial;background-repeat:initial">sysctl v=
m.swappiness=3D20 (can probably be 1 as per article)</p><p style=3D"margin:=
0px;padding:0px;border:0px;outline:0px;font-size:16px;vertical-align:baseli=
ne;color:rgb(0,0,0);font-family:&#39;Segoe UI&#39;,helvetica,arial,sans-ser=
if;line-height:21px;background-image:initial;background-repeat:initial">sys=
ctl vm.min_free_kbytes=3D262144</p><p style=3D"margin:0px;padding:0px;borde=
r:0px;outline:0px;font-size:16px;vertical-align:baseline;color:rgb(0,0,0);f=
ont-family:&#39;Segoe UI&#39;,helvetica,arial,sans-serif;line-height:21px;b=
ackground-image:initial;background-repeat:initial"><br></p><p style=3D"marg=
in:0px;padding:0px;border:0px;outline:0px;font-size:16px;vertical-align:bas=
eline;color:rgb(0,0,0);font-family:&#39;Segoe UI&#39;,helvetica,arial,sans-=
serif;line-height:21px;background-image:initial;background-repeat:initial">=
So far no issues, but I need to wait a week to see if anything shows up.=C2=
=A0 Thank you for reviewing the error codes.</p><p style=3D"margin:0px;padd=
ing:0px;border:0px;outline:0px;font-size:16px;vertical-align:baseline;color=
:rgb(0,0,0);font-family:&#39;Segoe UI&#39;,helvetica,arial,sans-serif;line-=
height:21px;background-image:initial;background-repeat:initial"><br></p><p =
style=3D"margin:0px;padding:0px;border:0px;outline:0px;font-size:16px;verti=
cal-align:baseline;color:rgb(0,0,0);font-family:&#39;Segoe UI&#39;,helvetic=
a,arial,sans-serif;line-height:21px;background-image:initial;background-rep=
eat:initial">Alex</p></div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Fri, Jul 3, 2015 at 7:51 PM, Dave Chinner <span dir=3D"=
ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fro=
morbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Fri, Jul 03, 2015 at 05:07:29AM -0400, Alex Gorbachev wrote:<br=
>
&gt; Hello, we are seeing this and similar errors on multiple Supermicro no=
des<br>
&gt; running Ceph.=C2=A0 OS is Ubuntu 14.04.2 with kernel 4.1<br>
&gt;<br>
&gt; Thank you for any info and troubleshooting advice.<br>
<br>
</span>Nothing to suggest that this is an XFS problem. Memory reclaim<br>
triggered by network stack memory pressure is causing inode<br>
eviction. While removing the page cache it&#39;s falling over in<br>
the generic truncate code doing a radix tree lookup. That&#39;s all<br>
generic code - XFS never touches the page cache radix tree directly.<br>
<br>
I haven&#39;t seen this before - is this a new problem since you<br>
upgraded your kernel to 4.1? Is it repeatable? if yes to both, then<br>
a bisect may be in order to isolate the problematic commit...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</font></span></blockquote></div><br></div>

--20cf3030c5ff967f87051a0dbc02--


--===============6218430643359784524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6218430643359784524==--
