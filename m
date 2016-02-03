Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 041E37CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 16:43:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90258304039
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 14:43:51 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	MnkeDfAcGJ009mXF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 14:43:47 -0800 (PST)
Received: by mail-ob0-f172.google.com with SMTP id wb13so49676295obb.1
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2016 14:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160203215144.GE459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard> <56B21690.2070304@sandeen.net>
	<20160203215144.GE459@dastard>
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Wed, 3 Feb 2016 14:43:27 -0800
Message-ID: <CAFHL4X1gxP8B_JLHoOKxhX553nkOH+D_2DjgXXq7hPjxTi2t0g@mail.gmail.com>
Subject: Re: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3343329024781592600=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============3343329024781592600==
Content-Type: multipart/alternative; boundary=e89a8ff1c01edba0dd052ae55968

--e89a8ff1c01edba0dd052ae55968
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 3, 2016 at 1:51 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:
> >
> >
> > On 2/3/16 2:30 AM, Dave Chinner wrote:
> > > On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> > >> Hi Dave,
> > >>
> > >> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > >>
> > >>> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > >>>> Hi Eric,
> > >>>>
> > >>>> Thank you for your quick reply.
> > >>>>
> > >>>> Using xfs_io as per your suggestion, I am able to reproduce the
> issue.
> > >>>> However, I need to falloc for 256K and write for 257K to see this
> issue.
> > >>>>
> > >>>> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k"
> /srv/node/r1/t1.txt
> > >>>> # stat /srv/node/r1/t4.txt | grep Blocks
> > >>>>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
> > >>>
> > >>> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> > >>>
> > >>> When you writing *past the preallocated area* and do delayed
> > >>> allocation, the speculative preallocation beyond EOF is double the
> > >>> size of the extent at EOF. i.e. 512k, leading to 768k being
> > >>> allocated to the file (1536 blocks, exactly).
> > >>>
> > >>
> > >> Thank you for the details.
> > >> This is exactly where I am a bit perplexed. Since the reclamation
> logic
> > >> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
> > >> allocation logic allot more blocks on such an inode?
> > >
> > > To store the data you wrote outside the preallocated region, of
> > > course.
> >
> > I think what Dilip meant was, why does it do preallocation, not
> > why does it allocate blocks for the data.  That part is obvious
> > of course.  ;)
> >
> > IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation
> > from being reclaimed, why is speculative preallocation added to files
> > with that flag set?
> >
> > Seems like a fair question, even if Swift's use of preallocation is
> > ill-advised.
> >
> > I don't have all the speculative preallocation heuristics in my
> > head like you do Dave, but if I have it right, and it's i.e.:
> >
> > 1) preallocate 256k
> > 2) inode gets XFS_DIFLAG_PREALLOC
> > 3) write 257k
> > 4) inode gets speculative preallocation added due to write past EOF
> > 5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
> >
> > that seems suboptimal.
>
> So do things the other way around:
>
> 1) write 257k
> 2) preallocate 256k beyond EOF and speculative prealloc region
> 3) inode gets XFS_DIFLAG_PREALLOC
> 4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
>
> This is correct behaviour.
>

I am sorry, but I don't agree to this. How can an user application know
about step2. XFS may preallocate 256k or any other size depending on the
free space available on the system. Some other file-system may not even do
speculative preallocation. So it makes little sense for an user-application
to own up responsibility for disk space that it doesn't know about.


>
> How do you tell them apart, and in what context can we actually
> determine that we need to remove the inode flag?
>
> Consider the fact that the 'write 257k' doesn't actually do any
> modification to the extent list. i.e. we still have 256k of
> persistent preallocation as unwritten extents. These do not
> converted to written extents until writeback *completes*, so if we
> crash before writeback, the inode remains with only 256k of
> preallocated, unwritten extents. speculative prealloc in memory occurs in
> the
> write() context, physical allocation occurs in the writeback
> context, and inode size updates occur at IO completion.
>
> i.e. none of these contexts have enough information to be able to
> determine whether the XFS_DIFLAG_PREALLOC needs to be removed,
> because it cannot be removed until all the persistent prealloc has
> been written over *and* the new EOF is stable on disk.
>
> Further, what about persistent preallocation in the middle of the
> file? Do we remove the XFS_DIFLAG_PREALLOC while that still exists
> as unwritten extents? This gets especially interesting once we
> consider the behaviour reflink, COW and dedupe should have on such
> extents....
>
> As I said: This is anything but simple, and it's not going to get
> any simpler any time soon.
>

I agree, having to remove the XFS_DIFLAG_PREALLOC flag is not a simpler
option but needs careful thought.
However, as Dave suggested, its easier to NOT do speculative preallocation
on inodes that have this flag already set. This is simply because of the
fact that XFS assumes the user-application issued fallocate with the best
knowledge of its workload. By the way, this need not be just the Swift. Any
user application can experience this issue. Also, I am not associated with
Swift!

>
> > Never doing speculative preallocation on files with XFS_DIFLAG_PREALLOC
> > set, regardless of file offset, would seem sane to me.  App asked
> > to take control via prealloc; let it have it, and leave it at that.
>
> We don't do speculative prealloc on inodes that already have blocks
> beyond EOF. We already detect that case and don't do speculative
> prealloc. But when there aren't blocks beyond EOF, extending
> writes should use speculative preallocation.
>
> But if we decide that we don't do speculative prealloc when
> XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate
> (like swift), or use fallocate to fill sparse holes in files are
> going fragment the hell out of their files when they extending
> them.
>

I don't understand why would this be the case. If XFS doesn't do
speculative preallocation then for the 256 byte write after the end of EOF
will simply result in pushing the EOF ahead. So I see no harm if XFS
doesn't do speculative preallocation when XFS_DIFLAG_PREALLOC is set.


>
> In reality, if swift is really just writing 1k past the prealloc'd
> range it creates, then that is clearly an application bug. Further,
> if swift is only ever preallocating the first 256k of each file it
> writes, regardless of size, then that is also an application bug.
>

Its not a bug. Assume a use-case like appending to a file. Would you say
append is a buggy operation?
An append operation can come at any time after the initial fallocate and
write has happened.

Simple steps to recreate this bloated-write issue is:
xfs_io -f -c "falloc 0 256k" -c "pwrite 0 256k" -c "pwrite 256k 256" t1.txt

Thanks & Regards,
Dilip


> If such users don't like the fact their application is badly written
> and interacts badly with a filesystem feature that is, in general,
> the best behaviour to have, then they can either (1) get the
> application fixed, or (2) set mount options to turn off the feature
> that the application bugs interact badly with.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--e89a8ff1c01edba0dd052ae55968
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On W=
ed, Feb 3, 2016 at 1:51 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><div class=3D""><div class=3D"h5">On Wed, F=
eb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:<br>
&gt;<br>
&gt;<br>
&gt; On 2/3/16 2:30 AM, Dave Chinner wrote:<br>
&gt; &gt; On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:<br>
&gt; &gt;&gt; Hi Dave,<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner &lt;<a href=3D"=
mailto:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;&gt; On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wro=
te:<br>
&gt; &gt;&gt;&gt;&gt; Hi Eric,<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; Thank you for your quick reply.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; Using xfs_io as per your suggestion, I am able to rep=
roduce the issue.<br>
&gt; &gt;&gt;&gt;&gt; However, I need to falloc for 256K and write for 257K=
 to see this issue.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; # xfs_io -f -c &quot;falloc 0 256k&quot; -c &quot;pwr=
ite 0 257k&quot; /srv/node/r1/t1.txt<br>
&gt; &gt;&gt;&gt;&gt; # stat /srv/node/r1/t4.txt | grep Blocks<br>
&gt; &gt;&gt;&gt;&gt;=C2=A0 =C2=A0Size: 263168=C2=A0 =C2=A0 =C2=A0Blocks: 1=
536=C2=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096=C2=A0 =C2=A0regular file<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; When you writing *past the preallocated area* and do dela=
yed<br>
&gt; &gt;&gt;&gt; allocation, the speculative preallocation beyond EOF is d=
ouble the<br>
&gt; &gt;&gt;&gt; size of the extent at EOF. i.e. 512k, leading to 768k bei=
ng<br>
&gt; &gt;&gt;&gt; allocated to the file (1536 blocks, exactly).<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Thank you for the details.<br>
&gt; &gt;&gt; This is exactly where I am a bit perplexed. Since the reclama=
tion logic<br>
&gt; &gt;&gt; skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why =
did the<br>
&gt; &gt;&gt; allocation logic allot more blocks on such an inode?<br>
&gt; &gt;<br>
&gt; &gt; To store the data you wrote outside the preallocated region, of<b=
r>
&gt; &gt; course.<br>
&gt;<br>
&gt; I think what Dilip meant was, why does it do preallocation, not<br>
&gt; why does it allocate blocks for the data.=C2=A0 That part is obvious<b=
r>
&gt; of course.=C2=A0 ;)<br>
&gt;<br>
&gt; IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation<br>
&gt; from being reclaimed, why is speculative preallocation added to files<=
br>
&gt; with that flag set?<br>
&gt;<br>
&gt; Seems like a fair question, even if Swift&#39;s use of preallocation i=
s<br>
&gt; ill-advised.<br>
&gt;<br>
&gt; I don&#39;t have all the speculative preallocation heuristics in my<br=
>
&gt; head like you do Dave, but if I have it right, and it&#39;s i.e.:<br>
&gt;<br>
&gt; 1) preallocate 256k<br>
&gt; 2) inode gets XFS_DIFLAG_PREALLOC<br>
&gt; 3) write 257k<br>
&gt; 4) inode gets speculative preallocation added due to write past EOF<br=
>
&gt; 5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC<b=
r>
&gt;<br>
&gt; that seems suboptimal.<br>
<br>
</div></div>So do things the other way around:<br>
<br>
1) write 257k<br>
2) preallocate 256k beyond EOF and speculative prealloc region<br>
3) inode gets XFS_DIFLAG_PREALLOC<br>
4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC<br>
<br>
This is correct behaviour.<br></blockquote><div><br></div><div>I am sorry, =
but I don&#39;t agree to this. How can an user application know about step2=
. XFS may preallocate 256k or any other size depending on the free space av=
ailable on the system. Some other file-system may not even do speculative p=
reallocation. So it makes little sense for an user-application to own up re=
sponsibility for disk space that it doesn&#39;t know about.</div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-styl=
e:solid;padding-left:1ex">
<br>
How do you tell them apart, and in what context can we actually<br>
determine that we need to remove the inode flag?<br>
<br>
Consider the fact that the &#39;write 257k&#39; doesn&#39;t actually do any=
<br>
modification to the extent list. i.e. we still have 256k of<br>
persistent preallocation as unwritten extents. These do not<br>
converted to written extents until writeback *completes*, so if we<br>
crash before writeback, the inode remains with only 256k of<br>
preallocated, unwritten extents. speculative prealloc in memory occurs in t=
he<br>
write() context, physical allocation occurs in the writeback<br>
context, and inode size updates occur at IO completion.<br>
<br>
i.e. none of these contexts have enough information to be able to<br>
determine whether the XFS_DIFLAG_PREALLOC needs to be removed,<br>
because it cannot be removed until all the persistent prealloc has<br>
been written over *and* the new EOF is stable on disk.<br>
<br>
Further, what about persistent preallocation in the middle of the<br>
file? Do we remove the XFS_DIFLAG_PREALLOC while that still exists<br>
as unwritten extents? This gets especially interesting once we<br>
consider the behaviour reflink, COW and dedupe should have on such<br>
extents....<br>
<br>
As I said: This is anything but simple, and it&#39;s not going to get<br>
any simpler any time soon.<br></blockquote><div><br></div><div>I agree, hav=
ing to remove the XFS_DIFLAG_PREALLOC flag is not a simpler option but need=
s careful thought.</div><div>However, as Dave suggested, its easier to NOT =
do speculative preallocation on inodes that have this flag already set. Thi=
s is simply because of the fact that XFS assumes the user-application issue=
d fallocate with the best knowledge of its workload. By the way, this need =
not be just the Swift. Any user application can experience this issue. Also=
, I am not associated with Swift!</div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb=
(204,204,204);border-left-style:solid;padding-left:1ex">
<span class=3D""><br>
&gt; Never doing speculative preallocation on files with XFS_DIFLAG_PREALLO=
C<br>
&gt; set, regardless of file offset, would seem sane to me.=C2=A0 App asked=
<br>
&gt; to take control via prealloc; let it have it, and leave it at that.<br=
>
<br>
</span>We don&#39;t do speculative prealloc on inodes that already have blo=
cks<br>
beyond EOF. We already detect that case and don&#39;t do speculative<br>
prealloc. But when there aren&#39;t blocks beyond EOF, extending<br>
writes should use speculative preallocation.<br>
<br>
But if we decide that we don&#39;t do speculative prealloc when<br>
XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate<br>
(like swift), or use fallocate to fill sparse holes in files are<br>
going fragment the hell out of their files when they extending<br>
them.<br></blockquote><div><br></div><div>I don&#39;t understand why would =
this be the case. If XFS doesn&#39;t do speculative preallocation then for =
the 256 byte write after the end of EOF will simply result in pushing the E=
OF ahead. So I see no harm if XFS doesn&#39;t do speculative preallocation =
when XFS_DIFLAG_PREALLOC is set.</div><div>=C2=A0</div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;borde=
r-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<br>
In reality, if swift is really just writing 1k past the prealloc&#39;d<br>
range it creates, then that is clearly an application bug. Further,<br>
if swift is only ever preallocating the first 256k of each file it<br>
writes, regardless of size, then that is also an application bug.<br></bloc=
kquote><div><br></div><div>Its not a bug. Assume a use-case like appending =
to a file. Would you say append is a buggy operation?</div><div>An append o=
peration can come at any time after the initial fallocate and write has hap=
pened.</div><div><br></div><div>Simple steps to recreate this bloated-write=
 issue is:</div><div>xfs_io -f -c &quot;falloc 0 256k&quot; -c &quot;pwrite=
 0 256k&quot; -c &quot;pwrite 256k 256&quot; t1.txt<br></div><div><br></div=
><div>Thanks &amp; Regards,</div><div>Dilip</div><div><br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:=
1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left=
:1ex">
<br>
If such users don&#39;t like the fact their application is badly written<br=
>
and interacts badly with a filesystem feature that is, in general,<br>
the best behaviour to have, then they can either (1) get the<br>
application fixed, or (2) set mount options to turn off the feature<br>
that the application bugs interact badly with.<br>
<div class=3D""><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--e89a8ff1c01edba0dd052ae55968--


--===============3343329024781592600==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3343329024781592600==--
