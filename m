Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KMmT83089466 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:48:30 -0500
Received: from kyle.its.monash.edu.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CCDF1C29BBF
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:48:27 -0700 (PDT)
Received: from kyle.its.monash.edu.au (kyle.its.monash.edu.au
	[130.194.13.163]) by cuda.sgi.com with ESMTP id
	uOwGeMfBy9dUPtND for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:48:27 -0700 (PDT)
Received: from palin.its.monash.edu.au ([130.194.13.83])
	by kyle.its.monash.edu.au
	(Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
	with ESMTP id <0LRU00LW7FCPB790@kyle.its.monash.edu.au> for
	xfs@oss.sgi.com; Wed, 21 Sep 2011 08:48:25 +1000 (EST)
Received: from palin.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 134796FE402	for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 08:48:25 +1000 (EST)
Received: from mail-gw0-f47.google.com (mail-gw0-f47.google.com [74.125.83.47])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)	by palin.its.monash.edu.au (Postfix)
	with ESMTPS id 8BA12616829	for <xfs@oss.sgi.com>; Wed,
	21 Sep 2011 08:48:23 +1000 (EST)
Received: by gwaa2 with SMTP id a2so1184099gwa.34 for <xfs@oss.sgi.com>; Tue,
	20 Sep 2011 15:48:20 -0700 (PDT)
Date: Wed, 21 Sep 2011 08:48:19 +1000
From: Nathan Scott <nathans@debian.org>
Subject: Re: The xfsprogs debian package
In-reply-to: <20110920105808.GA20601@hall.aurel32.net>
Message-id: <CAAp5ZgML+9Pnni0eTCXvXN1uo8Hs7Ksrvfooto9aYr9Ctt2Hbw@mail.gmail.com>
MIME-version: 1.0
References: <20110919170936.GA27014@infradead.org>
	<20110919171047.GA3092@infradead.org>
	<20110920105808.GA20601@hall.aurel32.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1526929926603572570=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, anibal@debian.org, Aurelien Jarno <aurel32@debian.org>
Cc: xfs@oss.sgi.com

--===============1526929926603572570==
Content-type: multipart/alternative; boundary=bcaec544ee5e83764e04ad6741d9

--bcaec544ee5e83764e04ad6741d9
Content-Type: text/plain; charset=ISO-8859-1

Hi there,

On 20 September 2011 20:58, Aurelien Jarno <aurel32@debian.org> wrote:

> On Mon, Sep 19, 2011 at 01:10:47PM -0400, Christoph Hellwig wrote:
> > [and now with the correct Cc list]
> >
> > On Mon, Sep 19, 2011 at 01:09:36PM -0400, Christoph Hellwig wrote:
> > > Hi Aurelien, Nathan & Anibal,
> > >
> > > is there any chance we can get to a defintive agreement on how to
> > > maintain the xfsprogs package?  So far the idea of releasing the
> > > upstream releases as Debian packages at the same time has worked
> > > great for both Debian, and us xfs developers (which to a large
> > > extents are heavy Debian users), but "inner" Debian circles heave
> > > always complained about it.
> > >
> > > Can we please get an explanation of why it is so in proper written
> > > englush, instead of doing by forced nmus?
>
>
The forced NMUs are independent ... that's more a lack of time on my
part to keep up with current XFS development, so noone is doing the
uploads (and those doing NMUs don't talk to the xfs list, so their changes
tend to get lost).  Its a bit of a mess, and largely thanks to me I guess.


> First of all I have to point here that there is no issue in having the
> debian/ directory present in upstream, as long as the people doing the
> development upstream and in debian are usually the same (this condition
> is actually not true anymore with the latest dpkg format, which can
> ignore an existing debian/ directory, but that's not the point here).
>
> The problem is on the point of having a native package, that is not
> having a .diff.gz or a debian.tar.gz.

Not doing so causes a few issues:
> - Native packages are supposed to be Debian specific, not doing means
>  they are wrongly identified by various scripts running in the archive.
>

FWIW, the example below is the only example I'm aware of (AFAIK,
there are no other scripts ... *shrug* ... could be wrong there though,
but you'd think there'd be a big long list given the complaints).


>  For example the translation of the Debian native packages done by
>  Debian. In this case it means that Debian translators receive a mail
>  each time a string is changed in xfsprogs in order to translate it.
>

Yeah, this is annoying but I could never convince myself it outweighed
the huge advantages of having developers able to build packages from
directly within the source tree.


>  It's great if xfsprogs can be translated in other language, but the
>  priority is given first to Debian specific packages.
>

The strings so rarely change in xfsprogs, that in practice this is not a
real issue (IMO) ... its more just a reason thrown up to give a reason,
for people who just have to have an opinion (of which there are many).


> - Making xfsprogs a native package also means that the upstream version
>  needs to match the version in Debian. If there is a need to do a
>  change in xfsprogs directly in Debian like for the recent NMU, we end
>  up with a version in Debian that has never existed upstream.
>

That logic seems a bit flawed to me - there's never a reason to change
something "directly in Debian", that couldn't have been merged in the
development xfsprogs tree - and a coordinated, reviewed release done.


> - For archive space reason, if one upload only needs a small change in
>  the debian/ directory, it means a full .tar.gz has to be uploaded
>  instead of a small .diff.gz or debian.tar.gz.
>

xfsprogs is few 100KB in size, and is only uploaded once every few
months at most ... so again, not a hugely compelling argument when
you think about it (compared to the advantages, I mean, I don't doubt
some space would indeed be saved).

Again I don't ask for not putting the debian/ directory, it's totally
> possible to have a non-native package with an empty .diff.gz or
> .debian.tar.gz.
>

Having said all that, I really don't have a strong opinion - what xfsprogs
really needs is someone with the time to take ownership, and I've not
found the time recently.  If someone would own it well, and for them its
easier to not have a native package (which it likely will be)... please go
ahead and manage the package however best suits.

cheers.

--
Nathan

--bcaec544ee5e83764e04ad6741d9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi there,<br><br><div class=3D"gmail_quote">On 20 September 2011 20:58, Aur=
elien Jarno <span dir=3D"ltr">&lt;<a href=3D"mailto:aurel32@debian.org">aur=
el32@debian.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On Mon, Sep 19, 2011 at 01:10:47PM -0400, Christoph Hellw=
ig wrote:<br>
&gt; [and now with the correct Cc list]<br>
&gt;<br>
&gt; On Mon, Sep 19, 2011 at 01:09:36PM -0400, Christoph Hellwig wrote:<br>
&gt; &gt; Hi Aurelien, Nathan &amp; Anibal,<br>
&gt; &gt;<br>
&gt; &gt; is there any chance we can get to a defintive agreement on how to=
<br>
&gt; &gt; maintain the xfsprogs package? =A0So far the idea of releasing th=
e<br>
&gt; &gt; upstream releases as Debian packages at the same time has worked<=
br>
&gt; &gt; great for both Debian, and us xfs developers (which to a large<br=
>
&gt; &gt; extents are heavy Debian users), but &quot;inner&quot; Debian cir=
cles heave<br>
&gt; &gt; always complained about it.<br>
&gt; &gt;<br>
&gt; &gt; Can we please get an explanation of why it is so in proper writte=
n<br>
&gt; &gt; englush, instead of doing by forced nmus?<br>
<br></div></blockquote><div><br></div><div>The forced NMUs are independent =
... that&#39;s more a lack of time on my</div><div>part to keep up with cur=
rent XFS development, so noone is doing the</div><div>uploads (and those do=
ing NMUs don&#39;t talk to the xfs list, so their changes</div>
<div>tend to get lost). =A0Its a bit of a mess, and largely thanks to me I =
guess.</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"><div class=3D"im"=
>
</div>First of all I have to point here that there is no issue in having th=
e<br>
debian/ directory present in upstream, as long as the people doing the<br>
development upstream and in debian are usually the same (this condition<br>
is actually not true anymore with the latest dpkg format, which can<br>
ignore an existing debian/ directory, but that&#39;s not the point here).<b=
r>
<br>
The problem is on the point of having a native package, that is not<br>
having a .diff.gz or a debian.tar.gz.=A0</blockquote><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex;"> Not doing so causes a few issues:<br>
- Native packages are supposed to be Debian specific, not doing means<br>
 =A0they are wrongly identified by various scripts running in the archive.<=
br></blockquote><div><br></div><div>FWIW, the example below is the only exa=
mple I&#39;m aware of (AFAIK,</div><div>there=A0are no other scripts ... *s=
hrug* ... could be wrong there though,</div>
<div>but you&#39;d think there&#39;d be a big long list given the complaint=
s).</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
 =A0For example the translation of the Debian native packages done by<br>
 =A0Debian. In this case it means that Debian translators receive a mail<br=
>
 =A0each time a string is changed in xfsprogs in order to translate it.<br>=
</blockquote><div><br></div><div>Yeah, this is annoying but I could never c=
onvince myself it outweighed</div><div>the huge advantages of having develo=
pers able to build packages from</div>
<div>directly within the source tree.</div><div>=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex;">
 =A0It&#39;s great if xfsprogs can be translated in other language, but the=
<br>
 =A0priority is given first to Debian specific packages.<br></blockquote><d=
iv><br></div><div>The strings so rarely change in xfsprogs, that in practic=
e this is not a</div><div>real issue (IMO) ... its more just a reason throw=
n up to give a reason,</div>
<div>for people who just have to have an opinion (of which there are many).=
</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
- Making xfsprogs a native package also means that the upstream version<br>
 =A0needs to match the version in Debian. If there is a need to do a<br>
 =A0change in xfsprogs directly in Debian like for the recent NMU, we end<b=
r>
 =A0up with a version in Debian that has never existed upstream.<br></block=
quote><div><br></div><div>That logic seems a bit flawed to me - there&#39;s=
 never a reason to change</div><div>something=A0&quot;directly=A0in Debian&=
quot;, that couldn&#39;t have been merged in the</div>
<div>development xfsprogs tree -=A0and a coordinated, reviewed release done=
.</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
- For archive space reason, if one upload only needs a small change in<br>
 =A0the debian/ directory, it means a full .tar.gz has to be uploaded<br>
 =A0instead of a small .diff.gz or debian.tar.gz.<br></blockquote><div><br>=
</div><div>xfsprogs is few 100KB in size, and is only uploaded once every f=
ew</div><div>months at most ... so again, not a hugely compelling argument =
when</div>
<div>you think about it (compared to the advantages, I mean, I don&#39;t do=
ubt</div><div>some space would indeed be saved).=A0</div><div><br></div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex;">

Again I don&#39;t ask for not putting the debian/ directory, it&#39;s total=
ly<br>
possible to have a non-native package with an empty .diff.gz or<br>
.debian.tar.gz.<br></blockquote><div><br></div><div>Having said all that, I=
 really don&#39;t have a strong opinion - what xfsprogs</div><div>really ne=
eds is someone with the time to take ownership, and I&#39;ve not</div>
<div>found the time recently. =A0If someone would own it well, and for them=
 its</div><div>easier to not have a native package (which it likely will be=
)... please go</div><div>ahead and manage the package however best suits.</=
div>
<div><br></div><div>cheers.</div><div><br></div><div>--</div><div>Nathan</d=
iv></div>

--bcaec544ee5e83764e04ad6741d9--


--===============1526929926603572570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1526929926603572570==--
