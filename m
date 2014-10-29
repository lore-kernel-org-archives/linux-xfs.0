Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B261A7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:00:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C6A78F8035
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 03:00:05 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	3dKePUlSQpOYS2ZK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 03:00:02 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id m20so2078554qcx.30
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 03:00:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544FD577.9040605@sandeen.net>
References: <CA+tQb7GSvkgsxZT2awAkMjh9wY6JXBygLoenTrtFtmRMSVwuUA@mail.gmail.com>
	<544FD577.9040605@sandeen.net>
Date: Wed, 29 Oct 2014 11:00:02 +0100
Message-ID: <CA+tQb7H0SP=C_-143AJf6dAvi58dq6t506XaT61hvPr-=QsStg@mail.gmail.com>
Subject: Re: Kernel crashes with trace ending in XFS code on RHEL6 variant
	kernel
From: Jan Kokoska <jan@glow.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6525300742606260345=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============6525300742606260345==
Content-Type: multipart/alternative; boundary=001a11c2beb0d112b405068cd30f

--001a11c2beb0d112b405068cd30f
Content-Type: text/plain; charset=UTF-8

Hi Eric,

On 28 October 2014 18:42, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 10/28/14 10:38 AM, Jan Kokoska wrote:
> > Hi,
> >
> > I'm running OpenVZ (OS container) kernel variant of RHEL6 kernel on
>
> ... for which we have no source code? ;)
>

Right, I'm sorry, the source code patch on vanilla kernel is linked from
http://openvz.org/Download/kernel/rhel6/042stab084.20
and
http://openvz.org/Download/kernel/rhel6/042stab092.3
for the two kernel versions.

xfs.aops.c differs a bit between the older and the newer version (released
6 months apart), but both kernels crash.

1031,1032c1031,1034
<  * Just skip the page if it is fully outside i_size, e.g. due
<  * to a truncate operation that is in progress.
---
>  * Skip the page if it is fully outside i_size, e.g. due to a
>  * truncate operation that is in progress. We must redirty the
>  * page so that reclaim stops reclaiming it. Otherwise
>  * xfs_vm_releasepage() is called on it and gets confused.
1034,1037c1036,1037
< if (page->index >= end_index + 1 || offset_into_page == 0) {
< unlock_page(page);
< return 0;
< }
---
> if (page->index >= end_index + 1 || offset_into_page == 0)
> goto redirty;

OpenVZ devs unfortunately don't publish their git tree anymore.


> I don't know what's in "2.6.32-openvz-amd64" so can't help much.
>
> What is at line 86 of xfs_aops.c in that kernel?
>

Stefan is right in that it's the line
bh = head = page_buffers(page);
from
xfs_count_page_state()

Eric, thanks for the pointer to ef5d437f71afdf4afdbab99213add99f4b1318fd,
I'll raise it with OpenVZ devs or with RHEL so the bug trickles downstream
to OpenVZ. I simply didn't know how much difference there may be between
XFS parts of the kernel trees that you maintain and that are e.g. in RHEL
and thought it could be a generally occurring bug. Also wanted to get in
touch with the mailing list as I've been using XFS mostly happily for a
decade.

Jan


>
> -Eric
>
> > several amd64 machines by different manufacturers (HP and Supermicro)
> > and different RAID cards (HP and Areca).
> >
> > I've started seeing kernel crashes in October, as per the netconsole
> > logs attached, on two of the machines (one HP, one Supermicro). The
> > traces look quite similar, the machine in question cannot write
> > anything to its own filesystem when this happens so the logs are made
> > over the network. The XFS filesystem is not root (that's ext4), but
> > one for data (OS containers), on both machines. When I run xfs_check
> > and xfs_repair on the filesystem after the kernel crash & reboot, no
> > issue is ever found.
> >
> > This may very well have nothing to do with XFS kernel code you wrote
> > and maintain, but in that case, could you, from looking at the traces,
> > tell me whether it maybe looks like something issue related to
> > vm/paging just ending up in XFS related code path?
> >
> > I'm happy to test any suggestions/fixes for this if it is XFS related.
> >
> > Thank you,
> > --
> > Jan Kokoska
> > Glow Internet s.r.o.
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
S pozdravem

Jan Kokoska
Glow Internet s.r.o.

--001a11c2beb0d112b405068cd30f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Eric,<br><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On 28 October 2014 18:42, Eric Sandeen <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);=
border-left-style:solid;padding-left:1ex"><span>On 10/28/14 10:38 AM, Jan K=
okoska wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;m running OpenVZ (OS container) kernel variant of RHEL6 kernel o=
n<br>
<br>
</span>... for which we have no source code? ;)<br></blockquote><div><br></=
div><div>Right, I&#39;m sorry, the source code patch on vanilla kernel is l=
inked from</div><div><a href=3D"http://openvz.org/Download/kernel/rhel6/042=
stab084.20" target=3D"_blank">http://openvz.org/Download/kernel/rhel6/042st=
ab084.20</a><br></div><div>and</div><div><a href=3D"http://openvz.org/Downl=
oad/kernel/rhel6/042stab092.3" target=3D"_blank">http://openvz.org/Download=
/kernel/rhel6/042stab092.3</a><br></div><div>for the two kernel versions.</=
div><div><br></div><div>xfs.aops.c differs a bit between the older and the =
newer version (released 6 months apart), but both kernels crash.=C2=A0</div=
><div><br></div><div><div><div>1031,1032c1031,1034</div><div>&lt; <span cla=
ss=3D"" style=3D"white-space:pre">		</span> * Just skip the page if it is f=
ully outside i_size, e.g. due</div><div>&lt; <span class=3D"" style=3D"whit=
e-space:pre">		</span> * to a truncate operation that is in progress.</div>=
<div>---</div><div>&gt; <span class=3D"" style=3D"white-space:pre">		</span=
> * Skip the page if it is fully outside i_size, e.g. due to a</div><div>&g=
t; <span class=3D"" style=3D"white-space:pre">		</span> * truncate operatio=
n that is in progress. We must redirty the</div><div>&gt; <span class=3D"" =
style=3D"white-space:pre">		</span> * page so that reclaim stops reclaiming=
 it. Otherwise</div><div>&gt; <span class=3D"" style=3D"white-space:pre">		=
</span> * xfs_vm_releasepage() is called on it and gets confused.</div><div=
>1034,1037c1036,1037</div><div>&lt; <span class=3D"" style=3D"white-space:p=
re">		</span>if (page-&gt;index &gt;=3D end_index + 1 || offset_into_page =
=3D=3D 0) {</div><div>&lt; <span class=3D"" style=3D"white-space:pre">			</=
span>unlock_page(page);</div><div>&lt; <span class=3D"" style=3D"white-spac=
e:pre">			</span>return 0;</div><div>&lt; <span class=3D"" style=3D"white-s=
pace:pre">		</span>}</div><div>---</div><div>&gt; <span class=3D"" style=3D=
"white-space:pre">		</span>if (page-&gt;index &gt;=3D end_index + 1 || offs=
et_into_page =3D=3D 0)</div><div>&gt; <span class=3D"" style=3D"white-space=
:pre">			</span>goto redirty;</div></div></div><div><br></div><div>OpenVZ d=
evs unfortunately don&#39;t publish their git tree anymore.</div><div><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:so=
lid;padding-left:1ex">
<br>
I don&#39;t know what&#39;s in &quot;2.6.32-openvz-amd64&quot; so can&#39;t=
 help much.<br>
<br>
What is at line 86 of xfs_aops.c in that kernel?<br></blockquote><div><br><=
/div><div>Stefan is right in that it&#39;s the line</div><div>bh =3D head =
=3D page_buffers(page);<br></div><div>from=C2=A0</div><div>xfs_count_page_s=
tate()<br></div><div><br></div><div>Eric, thanks for the pointer to=C2=A0ef=
5d437f71afdf4afdbab99213add99f4b1318fd, I&#39;ll raise it with OpenVZ devs =
or with RHEL so the bug trickles downstream to OpenVZ. I simply didn&#39;t =
know how much difference there may be between XFS parts of the kernel trees=
 that you maintain and that are e.g. in RHEL and thought it could be a gene=
rally occurring bug. Also wanted to get in touch with the mailing list as I=
&#39;ve been using XFS mostly happily for a decade.</div><div><br></div><di=
v>Jan</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,20=
4);border-left-style:solid;padding-left:1ex">
<br>
-Eric<br>
<div><div><br>
&gt; several amd64 machines by different manufacturers (HP and Supermicro)<=
br>
&gt; and different RAID cards (HP and Areca).<br>
&gt;<br>
&gt; I&#39;ve started seeing kernel crashes in October, as per the netconso=
le<br>
&gt; logs attached, on two of the machines (one HP, one Supermicro). The<br=
>
&gt; traces look quite similar, the machine in question cannot write<br>
&gt; anything to its own filesystem when this happens so the logs are made<=
br>
&gt; over the network. The XFS filesystem is not root (that&#39;s ext4), bu=
t<br>
&gt; one for data (OS containers), on both machines. When I run xfs_check<b=
r>
&gt; and xfs_repair on the filesystem after the kernel crash &amp; reboot, =
no<br>
&gt; issue is ever found.<br>
&gt;<br>
&gt; This may very well have nothing to do with XFS kernel code you wrote<b=
r>
&gt; and maintain, but in that case, could you, from looking at the traces,=
<br>
&gt; tell me whether it maybe looks like something issue related to<br>
&gt; vm/paging just ending up in XFS related code path?<br>
&gt;<br>
&gt; I&#39;m happy to test any suggestions/fixes for this if it is XFS rela=
ted.<br>
&gt;<br>
&gt; Thank you,<br>
&gt; --<br>
&gt; Jan Kokoska<br>
&gt; Glow Internet s.r.o.<br>
&gt;<br>
&gt;<br>
</div></div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>S pozdravem<=
br><br>Jan Kokoska<br>Glow Internet s.r.o.<br>
</div></div>

--001a11c2beb0d112b405068cd30f--


--===============6525300742606260345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6525300742606260345==--
