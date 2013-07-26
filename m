Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 523DD29E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 15:38:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41476304082
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 13:38:23 -0700 (PDT)
Received: from mail-vb0-f43.google.com (mail-vb0-f43.google.com
	[209.85.212.43]) by cuda.sgi.com with ESMTP id oy7ZH6KTBo8xPyhG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Jul 2013 13:38:21 -0700 (PDT)
Received: by mail-vb0-f43.google.com with SMTP id h11so616259vbh.2
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 13:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F2CD8B.8080207@hardwarefreak.com>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
Date: Fri, 26 Jul 2013 16:38:21 -0400
Message-ID: <CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1698775293579144864=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============1698775293579144864==
Content-Type: multipart/alternative; boundary=20cf307f33cc985e2304e2701f29

--20cf307f33cc985e2304e2701f29
Content-Type: text/plain; charset=ISO-8859-1

Hi Stan,

Thanks for the info (most of it was, in fact, news to me).  I'm an
application developer trying to debug a disk space problem, that's all.  So
far, I've tracked it down to being an XFS issue.

So you are saying there's no public information that can correlate XFS
versioning to CentOS (or RHEL) versioning?

Sad state of affairs.

If anyone can volunteer this info (if available to you) I'd be much
appreciative.

Regardless, is there a version history for XFS vis-a-via mainline Linux?

Thanks,

Jason


On Fri, Jul 26, 2013 at 3:27 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 7/26/2013 12:40 PM, Jason Rosenberg wrote:
>
> > Anyway, I'm surprised that you don't have some list or other way to
> > correlate version history of XFS, with os release versions.  I'm guessing
> > the version I have is not using the latest/greatest.  We actually have
> > another system that uses an older version of the kernel (2.6.32-279), and
>
> 2.6.32-279  - this is not a mainline kernel version.  This is a Red Hat
> specific string describing their internal kernel release.  It has zero
> correlation to any version number of anything else in the world of
> mainline Linux.
>
> > If, say you tell me, the mainline xfs code has improved behavior, it
> would
> > be nice to have a way to know which version of CentOS might include that?
>
> IMNSHO, CentOS is a free proprietary chrome plated dog turd.  It's
> flashy on the outside and claims it's "ENTERPRISE", "just like RHEL!".
> Then you crack it open and find nothing but crap inside.  So you take it
> back to the store that gave it away for free and the doors are barred,
> the place out of business.  The chrome has peeled off and you're stuck
> with crap that difficult to use.  Every time you touch it you get dirty
> in some fashion.
>
> RHEL is a proprietary solid chrome turd you pay for.  You can't get to
> the inside, but if you find a scratch and 'return' it Red Hat will say
> "we can help you fix that".
>
> If you avoid the flashy turds altogether while still plunking down no
> cash, and use a distro based entirely on mainline Linux and GNU user
> space source, you can get help directly from the folks who wrote the
> code you're running because they know what is where.  Whether it be
> Linux proper, the XFS subsystem, NFS, Samba, Postix, etc.  Such
> distributions are too numerous to mention.  None of them are chrome
> plated, none claim to be "just like ENTERPRISE distro X".  I tell all
> users of RHEL knock offs every time I see a situation like this:
>
> Either pay for and receive the support that's required for the
> proprietary distribution you're running, or use a completely open source
> distro based on mainline kernel source and GNU user space.  By using a
> RHEL knock off, you're simply locking yourself into an outdated
> proprietary code base for which there is no viable support option,
> because so few people in the community understand the packaging of the
> constituent parts of the RHEL kernels.  This is entirely intentional on
> the part of Red Hat, specifically to make the life of CentOS users
> painful, and rightfully so.
>
> FYI, many of the folks on the XFS list are Red Hat employees, including
> Dave.  They'll gladly assist RHEL customers here if needed.  However, to
> support CentOS users, especially in your situation, they'd have to use
> Red Hat Inc resources to hunt down the information related to the CentOS
> kernel you have that correlates to the RHEL kernel it is copied from.
> So they've just consumed Red Hat Inc resources to directly assist a free
> competitor who copied their distro.
>
> Thus there's not much incentive to assist CentOS users as they'd in
> essence be taking money out of their employer's pocket.  Taken to the
> extreme this results in pay cuts, possibly furloughs or pink slips, etc.
>
> Surely this can't be the first time you've run into a free community
> support issue with the CentOS kernel.  Surely what I've written isn't
> news to you.  Pay Red Hat for RHEL, or switch to Debian, Ubuntu, Open
> Suse, etc.  Either way you'll be able to get much better support.
>
> --
> Stan
>
>

--20cf307f33cc985e2304e2701f29
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Stan,<div><br></div><div>Thanks for the info (most of i=
t was, in fact, news to me). =A0I&#39;m an application developer trying to =
debug a disk space problem, that&#39;s all. =A0So far, I&#39;ve tracked it =
down to being an XFS issue.</div>
<div><br></div><div>So you are saying there&#39;s no public information tha=
t can correlate XFS versioning to CentOS (or RHEL) versioning?</div><div><b=
r></div><div>Sad state of affairs.</div><div><br></div><div>If anyone can v=
olunteer this info (if available to you) I&#39;d be much appreciative.</div=
>
<div><br></div><div>Regardless, is there a version history for XFS vis-a-vi=
a mainline Linux?</div><div><br></div><div>Thanks,</div><div><br></div><div=
>Jason</div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_qu=
ote">
On Fri, Jul 26, 2013 at 3:27 PM, Stan Hoeppner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.co=
m</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On 7/26/2013 12:40 PM, Jason Rosenberg wrote:<br>
<br>
</div><div class=3D"im">&gt; Anyway, I&#39;m surprised that you don&#39;t h=
ave some list or other way to<br>
&gt; correlate version history of XFS, with os release versions. =A0I&#39;m=
 guessing<br>
&gt; the version I have is not using the latest/greatest. =A0We actually ha=
ve<br>
&gt; another system that uses an older version of the kernel (2.6.32-279), =
and<br>
<br>
</div>2.6.32-279 =A0- this is not a mainline kernel version. =A0This is a R=
ed Hat<br>
specific string describing their internal kernel release. =A0It has zero<br=
>
correlation to any version number of anything else in the world of<br>
mainline Linux.<br>
<div class=3D"im"><br>
&gt; If, say you tell me, the mainline xfs code has improved behavior, it w=
ould<br>
&gt; be nice to have a way to know which version of CentOS might include th=
at?<br>
<br>
</div>IMNSHO, CentOS is a free proprietary chrome plated dog turd. =A0It&#3=
9;s<br>
flashy on the outside and claims it&#39;s &quot;ENTERPRISE&quot;, &quot;jus=
t like RHEL!&quot;.<br>
Then you crack it open and find nothing but crap inside. =A0So you take it<=
br>
back to the store that gave it away for free and the doors are barred,<br>
the place out of business. =A0The chrome has peeled off and you&#39;re stuc=
k<br>
with crap that difficult to use. =A0Every time you touch it you get dirty<b=
r>
in some fashion.<br>
<br>
RHEL is a proprietary solid chrome turd you pay for. =A0You can&#39;t get t=
o<br>
the inside, but if you find a scratch and &#39;return&#39; it Red Hat will =
say<br>
&quot;we can help you fix that&quot;.<br>
<br>
If you avoid the flashy turds altogether while still plunking down no<br>
cash, and use a distro based entirely on mainline Linux and GNU user<br>
space source, you can get help directly from the folks who wrote the<br>
code you&#39;re running because they know what is where. =A0Whether it be<b=
r>
Linux proper, the XFS subsystem, NFS, Samba, Postix, etc. =A0Such<br>
distributions are too numerous to mention. =A0None of them are chrome<br>
plated, none claim to be &quot;just like ENTERPRISE distro X&quot;. =A0I te=
ll all<br>
users of RHEL knock offs every time I see a situation like this:<br>
<br>
Either pay for and receive the support that&#39;s required for the<br>
proprietary distribution you&#39;re running, or use a completely open sourc=
e<br>
distro based on mainline kernel source and GNU user space. =A0By using a<br=
>
RHEL knock off, you&#39;re simply locking yourself into an outdated<br>
proprietary code base for which there is no viable support option,<br>
because so few people in the community understand the packaging of the<br>
constituent parts of the RHEL kernels. =A0This is entirely intentional on<b=
r>
the part of Red Hat, specifically to make the life of CentOS users<br>
painful, and rightfully so.<br>
<br>
FYI, many of the folks on the XFS list are Red Hat employees, including<br>
Dave. =A0They&#39;ll gladly assist RHEL customers here if needed. =A0Howeve=
r, to<br>
support CentOS users, especially in your situation, they&#39;d have to use<=
br>
Red Hat Inc resources to hunt down the information related to the CentOS<br=
>
kernel you have that correlates to the RHEL kernel it is copied from.<br>
So they&#39;ve just consumed Red Hat Inc resources to directly assist a fre=
e<br>
competitor who copied their distro.<br>
<br>
Thus there&#39;s not much incentive to assist CentOS users as they&#39;d in=
<br>
essence be taking money out of their employer&#39;s pocket. =A0Taken to the=
<br>
extreme this results in pay cuts, possibly furloughs or pink slips, etc.<br=
>
<br>
Surely this can&#39;t be the first time you&#39;ve run into a free communit=
y<br>
support issue with the CentOS kernel. =A0Surely what I&#39;ve written isn&#=
39;t<br>
news to you. =A0Pay Red Hat for RHEL, or switch to Debian, Ubuntu, Open<br>
Suse, etc. =A0Either way you&#39;ll be able to get much better support.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Stan<br>
<br>
</font></span></blockquote></div><br></div>

--20cf307f33cc985e2304e2701f29--


--===============1698775293579144864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1698775293579144864==--
