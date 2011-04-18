Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I2gbQ3225145 for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 21:42:38 -0500
Received: from mail.shawcable.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD533BEBE0E
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 19:46:01 -0700 (PDT)
Received: from mail.shawcable.com (shawmail.shawcable.com [64.59.128.220]) by
	cuda.sgi.com with ESMTP id deGQN0vKJkwrYm40 for
	<xfs@oss.sgi.com>; Sun, 17 Apr 2011 19:46:01 -0700 (PDT)
References: <20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
In-Reply-To: <20110418004040.GS21395@dastard>
Mime-Version: 1.0 (iPhone Mail 8G4)
Message-Id: <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Sun, 17 Apr 2011 20:45:56 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6947604589307631993=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?utf-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>


--===============6947604589307631993==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative;
	boundary=Apple-Mail-5-517528027


--Apple-Mail-5-517528027
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On 2011-04-17, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Apr 16, 2011 at 08:21:28AM -0400, Theodore Tso wrote:
>>=20
>> On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:
>>> In that case, it means cp should just always use FIEMAP_FLAG_SYNC, which=
 is fine.=20
>>=20
>> Except that if someone is copying a large delay allocated file, it will c=
ause=20
>> the file to immediately snapped to disk, which might not be the greatest
>> thing in the world.=20
>=20
> Obvious workaround - if the initial fiemap call shows unwritten
> extents, redo it with the sync flag set. Though that assume=D1=95 that
> you can trust things like delalloc extents to only cover the range
> that valid data exists in. Which, of course, you can't assume,
> either. :/

Always passing FIEMAP_FLAG_SYNC is fine in this case. It should only do anyt=
hing if there is unwritten data, which is the only case we are concerned wit=
h at this point.  In any case, this is a simple solution for coreutils until=
 such a time that a more complex solution is added in the kernel (if ever).

>> Christoph is write, SEEK_HOLE and SEEK_DATA are
>> a much better API for what cp woulld lke to do.  Unfortunately it hasn't
>> been implemented yet in the VFS...
>=20
> Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.

I don't see how this will change the problem in any meaningful way. There wi=
ll still need to be code that is traversing the on-disk mapping, and also ke=
eping it coherent with unwritten data in the page cache.

Since FIEMAP already exists for most Linux filesystems, it probably makes se=
nse to implement SEEK_{HOLE,DATA} by calling FIEMAP to get the disk mapping i=
n the first place.

I agree that SEEK_{HOLE,DATA} is an easier programming interface, and probab=
ly what cp, tar, etc should use, once it is implemented.=20

Cheers, Andreas=

--Apple-Mail-5-517528027
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><body bgcolor=3D"#FFFFFF"><div><span class=3D"Apple-style-span" style=3D=
"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-compositio=
n-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color=
: rgba(77, 128, 180, 0.230469); ">On 2011-04-17, at 6:40 PM, Dave Chinner &l=
t;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<=
/span></div><div></div><blockquote type=3D"cite"><div><span>On Sat, Apr 16, 2=
011 at 08:21:28AM -0400, Theodore Tso wrote:</span><blockquote type=3D"cite"=
><span>On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:</span></blockquote=
><blockquote type=3D"cite"><blockquote type=3D"cite"><span>In that case, it m=
eans cp should just always use FIEMAP_FLAG_SYNC, which is fine. </span><br><=
/blockquote></blockquote><blockquote type=3D"cite"><span></span><br></blockq=
uote><blockquote type=3D"cite"><span>Except that if someone is copying a lar=
ge delay allocated file, it will cause </span><br></blockquote><blockquote t=
ype=3D"cite"><span>the file to immediately snapped to disk, which might not b=
e the greatest</span><br></blockquote><blockquote type=3D"cite"><span>thing i=
n the world. </span><br></blockquote><span></span><br><span>Obvious workarou=
nd - if the initial fiemap call shows unwritten</span><br><span>extents, red=
o it with the sync flag set. Though that assume=D1=95 that</span><br><span>y=
ou can trust things like delalloc extents to only cover the range</span><br>=
<span>that valid data exists in. Which, of course, you can't assume,</span><=
br><span>either. :/</span><br></div></blockquote><div><br></div>Always passi=
ng&nbsp;<span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-colo=
r: rgba(26, 26, 26, 0.292969); -webkit-composition-fill-color: rgba(175, 192=
, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.2304=
69); ">FIEMAP_FLAG_SYNC is fine in this case. It should only do anything if t=
here is unwritten data, which is the only case we are concerned with at this=
 point. &nbsp;In any case, this is a simple solution for coreutils until suc=
h a time that a more complex solution is added in the kernel (if ever).</spa=
n><div><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color=
: rgba(26, 26, 26, 0.292969); -webkit-composition-fill-color: rgba(175, 192,=
 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.23046=
9);"><br></span><blockquote type=3D"cite"><div><blockquote type=3D"cite"><sp=
an>Christoph is write, SEEK_HOLE and SEEK_DATA are</span><br></blockquote><b=
lockquote type=3D"cite"><span>a much better API for what cp woulld lke to do=
. &nbsp;Unfortunately it hasn't</span><br></blockquote><blockquote type=3D"c=
ite"><span>been implemented yet in the VFS...</span><br></blockquote><span><=
/span><br><span>Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this p=
roblem.</span><font class=3D"Apple-style-span" color=3D"#000000"><font class=
=3D"Apple-style-span" color=3D"#0023A3"><br></font></font></div></blockquote=
><br></div><div>I don't see how this will change the problem in any meaningf=
ul way. There will still need to be code that is traversing the on-disk mapp=
ing, and also keeping it coherent with unwritten data in the page cache.</di=
v><div><br></div><div>Since FIEMAP already exists for most Linux filesystems=
, it probably makes s<span class=3D"Apple-style-span" style=3D"-webkit-tap-h=
ighlight-color: rgba(26, 26, 26, 0.296875); -webkit-composition-fill-color: r=
gba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128,=
 180, 0.230469); ">ense to implement SEEK_{HOLE,DATA} by calling FIEMAP to g=
et the disk mapping in the first place.</span></div><div><span class=3D"Appl=
e-style-span" style=3D"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.29687=
5); -webkit-composition-fill-color: rgba(175, 192, 227, 0.230469); -webkit-c=
omposition-frame-color: rgba(77, 128, 180, 0.230469); "><br></span></div><di=
v><span class=3D"Apple-style-span" style=3D"-webkit-tap-highlight-color: rgb=
a(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227,=
 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); "=
>I agree that&nbsp;</span><span class=3D"Apple-style-span" style=3D"-webkit-=
tap-highlight-color: rgba(26, 26, 26, 0.292969); -webkit-composition-fill-co=
lor: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rgba(77=
, 128, 180, 0.230469); ">SEEK_{HOLE,DATA} is an easier programming interface=
, and probably what cp, tar, etc should use, once it is implemented.&nbsp;</=
span></div><div><span class=3D"Apple-style-span" style=3D"-webkit-tap-highli=
ght-color: rgba(26, 26, 26, 0.292969); -webkit-composition-fill-color: rgba(=
175, 192, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180=
, 0.230469); "><br></span></div><div><span class=3D"Apple-style-span" style=3D=
"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.292969); -webkit-compositio=
n-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color=
: rgba(77, 128, 180, 0.230469); ">Cheers, Andreas</span></div></body></html>=

--Apple-Mail-5-517528027--


--===============6947604589307631993==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6947604589307631993==--
