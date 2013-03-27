Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60C707F51
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:58:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15F3230408F
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:58:47 -0700 (PDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
	[209.85.215.44]) by cuda.sgi.com with ESMTP id ZQrLggFUWVlfSJZp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:58:44 -0700 (PDT)
Received: by mail-la0-f44.google.com with SMTP id eb20so16638400lab.31
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEDdjHcP_An=CXSo3sL0w373wFfb=Zr-T7C2fUMuDbmrm6DDHQ@mail.gmail.com>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130320004405.GC17758@dastard>
	<CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
	<20130321010149.GF17758@dastard>
	<CAEDdjHcP_An=CXSo3sL0w373wFfb=Zr-T7C2fUMuDbmrm6DDHQ@mail.gmail.com>
Date: Wed, 27 Mar 2013 21:58:43 +0000
Message-ID: <CAEDdjHdj9QD3OybyJwahpBDA=i8nxeLufaHDT0c9EEfdotp1Pw@mail.gmail.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
From: Pedro Ribeiro <pedrib@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5248515637945093893=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============5248515637945093893==
Content-Type: multipart/alternative; boundary=f46d04016be1373c8f04d8ef24cd

--f46d04016be1373c8f04d8ef24cd
Content-Type: text/plain; charset=ISO-8859-1

Hi Dave (and others),

I've pretty much established the responsible: commit
437a255aa23766666aec78af63be4c253faa8d57
(
http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tree/releases/3.7.2/xfs-fix-direct-io-nested-transaction-deadlock.patch?id=HEAD
).

Without this patch, the computer does not lock up in hibernate. So I
understand that this is most likely a bug in ToI, not in xfs. Does this
give you a better idea of how to solve the problem? The only xfs-specific
patch in ToI is below:

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0eda725..55de808 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -511,6 +511,7 @@ xfsaild(
  struct xfs_ail *ailp = data;
  long tout = 0; /* milliseconds */

+ set_freezable();
  current->flags |= PF_MEMALLOC;

  while (!kthread_should_stop()) {

Looking at the code blindly, it appears to be similar to what goes on in
other filesystems...

Regards,
Pedro


On 21 March 2013 17:45, Pedro Ribeiro <pedrib@gmail.com> wrote:

>
>
>
> On 21 March 2013 01:01, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Wed, Mar 20, 2013 at 06:01:35PM +0000, Pedro Ribeiro wrote:
>> > Thanks for the answer Dave.
>> >
>> > Yes I would definitely say it's a ToI bug that perhaps has been dormant
>> so
>> > far. Unfortunately the ToI developer is very busy at the moment, so I
>> will
>> > have to debug and fix it myself.
>> > This problem did not occur with 3.7 and the ToI code did not change.
>> >
>> > Do you have any idea where I can start looking for the XFS change in 3.8
>> > that triggered this behaviour in ToI? Or maybe it was a VFS change?
>>
>> It's almost certainly an XFS change that triggered it, but it
>> indicates (once again) that the hibernate code is simply not
>> quiescing filesystems properly (i.e. by freezing them). The work
>> that caused this problem is stopped by the filesystem when it
>> is frozen, and started again when it is thawed...
>>
>> > PS: the email definitely bounced back, most likely because imageshack is
>> > blocked on the sgi server:
>> >
>> > Technical details of permanent failure:
>> > Google tried to deliver your message, but it was rejected by the server
>> for
>> > the recipient domain oss.sgi.com by cuda-allmx.sgi.com.
>> [192.48.176.16].
>> >
>> > The error that the other server returned was:
>> > 554 rejecting banned content
>>
>> IOWs, a stupid spam filter.
>>
>> I'll see if I can get this fixed.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
> Actually I've nailed it down to a commit between 3.7.1 and 3.7.10. I'll do
> some git bisection and come back with the results.
>
> Regarding ToI and filesystem freezing, I guess I need to start delving
> into the code to see if I can fix it - long but fun journey ahead I guess.
>
> Regards,
> Pedro
>
>

--f46d04016be1373c8f04d8ef24cd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave (and others),<div><br></div><div style>I&#39;ve pr=
etty much established the responsible: commit=A0<span style=3D"color:rgb(0,=
0,0);font-size:13px">437a255aa23766666aec78af63be4c253faa8d57 (</span><a hr=
ef=3D"http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/t=
ree/releases/3.7.2/xfs-fix-direct-io-nested-transaction-deadlock.patch?id=
=3DHEAD">http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.gi=
t/tree/releases/3.7.2/xfs-fix-direct-io-nested-transaction-deadlock.patch?i=
d=3DHEAD</a>).</div>
<div style><br></div><div style>Without this patch, the computer does not l=
ock up in hibernate. So I understand that this is most likely a bug in ToI,=
 not in xfs. Does this give you a better idea of how to solve the problem? =
The only xfs-specific patch in ToI is below:</div>
<div style><br></div><div style><div>diff --git a/fs/xfs/xfs_trans_ail.c b/=
fs/xfs/xfs_trans_ail.c</div><div>index 0eda725..55de808 100644</div><div>--=
- a/fs/xfs/xfs_trans_ail.c</div><div>+++ b/fs/xfs/xfs_trans_ail.c</div>
<div>@@ -511,6 +511,7 @@ xfsaild(</div><div>=A0<span class=3D"" style=3D"wh=
ite-space:pre">	</span>struct xfs_ail<span class=3D"" style=3D"white-space:=
pre">	</span>*ailp =3D data;</div><div>=A0<span class=3D"" style=3D"white-s=
pace:pre">	</span>long<span class=3D"" style=3D"white-space:pre">		</span>t=
out =3D 0;<span class=3D"" style=3D"white-space:pre">	</span>/* millisecond=
s */</div>
<div>=A0</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>set_=
freezable();</div><div>=A0<span class=3D"" style=3D"white-space:pre">	</spa=
n>current-&gt;flags |=3D PF_MEMALLOC;</div><div>=A0</div><div>=A0<span clas=
s=3D"" style=3D"white-space:pre">	</span>while (!kthread_should_stop()) {</=
div>
<div><br></div><div style>Looking at the code blindly, it appears to be sim=
ilar to what goes on in other filesystems...</div><div style><br></div><div=
 style>Regards,</div><div style>Pedro</div></div></div><div class=3D"gmail_=
extra">
<br><br><div class=3D"gmail_quote">On 21 March 2013 17:45, Pedro Ribeiro <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:pedrib@gmail.com" target=3D"_blank">p=
edrib@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote"><div><div class=3D"h5">On 21 March 2013 01:01, Dave Chinner <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">dav=
id@fromorbit.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div>On Wed, Mar 20, 2013 at 06:01:35PM +0000, Pedro Ribei=
ro wrote:<br>


&gt; Thanks for the answer Dave.<br>
&gt;<br>
&gt; Yes I would definitely say it&#39;s a ToI bug that perhaps has been do=
rmant so<br>
&gt; far. Unfortunately the ToI developer is very busy at the moment, so I =
will<br>
&gt; have to debug and fix it myself.<br>
&gt; This problem did not occur with 3.7 and the ToI code did not change.<b=
r>
&gt;<br>
&gt; Do you have any idea where I can start looking for the XFS change in 3=
.8<br>
&gt; that triggered this behaviour in ToI? Or maybe it was a VFS change?<br=
>
<br>
</div>It&#39;s almost certainly an XFS change that triggered it, but it<br>
indicates (once again) that the hibernate code is simply not<br>
quiescing filesystems properly (i.e. by freezing them). The work<br>
that caused this problem is stopped by the filesystem when it<br>
is frozen, and started again when it is thawed...<br>
<div><br>
&gt; PS: the email definitely bounced back, most likely because imageshack =
is<br>
&gt; blocked on the sgi server:<br>
&gt;<br>
&gt; Technical details of permanent failure:<br>
&gt; Google tried to deliver your message, but it was rejected by the serve=
r for<br>
&gt; the recipient domain <a href=3D"http://oss.sgi.com" target=3D"_blank">=
oss.sgi.com</a> by <a href=3D"http://cuda-allmx.sgi.com" target=3D"_blank">=
cuda-allmx.sgi.com</a>. [192.48.176.16].<br>
&gt;<br>
&gt; The error that the other server returned was:<br>
&gt; 554 rejecting banned content<br>
<br>
</div>IOWs, a stupid spam filter.<br>
<br>
I&#39;ll see if I can get this fixed.<br>
<div><div><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a></div></div></blockquote><div><br></div></div></div><div>Actually I&#3=
9;ve nailed it down to a commit between 3.7.1 and 3.7.10. I&#39;ll do some =
git bisection and come back with the results.</div>

<div><br></div><div>Regarding ToI and filesystem freezing, I guess I need t=
o start delving into the code to see if I can fix it - long but fun journey=
 ahead I guess.</div><div><br></div><div>Regards,</div><div>Pedro=A0</div>

</div><br></div></div>
</blockquote></div><br></div>

--f46d04016be1373c8f04d8ef24cd--


--===============5248515637945093893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5248515637945093893==--
