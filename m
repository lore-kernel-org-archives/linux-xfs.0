Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 163E27F52
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 14:51:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4CB3AC002
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 12:51:49 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id s0oVnqFd2JnM0iGD
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Feb 2014 12:51:43 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Extended attributes limit in Linux
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAMN6oR=c3o5ayAdG010mh=9AZu0EbkU_zR4FptFA_egnbqt=8Q@mail.gmail.com>
Date: Mon, 3 Feb 2014 13:51:41 -0700
Message-Id: <5093C213-EEE8-416A-A4A1-8D463B431ADF@colorremedies.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com> <1391165083.4275.7.camel@ubuntu>
	<52EB960D.607@oracle.com> <1391172723.4275.11.camel@ubuntu>
	<52EBA783.1080801@oracle.com> <1391178074.4275.19.camel@ubuntu>
	<52EBB431.50301@oracle.com>
	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
	<83F9F221-9387-47D5-B67C-E9252056E408@colorremedies.com>
	<CAMN6oR=c3o5ayAdG010mh=9AZu0EbkU_zR4FptFA_egnbqt=8Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5196040079516188570=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sun_Blood <sblood@gmail.com>
Cc: xfs@oss.sgi.com


--===============5196040079516188570==
Content-Type: multipart/alternative; boundary="Apple-Mail=_28D81C6E-B561-4490-99BE-15883A0AC788"


--Apple-Mail=_28D81C6E-B561-4490-99BE-15883A0AC788
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


On Feb 3, 2014, at 12:14 AM, Sun_Blood <sblood@gmail.com> wrote:

>=20
> On Mon, Feb 3, 2014 at 2:15 AM, Chris Murphy <lists@colorremedies.com> =
wrote:
>=20
> On Feb 2, 2014, at 7:33 AM, Sun_Blood <sblood@gmail.com> wrote:
> > I will make a bug report for rsync also that it should not try to =
copy files with EA bigger then the destination can handle. But it would =
be great if XFS could handle this files and be fully compatible with OS =
X backups.
>=20
> What application(s) are creating such files on OS X? Or how are they =
coming to have such large extended attributes?
>=20
>=20
> Chris Murphy
>=20
> They are created by Adobe Photoshop and/or iPhoto.

I'm finding that Photoshop CS6 and older use resource fork to store =
thumbnail previews, but with API changes occurring since OS X 10.4. such =
requests for the resource fork actually end up as an extended attribute. =
This appears with xattr -l as com.apple.ResourceFork. In two example =
files they are about 50KB each.

Photoshop CC doesn't create thumbnails using resource forks anymore, =
thus this extended attribute isn't created. Plus the OS X Finder creates =
thumbnail previews directly from supported file types, even if a =
thumbnail preview resource isn't available. And last, the Resource =
Manager is deprecated as of OS X 10.8.x, so I'd expect even =
com.apple.ResourceFork to eventually go away (i.e. any application =
wanting to write a resource to the resource fork will fail).
=
https://developer.apple.com/legacy/library/documentation/Carbon/Reference/=
Resource_Manager/Reference/reference.html

The way I'd characterize data in com.apple.ResourceFork is that it's =
disposable data. That is, any application developer who cared about =
data, wouldn't store it in com.apple.ResourceFork. And this isn't a =
recent sentiment.

Are you seeing significant extended attribute data other than =
com.apple.ResourceFork in these files?


Chris Murphy=

--Apple-Mail=_28D81C6E-B561-4490-99BE-15883A0AC788
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=iso-8859-1

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Diso-8859-1"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Feb 3, 2014, at 12:14 AM, Sun_Blood &lt;<a =
href=3D"mailto:sblood@gmail.com">sblood@gmail.com</a>&gt; =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div dir=3D"ltr"><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Mon, Feb 3, 2014 at 2:15 AM, Chris Murphy <span =
dir=3D"ltr">&lt;<a href=3D"mailto:lists@colorremedies.com" =
target=3D"_blank">lists@colorremedies.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div =
class=3D"im"><br>
On Feb 2, 2014, at 7:33 AM, Sun_Blood &lt;<a =
href=3D"mailto:sblood@gmail.com">sblood@gmail.com</a>&gt; wrote:<br>
&gt; I will make a bug report for rsync also that it should not try to =
copy files with EA bigger then the destination can handle. But it would =
be great if XFS could handle this files and be fully compatible with OS =
X backups.<br>

<br>
</div>What application(s) are creating such files on OS X? Or how are =
they coming to have such large extended attributes?<br>
<span class=3D""><font color=3D"#888888"><br>
<br>
Chris Murphy</font></span></blockquote></div><br>They are created by =
Adobe Photoshop and/or =
iPhoto.<br></div></div></blockquote><br></div><div>I'm finding that =
Photoshop CS6 and older use resource fork to store thumbnail previews, =
but with API changes occurring since OS X 10.4. such requests for the =
resource fork actually end up as an extended attribute. This appears =
with xattr -l as&nbsp;com.apple.ResourceFork. In two example files they =
are about 50KB each.</div><div><br></div><div>Photoshop CC doesn't =
create thumbnails using resource forks anymore, thus this extended =
attribute isn't created. Plus the OS X Finder creates thumbnail previews =
directly from supported file types, even if a thumbnail preview resource =
isn't available. And last,&nbsp;the Resource Manager is deprecated as of =
OS X 10.8.x, so I'd expect even&nbsp;com.apple.ResourceFork to =
eventually go away (i.e. any application wanting to write a resource to =
the resource fork will fail).</div><div><a =
href=3D"https://developer.apple.com/legacy/library/documentation/Carbon/Re=
ference/Resource_Manager/Reference/reference.html">https://developer.apple=
.com/legacy/library/documentation/Carbon/Reference/Resource_Manager/Refere=
nce/reference.html</a></div><div><br></div><div>The way I'd characterize =
data in&nbsp;com.apple.ResourceFork is that it's disposable data. That =
is, any application developer who cared about data, wouldn't store it =
in&nbsp;com.apple.ResourceFork. And this isn't a recent =
sentiment.</div><div><br></div><div>Are you seeing significant extended =
attribute data other than&nbsp;com.apple.ResourceFork in these =
files?</div><div><br></div><div><br></div><div>Chris =
Murphy</div></body></html>=

--Apple-Mail=_28D81C6E-B561-4490-99BE-15883A0AC788--


--===============5196040079516188570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5196040079516188570==--
