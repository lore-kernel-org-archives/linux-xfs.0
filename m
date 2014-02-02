Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B8A87FA7
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 08:33:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B97C304053
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 06:33:36 -0800 (PST)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	wxwIZB6EJwpmKXyc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 06:33:34 -0800 (PST)
Received: by mail-lb0-f174.google.com with SMTP id l4so4651661lbv.19
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 06:33:33 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
In-Reply-To: <1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
Date: Sun, 2 Feb 2014 15:33:27 +0100
Message-Id: <14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>
	<1391178074.4275.19.camel@ubuntu> <52EBB431.50301@oracle.com>
	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1446669131607152218=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com


--===============1446669131607152218==
Content-Type: multipart/alternative; boundary="Apple-Mail=_1B27623B-2BE3-4E3A-AF52-BD37A5B97BBA"


--Apple-Mail=_1B27623B-2BE3-4E3A-AF52-BD37A5B97BBA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On 1 feb 2014, at 15:08, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:

>=20
> On Jan 31, 2014, at 10:25 PM, Sun_Blood wrote:
>=20
>>=20
>> On 31 jan 2014, at 15:33, Jeff Liu <jeff.liu@oracle.com> wrote:
>>=20
>>>=20
>>> On 01/31 2014 22:21 PM, Vyacheslav Dubeyko wrote:
>>>> On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:
>>>>=20
>>>>>>=20
>>>>>> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I =
have
>>>>>> failed on 3803 bytes size of xattr. So, I suppose that you have =
Mac OS X
>>>>>> Lion. And EAs is larger under Lion yet.
>>>>>>=20
>>>>>> What version of Mac OS X have you?
>>>>>>=20
>>>>> Yup, Mountain Lion v10.8.4 :)
>>>>>=20
>>>>=20
>>>> I suspect that xattrs with significant size is stored in compressed
>>>> state on HFS+. I implemented support of compressed xattrs partially =
but
>>>> I don't share this code yet. But, yes, EAs with size greater than =
64 KB
>>>> can be a problem.
>>=20
>>=20
>> FYI, Example of output from one of the failing files. First from OS X =
and then same file after failed copy to XFS.
>>=20
>> OS X Maverik:
>> file: "/Users/username/Pictures/iPhoto =
Library/Database/apdb/BigBlobs.apdb"
>> type: "\0\0\0\0"
>> creator: "\0\0\0\0"
>> attributes: avbstclinmedz
>> created: 01/25/2014 11:43:17
>> modified: 01/28/2014 20:02:46
>>=20
>>=20
>> Ubunutu=20
>> getfattr: Removing leading '/' from absolute path names
>> # file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto =
Library/Database/BigBlobs.apdb
>> user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94
>=20
>=20
> Sorry, but I don't quite follow your thought. What do you show by this =
output?
> What do you mean? Could you describe in more details?
>=20
> Thanks,
> Vyacheslav Dubeyko.

Sorry late reply. The output is just to show what happen after I =
transfer a file from OS X to XFS that has EA bigger then 64k(I think). =
When I try for example to rsync this file from OS X to Linux XFS I get =
this error:
rsync: rsync_xal_set: =
lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Pictures/iPhoto =
Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") failed: =
Operation not permitted (1)

But also rsync can give this error.
rsync: rsync_xal_set: =
lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/IMG_6872-Edit.tif"=
","user.com.apple.ResourceFork") failed: Argument list too long (7)

Is this 2 errors related?

I will make a bug report for rsync also that it should not try to copy =
files with EA bigger then the destination can handle. But it would be =
great if XFS could handle this files and be fully compatible with OS X =
backups.

//Martin=

--Apple-Mail=_1B27623B-2BE3-4E3A-AF52-BD37A5B97BBA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;"><br><div><div>On 1 feb 2014, at 15:08, Vyacheslav =
Dubeyko &lt;<a href=3D"mailto:slava@dubeyko.com">slava@dubeyko.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div style=3D"font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px;"><br>On Jan 31, 2014, at 10:25 PM, =
Sun_Blood wrote:<br><br><blockquote type=3D"cite"><br>On 31 jan 2014, at =
15:33, Jeff Liu &lt;<a =
href=3D"mailto:jeff.liu@oracle.com">jeff.liu@oracle.com</a>&gt; =
wrote:<br><br><blockquote type=3D"cite"><br>On 01/31 2014 22:21 PM, =
Vyacheslav Dubeyko wrote:<br><blockquote type=3D"cite">On Fri, =
2014-01-31 at 21:39 +0800, Jeff Liu wrote:<br><br><blockquote =
type=3D"cite"><blockquote type=3D"cite"><br>I checked the same under Mac =
OS X 10.6.8 (Snow Leopard). And I have<br>failed on 3803 bytes size of =
xattr. So, I suppose that you have Mac OS X<br>Lion. And EAs is larger =
under Lion yet.<br><br>What version of Mac OS X have =
you?<br><br></blockquote>Yup, Mountain Lion v10.8.4 =
:)<br><br></blockquote><br>I suspect that xattrs with significant size =
is stored in compressed<br>state on HFS+. I implemented support of =
compressed xattrs partially but<br>I don't share this code yet. But, =
yes, EAs with size greater than 64 KB<br>can be a =
problem.<br></blockquote></blockquote><br><br>FYI, Example of output =
from one of the failing files. First from OS X and then same file after =
failed copy to XFS.<br><br>OS X Maverik:<br>file: =
"/Users/username/Pictures/iPhoto =
Library/Database/apdb/BigBlobs.apdb"<br>type: "\0\0\0\0"<br>creator: =
"\0\0\0\0"<br>attributes: avbstclinmedz<br>created: 01/25/2014 =
11:43:17<br>modified: 01/28/2014 20:02:46<br><br><br>Ubunutu<span =
class=3D"Apple-converted-space">&nbsp;</span><br>getfattr: Removing =
leading '/' from absolute path names<br># file: =
srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto =
Library/Database/BigBlobs.apdb<br>user.com.apple.quarantine=3D"0006;52e395=
45;iPhoto;=94<br></blockquote><br><br>Sorry, but I don't quite follow =
your thought. What do you show by this output?<br>What do you mean? =
Could you describe in more details?<br><br>Thanks,<br>Vyacheslav =
Dubeyko.</div></blockquote><br></div><div>Sorry late reply. The output =
is just to show what happen after I transfer a file from OS X to XFS =
that has EA bigger then 64k(I think). When I try for example to rsync =
this file from OS X to Linux XFS I get this error:</div><div>rsync: =
rsync_xal_set: =
lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Pictures/iPhoto =
Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") failed: =
Operation not permitted (1)</div><div><br></div><div>But also rsync can =
give this error.</div><div><div>rsync: rsync_xal_set: =
lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/IMG_6872-Edit.tif"=
","user.com.apple.ResourceFork") failed: Argument list too long =
(7)</div><div><br></div><div>Is this 2 errors =
related?</div><div><br></div><div>I will make a bug report for rsync =
also that it should not try to copy files with EA bigger then the =
destination can handle. But it would be great if XFS could handle this =
files and be fully compatible with OS X =
backups.</div><div><br></div></div>//Martin</body></html>=

--Apple-Mail=_1B27623B-2BE3-4E3A-AF52-BD37A5B97BBA--


--===============1446669131607152218==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1446669131607152218==--
