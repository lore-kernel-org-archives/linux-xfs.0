Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D690A29E1D
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 12:40:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7C8E8F8040
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:40:22 -0700 (PDT)
Received: from mail-ve0-f169.google.com (mail-ve0-f169.google.com
	[209.85.128.169]) by cuda.sgi.com with ESMTP id
	yHBmjKjsABva3BJA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 10:40:17 -0700 (PDT)
Received: by mail-ve0-f169.google.com with SMTP id db10so1498801veb.28
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:40:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130726115021.GO13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
Date: Fri, 26 Jul 2013 13:40:16 -0400
Message-ID: <CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
Subject: Re: understanding speculative preallocation
From: Jason Rosenberg <jbr@squareup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2181619536851989551=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2181619536851989551==
Content-Type: multipart/alternative; boundary=047d7b624d50c454be04e26da265

--047d7b624d50c454be04e26da265
Content-Type: text/plain; charset=ISO-8859-1

Hi Dave,

Thanks for your responses.  I'm a bit confused, as I didn't see your
responses on the actual forum (only in my email inbox).

Anyway, I'm surprised that you don't have some list or other way to
correlate version history of XFS, with os release versions.  I'm guessing
the version I have is not using the latest/greatest.  We actually have
another system that uses an older version of the kernel (2.6.32-279), and
it behaves differently (it still preallocates space beyond what will ever
be used, but not by quite as much).  When we rolled out our newer machines
to 2.6.32-358, we started seeing a marked increase in disk full problems.

If, say you tell me, the mainline xfs code has improved behavior, it would
be nice to have a way to know which version of CentOS might include that?
 Telling me to read source code across multiple kernel versions sounds like
an interesting endeavor, but not something that is the most efficient use
of my time, unless there truly is no one who can easily tell me anything
about xfs version history.

Do you have any plans to have some sort of improved documentation story
around this?  This speculative preallocation behavior is truly unexpected
and not transparent to the user.   I can see that it's probably a great
performance boost (especially for something like kafka), but kafka does
have predictable log file rotation capped at fixed sizes, so it would be
great if that could be factored in.

I suppose using the allocsize setting might work in the short term.  But I
probably don't want to set allocsize to 1Gb, since that would mean every
single file created would start with that size, is that right?  Does the
allocsize setting basically work by always keeping the file size ahead of
consumed space by the allocsize amount?

Thanks,

Jason


On Fri, Jul 26, 2013 at 7:50 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jul 26, 2013 at 12:23:40AM -0700, jbr wrote:
> > Hello,
> >
> > I'm looking for general documentation/help with the speculative
> > preallocation feature in xfs.  So far, I haven't really been able to find
> > any definitive, up to date documentation on it.
>
> Read the code - it's documented in the comments. ;)
>
> Or ask questions here, because the code changes and the only up to
> date reference is the code and/or the developers that work on it...
>
> > I'm wondering how I can find out definitively which version of xfs I am
> > using, and what the preallocation scheme in use is.
>
> Look at the kernel version, then look at the corresponding source
> code.
>
> > We are running apache kafka on our servers, and kafka uses sequential io
> to
> > write data log files.  Kafka uses, by default, a maximum log file size of
> > 1Gb.  However, most of the log files end up being 2Gb, and thus the disk
> > fills up twice as fast as it should.
> >
> > We are using xfs on CentOS 2.6.32-358.  Is there a way I can know which
> > version of xfs is built into this version of the kernel?
>
> The XFS code is part of the kernel, so look at the kernel source
> code that CentOS ships.
>
> > We are using xfs (mounted with no allocsize specified).  I've seen
> varying
> > info suggesting this means it either defaults to an allocsize of 64K
> (which
> > doesn't seem to match my observations), or that it will use dynamic
> > preallocation.
> >
> > I've also seen hints (but no actual canonical documentation) suggesting
> that
> > the dynamic preallocation works by progressively doubling the current
> file
> > size (which does match my observations).
>
> Well, it started off that way, but it has been refined since to
> handle many different cases where this behaviour is sub-optimal.
>
> > What I'm not clear on, is the scheduling for the preallocation. At what
> > point does it decide to preallocate the next doubling of space.
>
> Depends on the type of IO being done.
>
> > Is it when
> > the current preallocated space is used up,
>
> Usually.
>
> > or does it happen when the
> > current space is used up within some threshold.
>
> No.
>
> > What I'd like to do, is
> > keep the doubling behavior in tact, but have it capped so it never
> increases
> > the file beyond 1Gb.  Is there a way to do that?
>
> No.
>
> > Can I trick the
> > preallocation to not do a final doubling, if I cap my kafka log files at
> > say, 900Mb (or some percentage under 1Gb)?
>
> No.
>
> > There are numerous references to an allocation schedule like this:
> >
> > freespace       max prealloc size
> >   >5%             full extent (8GB)
> >   4-5%             2GB (8GB >> 2)
> >   3-4%             1GB (8GB >> 3)
> >   2-3%           512MB (8GB >> 4)
> >   1-2%           256MB (8GB >> 5)
> >   <1%            128MB (8GB >> 6)
> >
> > I'm just not sure I understand what this is telling me.  It seems to
> tell me
> > what the max prealloc size is, with being reduced if the disk is nearly
> > full.
>
> Yes, that's correct. Mainline also does this for quota exhaustion,
> too.
>
> > But it doesn't tell me about the progressive doubling in
> > preallocation (I assume up to a max of 8Gb).  Is any of this
> configurable?
>
> No.
>
> > Can we specify a max prealloc size somewhere?
>
> Use the allocsize mount option. It turns off dynamic behaviour and
> fixes the pre-allocation size.
>
> > The other issue seems to be that after the files are closed (from within
> the
> > java jvm), they still don't seem to have their pre-allocated space
> > reclaimed.  Are there known issues with closing the files in java not
> > properly causing a flush of the preallocated space?
>
> Possibly. There's a heuristic that turns of truncation at close - if
> your applicatin keeps doing "open-write-close" it will not truncate
> preallocation. Log files typically see this IO pattern from
> applications, and hence triggering that "no truncate" heuristic is
> exactly what you want to have happen to avoid severe fragmentation
> of the log files.
>
> > Any help pointing me to any documentation/user guides which accurately
> > describes this would be appreciated!
>
> The mechanism is not documented outside the code as it changes from
> kernel release to kernel release and supposed to be transparent to
> userspace. It's being refined and optimisaed as issues are reported.
> Indeed, I suspect that all your problems would disappear on mainline
> due to the background removal of preallocation that is no longer
> needed, and Centos doesn't have that...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b624d50c454be04e26da265
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div><br></div><div>Thanks for your responses. =A0=
I&#39;m a bit confused, as I didn&#39;t see your responses on the actual fo=
rum (only in my email inbox).</div><div><br></div><div>Anyway, I&#39;m surp=
rised that you don&#39;t have some list or other way to correlate version h=
istory of XFS, with os release versions. =A0I&#39;m guessing the version I =
have is not using the latest/greatest. =A0We actually have another system t=
hat uses an older version of the kernel (2.6.32-279), and it behaves differ=
ently (it still preallocates space beyond what will ever be used, but not b=
y quite as much). =A0When we rolled out our newer machines to=A02.6.32-358,=
 we started seeing a marked increase in disk full problems.</div>
<div><br></div><div>If, say you tell me, the mainline xfs code has improved=
 behavior, it would be nice to have a way to know which version of CentOS m=
ight include that? =A0Telling me to read source code across multiple kernel=
 versions sounds like an interesting endeavor, but not something that is th=
e most efficient use of my time, unless there truly is no one who can easil=
y tell me anything about xfs version history.</div>
<div><br></div><div>Do you have any plans to have some sort of improved doc=
umentation story around this? =A0This speculative preallocation behavior is=
 truly unexpected and not transparent to the user. =A0 I can see that it&#3=
9;s probably a great performance boost (especially for something like kafka=
), but kafka does have predictable log file rotation capped at fixed sizes,=
 so it would be great if that could be factored in.</div>
<div><br></div><div>I suppose using the allocsize setting might work in the=
 short term. =A0But I probably don&#39;t want to set allocsize to 1Gb, sinc=
e that would mean every single file created would start with that size, is =
that right? =A0Does the allocsize setting basically work by always keeping =
the file size ahead of consumed space by the allocsize amount?</div>
<div><br></div><div>Thanks,</div><div><br></div><div>Jason</div></div><div =
class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Jul 26, 20=
13 at 7:50 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@f=
romorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<b=
r>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">On Fri, Jul 26, 2013 at 12:23:40AM -0700, jb=
r wrote:<br>
&gt; Hello,<br>
&gt;<br>
&gt; I&#39;m looking for general documentation/help with the speculative<br=
>
&gt; preallocation feature in xfs. =A0So far, I haven&#39;t really been abl=
e to find<br>
&gt; any definitive, up to date documentation on it.<br>
<br>
Read the code - it&#39;s documented in the comments. ;)<br>
<br>
Or ask questions here, because the code changes and the only up to<br>
date reference is the code and/or the developers that work on it...<br>
<br>
&gt; I&#39;m wondering how I can find out definitively which version of xfs=
 I am<br>
&gt; using, and what the preallocation scheme in use is.<br>
<br>
Look at the kernel version, then look at the corresponding source<br>
code.<br>
<br>
&gt; We are running apache kafka on our servers, and kafka uses sequential =
io to<br>
&gt; write data log files. =A0Kafka uses, by default, a maximum log file si=
ze of<br>
&gt; 1Gb. =A0However, most of the log files end up being 2Gb, and thus the =
disk<br>
&gt; fills up twice as fast as it should.<br>
&gt;<br>
&gt; We are using xfs on CentOS 2.6.32-358. =A0Is there a way I can know wh=
ich<br>
&gt; version of xfs is built into this version of the kernel?<br>
<br>
The XFS code is part of the kernel, so look at the kernel source<br>
code that CentOS ships.<br>
<br>
&gt; We are using xfs (mounted with no allocsize specified). =A0I&#39;ve se=
en varying<br>
&gt; info suggesting this means it either defaults to an allocsize of 64K (=
which<br>
&gt; doesn&#39;t seem to match my observations), or that it will use dynami=
c<br>
&gt; preallocation.<br>
&gt;<br>
&gt; I&#39;ve also seen hints (but no actual canonical documentation) sugge=
sting that<br>
&gt; the dynamic preallocation works by progressively doubling the current =
file<br>
&gt; size (which does match my observations).<br>
<br>
Well, it started off that way, but it has been refined since to<br>
handle many different cases where this behaviour is sub-optimal.<br>
<br>
&gt; What I&#39;m not clear on, is the scheduling for the preallocation. At=
 what<br>
&gt; point does it decide to preallocate the next doubling of space.<br>
<br>
Depends on the type of IO being done.<br>
<br>
&gt; Is it when<br>
&gt; the current preallocated space is used up,<br>
<br>
Usually.<br>
<br>
&gt; or does it happen when the<br>
&gt; current space is used up within some threshold.<br>
<br>
No.<br>
<br>
&gt; What I&#39;d like to do, is<br>
&gt; keep the doubling behavior in tact, but have it capped so it never inc=
reases<br>
&gt; the file beyond 1Gb. =A0Is there a way to do that?<br>
<br>
No.<br>
<br>
&gt; Can I trick the<br>
&gt; preallocation to not do a final doubling, if I cap my kafka log files =
at<br>
&gt; say, 900Mb (or some percentage under 1Gb)?<br>
<br>
No.<br>
<br>
&gt; There are numerous references to an allocation schedule like this:<br>
&gt;<br>
&gt; freespace =A0 =A0 =A0 max prealloc size<br>
&gt; =A0 &gt;5% =A0 =A0 =A0 =A0 =A0 =A0 full extent (8GB)<br>
&gt; =A0 4-5% =A0 =A0 =A0 =A0 =A0 =A0 2GB (8GB &gt;&gt; 2)<br>
&gt; =A0 3-4% =A0 =A0 =A0 =A0 =A0 =A0 1GB (8GB &gt;&gt; 3)<br>
&gt; =A0 2-3% =A0 =A0 =A0 =A0 =A0 512MB (8GB &gt;&gt; 4)<br>
&gt; =A0 1-2% =A0 =A0 =A0 =A0 =A0 256MB (8GB &gt;&gt; 5)<br>
&gt; =A0 &lt;1% =A0 =A0 =A0 =A0 =A0 =A0128MB (8GB &gt;&gt; 6)<br>
&gt;<br>
&gt; I&#39;m just not sure I understand what this is telling me. =A0It seem=
s to tell me<br>
&gt; what the max prealloc size is, with being reduced if the disk is nearl=
y<br>
&gt; full.<br>
<br>
Yes, that&#39;s correct. Mainline also does this for quota exhaustion,<br>
too.<br>
<br>
&gt; But it doesn&#39;t tell me about the progressive doubling in<br>
&gt; preallocation (I assume up to a max of 8Gb). =A0Is any of this configu=
rable?<br>
<br>
No.<br>
<br>
&gt; Can we specify a max prealloc size somewhere?<br>
<br>
Use the allocsize mount option. It turns off dynamic behaviour and<br>
fixes the pre-allocation size.<br>
<br>
&gt; The other issue seems to be that after the files are closed (from with=
in the<br>
&gt; java jvm), they still don&#39;t seem to have their pre-allocated space=
<br>
&gt; reclaimed. =A0Are there known issues with closing the files in java no=
t<br>
&gt; properly causing a flush of the preallocated space?<br>
<br>
Possibly. There&#39;s a heuristic that turns of truncation at close - if<br=
>
your applicatin keeps doing &quot;open-write-close&quot; it will not trunca=
te<br>
preallocation. Log files typically see this IO pattern from<br>
applications, and hence triggering that &quot;no truncate&quot; heuristic i=
s<br>
exactly what you want to have happen to avoid severe fragmentation<br>
of the log files.<br>
<br>
&gt; Any help pointing me to any documentation/user guides which accurately=
<br>
&gt; describes this would be appreciated!<br>
<br>
The mechanism is not documented outside the code as it changes from<br>
kernel release to kernel release and supposed to be transparent to<br>
userspace. It&#39;s being refined and optimisaed as issues are reported.<br=
>
Indeed, I suspect that all your problems would disappear on mainline<br>
due to the background removal of preallocation that is no longer<br>
needed, and Centos doesn&#39;t have that...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--047d7b624d50c454be04e26da265--


--===============2181619536851989551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2181619536851989551==--
