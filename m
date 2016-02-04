Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 256D87CA1
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 00:17:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D11DAC003
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 22:16:58 -0800 (PST)
Received: from mail-ob0-f180.google.com (mail-ob0-f180.google.com
	[209.85.214.180]) by cuda.sgi.com with ESMTP id
	8owo4qr9BUvCReeM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 22:16:55 -0800 (PST)
Received: by mail-ob0-f180.google.com with SMTP id ba1so56637017obb.3
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2016 22:16:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160203232834.GH459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard> <56B21690.2070304@sandeen.net>
	<20160203215144.GE459@dastard>
	<CAFHL4X1gxP8B_JLHoOKxhX553nkOH+D_2DjgXXq7hPjxTi2t0g@mail.gmail.com>
	<20160203232834.GH459@dastard>
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Wed, 3 Feb 2016 22:16:35 -0800
Message-ID: <CAFHL4X2QudU6d_i25R9JLFN5=V5r6_4EqPO9hoZYZ39AV1m8dQ@mail.gmail.com>
Subject: Re: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2164869281493007136=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============2164869281493007136==
Content-Type: multipart/alternative; boundary=047d7b33c8a2669b76052aebaed9

--047d7b33c8a2669b76052aebaed9
Content-Type: text/plain; charset=UTF-8

Hi Dave,

Thanks much for the suggestions. Your suggestion of not mixing preallocated
and non-preallocated writes on the same file makes sense to me.

Regards,
Dilip

On Wed, Feb 3, 2016 at 3:28 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 03, 2016 at 02:43:27PM -0800, Dilip Simha wrote:
> > On Wed, Feb 3, 2016 at 1:51 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Wed, Feb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:
> > > >
> > > >
> > > > On 2/3/16 2:30 AM, Dave Chinner wrote:
> > > > > On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> > > > >> Hi Dave,
> > > > >>
> > > > >> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <
> david@fromorbit.com>
> > > wrote:
> > > > >>
> > > > >>> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > > > >>>> Hi Eric,
> > > > >>>>
> > > > >>>> Thank you for your quick reply.
> > > > >>>>
> > > > >>>> Using xfs_io as per your suggestion, I am able to reproduce the
> > > issue.
> > > > >>>> However, I need to falloc for 256K and write for 257K to see
> this
> > > issue.
> > > > >>>>
> > > > >>>> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k"
> > > /srv/node/r1/t1.txt
> > > > >>>> # stat /srv/node/r1/t4.txt | grep Blocks
> > > > >>>>   Size: 263168     Blocks: 1536       IO Block: 4096   regular
> file
> > > > >>>
> > > > >>> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> > > > >>>
> > > > >>> When you writing *past the preallocated area* and do delayed
> > > > >>> allocation, the speculative preallocation beyond EOF is double
> the
> > > > >>> size of the extent at EOF. i.e. 512k, leading to 768k being
> > > > >>> allocated to the file (1536 blocks, exactly).
> > > > >>>
> > > > >>
> > > > >> Thank you for the details.
> > > > >> This is exactly where I am a bit perplexed. Since the reclamation
> > > logic
> > > > >> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did
> the
> > > > >> allocation logic allot more blocks on such an inode?
> > > > >
> > > > > To store the data you wrote outside the preallocated region, of
> > > > > course.
> > > >
> > > > I think what Dilip meant was, why does it do preallocation, not
> > > > why does it allocate blocks for the data.  That part is obvious
> > > > of course.  ;)
> > > >
> > > > IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation
> > > > from being reclaimed, why is speculative preallocation added to files
> > > > with that flag set?
> > > >
> > > > Seems like a fair question, even if Swift's use of preallocation is
> > > > ill-advised.
> > > >
> > > > I don't have all the speculative preallocation heuristics in my
> > > > head like you do Dave, but if I have it right, and it's i.e.:
> > > >
> > > > 1) preallocate 256k
> > > > 2) inode gets XFS_DIFLAG_PREALLOC
> > > > 3) write 257k
> > > > 4) inode gets speculative preallocation added due to write past EOF
> > > > 5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
> > > >
> > > > that seems suboptimal.
> > >
> > > So do things the other way around:
> > >
> > > 1) write 257k
> > > 2) preallocate 256k beyond EOF and speculative prealloc region
> > > 3) inode gets XFS_DIFLAG_PREALLOC
> > > 4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
> > >
> > > This is correct behaviour.
> > >
> >
> > I am sorry, but I don't agree to this. How can an user application know
> > about step2.
>
> Step 2 is fallocate(keep size) to a range well beyond EOF. e.g. in
> preparation for a bunch of sparse writes that are about to take
> place. So userspace will most definitely know about it. It's now the
> kernel that now doesn't have a clue what to do about the speculative
> preallocation it already has because the application is mixing it's
> IO models.
>
> Fundamentally, if you mix writes across persistent preallocation and
> adjacent holes, you are going to get a mess no matter what
> filesystem you do this to. If you don't like the way XFS handles it,
> either fix the application to not do this, or use the mount option
> to turn off speculative preallocation.
>
> Just like we say "don't mix direct IO and buffered IO on the same
> file", it's a really good idea not to mix preallocated and
> non-preallocated writes to the same file.
>
> > > But if we decide that we don't do speculative prealloc when
> > > XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate
> > > (like swift), or use fallocate to fill sparse holes in files are
> > > going fragment the hell out of their files when they extending
> > > them.
> > >
> >
> > I don't understand why would this be the case. If XFS doesn't do
> > speculative preallocation then for the 256 byte write after the end of
> EOF
> > will simply result in pushing the EOF ahead. So I see no harm if XFS
> > doesn't do speculative preallocation when XFS_DIFLAG_PREALLOC is set.
>
> I see *potential harm* in changing a long standing default
> behaviour.
>
> > > In reality, if swift is really just writing 1k past the prealloc'd
> > > range it creates, then that is clearly an application bug. Further,
> > > if swift is only ever preallocating the first 256k of each file it
> > > writes, regardless of size, then that is also an application bug.
> >
> > Its not a bug. Assume a use-case like appending to a file. Would you say
> > append is a buggy operation?
>
> If the app is using preallocation to reduce append workload file
> fragmenation, and then doesn't use preallocation once it is used up,
> the the app is definitely buggy because it's not being consistent in
> it's IO behaviour.  The app should always use fallocate() to control
> file layout, or it should never use fallocate and leave the
> filesystem to optimise the layout at it sees best.
>
> In my experience, the filesystem will almost always do a better job
> of optimising allocation for best throughput and minimum seeks than
> applications using fallocate().
>
> IOWs, the default behaviour of XFS has been around for more than 15
> years and is sane for the majority of applications out there. Hence
> the solution here is to either fix the application that is doing
> stupid things with fallocate(), or use the allocasize mount option
> to minimise the impact of the stupid thing the buggy application is
> doing.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b33c8a2669b76052aebaed9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div><br></div><div>Thanks much for the suggestion=
s. Your suggestion of not mixing preallocated and non-preallocated writes o=
n the same file makes sense to me.</div><div><br></div><div>Regards,</div><=
div>Dilip</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Feb 3, 2016 at 3:28 PM, Dave Chinner <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"=
><div class=3D"h5">On Wed, Feb 03, 2016 at 02:43:27PM -0800, Dilip Simha wr=
ote:<br>
&gt; On Wed, Feb 3, 2016 at 1:51 PM, Dave Chinner &lt;<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Wed, Feb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; On 2/3/16 2:30 AM, Dave Chinner wrote:<br>
&gt; &gt; &gt; &gt; On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha w=
rote:<br>
&gt; &gt; &gt; &gt;&gt; Hi Dave,<br>
&gt; &gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt; On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner &lt;<=
a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;<br>
&gt; &gt; wrote:<br>
&gt; &gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt; On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip=
 Simha wrote:<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; Hi Eric,<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; Thank you for your quick reply.<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; Using xfs_io as per your suggestion, I am a=
ble to reproduce the<br>
&gt; &gt; issue.<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; However, I need to falloc for 256K and writ=
e for 257K to see this<br>
&gt; &gt; issue.<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; # xfs_io -f -c &quot;falloc 0 256k&quot; -c=
 &quot;pwrite 0 257k&quot;<br>
&gt; &gt; /srv/node/r1/t1.txt<br>
&gt; &gt; &gt; &gt;&gt;&gt;&gt; # stat /srv/node/r1/t4.txt | grep Blocks<br=
>
&gt; &gt; &gt; &gt;&gt;&gt;&gt;=C2=A0 =C2=A0Size: 263168=C2=A0 =C2=A0 =C2=
=A0Blocks: 1536=C2=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096=C2=A0 =C2=A0regula=
r file<br>
&gt; &gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt; Fallocate sets the XFS_DIFLAG_PREALLOC on the i=
node.<br>
&gt; &gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;&gt; When you writing *past the preallocated area* a=
nd do delayed<br>
&gt; &gt; &gt; &gt;&gt;&gt; allocation, the speculative preallocation beyon=
d EOF is double the<br>
&gt; &gt; &gt; &gt;&gt;&gt; size of the extent at EOF. i.e. 512k, leading t=
o 768k being<br>
&gt; &gt; &gt; &gt;&gt;&gt; allocated to the file (1536 blocks, exactly).<b=
r>
&gt; &gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt; &gt;&gt; Thank you for the details.<br>
&gt; &gt; &gt; &gt;&gt; This is exactly where I am a bit perplexed. Since t=
he reclamation<br>
&gt; &gt; logic<br>
&gt; &gt; &gt; &gt;&gt; skips inodes that have the XFS_DIFLAG_PREALLOC flag=
 set, why did the<br>
&gt; &gt; &gt; &gt;&gt; allocation logic allot more blocks on such an inode=
?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; To store the data you wrote outside the preallocated re=
gion, of<br>
&gt; &gt; &gt; &gt; course.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I think what Dilip meant was, why does it do preallocation, =
not<br>
&gt; &gt; &gt; why does it allocate blocks for the data.=C2=A0 That part is=
 obvious<br>
&gt; &gt; &gt; of course.=C2=A0 ;)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocat=
ion<br>
&gt; &gt; &gt; from being reclaimed, why is speculative preallocation added=
 to files<br>
&gt; &gt; &gt; with that flag set?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Seems like a fair question, even if Swift&#39;s use of preal=
location is<br>
&gt; &gt; &gt; ill-advised.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I don&#39;t have all the speculative preallocation heuristic=
s in my<br>
&gt; &gt; &gt; head like you do Dave, but if I have it right, and it&#39;s =
i.e.:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 1) preallocate 256k<br>
&gt; &gt; &gt; 2) inode gets XFS_DIFLAG_PREALLOC<br>
&gt; &gt; &gt; 3) write 257k<br>
&gt; &gt; &gt; 4) inode gets speculative preallocation added due to write p=
ast EOF<br>
&gt; &gt; &gt; 5) inode never gets preallocation trimmed due to XFS_DIFLAG_=
PREALLOC<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; that seems suboptimal.<br>
&gt; &gt;<br>
&gt; &gt; So do things the other way around:<br>
&gt; &gt;<br>
&gt; &gt; 1) write 257k<br>
&gt; &gt; 2) preallocate 256k beyond EOF and speculative prealloc region<br=
>
&gt; &gt; 3) inode gets XFS_DIFLAG_PREALLOC<br>
&gt; &gt; 4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREAL=
LOC<br>
&gt; &gt;<br>
&gt; &gt; This is correct behaviour.<br>
&gt; &gt;<br>
&gt;<br>
&gt; I am sorry, but I don&#39;t agree to this. How can an user application=
 know<br>
&gt; about step2.<br>
<br>
</div></div>Step 2 is fallocate(keep size) to a range well beyond EOF. e.g.=
 in<br>
preparation for a bunch of sparse writes that are about to take<br>
place. So userspace will most definitely know about it. It&#39;s now the<br=
>
kernel that now doesn&#39;t have a clue what to do about the speculative<br=
>
preallocation it already has because the application is mixing it&#39;s<br>
IO models.<br>
<br>
Fundamentally, if you mix writes across persistent preallocation and<br>
adjacent holes, you are going to get a mess no matter what<br>
filesystem you do this to. If you don&#39;t like the way XFS handles it,<br=
>
either fix the application to not do this, or use the mount option<br>
to turn off speculative preallocation.<br>
<br>
Just like we say &quot;don&#39;t mix direct IO and buffered IO on the same<=
br>
file&quot;, it&#39;s a really good idea not to mix preallocated and<br>
non-preallocated writes to the same file.<br>
<span class=3D""><br>
&gt; &gt; But if we decide that we don&#39;t do speculative prealloc when<b=
r>
&gt; &gt; XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate=
<br>
&gt; &gt; (like swift), or use fallocate to fill sparse holes in files are<=
br>
&gt; &gt; going fragment the hell out of their files when they extending<br=
>
&gt; &gt; them.<br>
&gt; &gt;<br>
&gt;<br>
&gt; I don&#39;t understand why would this be the case. If XFS doesn&#39;t =
do<br>
&gt; speculative preallocation then for the 256 byte write after the end of=
 EOF<br>
&gt; will simply result in pushing the EOF ahead. So I see no harm if XFS<b=
r>
&gt; doesn&#39;t do speculative preallocation when XFS_DIFLAG_PREALLOC is s=
et.<br>
<br>
</span>I see *potential harm* in changing a long standing default<br>
behaviour.<br>
<span class=3D""><br>
&gt; &gt; In reality, if swift is really just writing 1k past the prealloc&=
#39;d<br>
&gt; &gt; range it creates, then that is clearly an application bug. Furthe=
r,<br>
&gt; &gt; if swift is only ever preallocating the first 256k of each file i=
t<br>
&gt; &gt; writes, regardless of size, then that is also an application bug.=
<br>
&gt;<br>
&gt; Its not a bug. Assume a use-case like appending to a file. Would you s=
ay<br>
&gt; append is a buggy operation?<br>
<br>
</span>If the app is using preallocation to reduce append workload file<br>
fragmenation, and then doesn&#39;t use preallocation once it is used up,<br=
>
the the app is definitely buggy because it&#39;s not being consistent in<br=
>
it&#39;s IO behaviour.=C2=A0 The app should always use fallocate() to contr=
ol<br>
file layout, or it should never use fallocate and leave the<br>
filesystem to optimise the layout at it sees best.<br>
<br>
In my experience, the filesystem will almost always do a better job<br>
of optimising allocation for best throughput and minimum seeks than<br>
applications using fallocate().<br>
<br>
IOWs, the default behaviour of XFS has been around for more than 15<br>
years and is sane for the majority of applications out there. Hence<br>
the solution here is to either fix the application that is doing<br>
stupid things with fallocate(), or use the allocasize mount option<br>
to minimise the impact of the stupid thing the buggy application is<br>
doing.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--047d7b33c8a2669b76052aebaed9--


--===============2164869281493007136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2164869281493007136==--
