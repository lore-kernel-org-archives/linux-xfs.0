Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E9A87FAB
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 07:03:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DB378F8052
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 05:03:46 -0800 (PST)
Received: from gproxy2-pub.mail.unifiedlayer.com
	(gproxy2-pub.mail.unifiedlayer.com [69.89.18.3]) by
	cuda.sgi.com with SMTP id Q2laFebErFFKiHXC for
	<xfs@oss.sgi.com>; Sat, 01 Feb 2014 05:03:41 -0800 (PST)
Subject: Re: Extended attributes limit in Linux
Mime-Version: 1.0 (Apple Message framework v1085)
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
Date: Sat, 1 Feb 2014 17:08:09 +0300
Message-Id: <1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>
	<1391178074.4275.19.camel@ubuntu> <52EBB431.50301@oracle.com>
	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sun_Blood <sblood@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com


On Jan 31, 2014, at 10:25 PM, Sun_Blood wrote:

> =

> On 31 jan 2014, at 15:33, Jeff Liu <jeff.liu@oracle.com> wrote:
> =

>> =

>> On 01/31 2014 22:21 PM, Vyacheslav Dubeyko wrote:
>>> On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:
>>> =

>>>>> =

>>>>> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
>>>>> failed on 3803 bytes size of xattr. So, I suppose that you have Mac O=
S X
>>>>> Lion. And EAs is larger under Lion yet.
>>>>> =

>>>>> What version of Mac OS X have you?
>>>>> =

>>>> Yup, Mountain Lion v10.8.4 :)
>>>> =

>>> =

>>> I suspect that xattrs with significant size is stored in compressed
>>> state on HFS+. I implemented support of compressed xattrs partially but
>>> I don't share this code yet. But, yes, EAs with size greater than 64 KB
>>> can be a problem.
> =

> =

> FYI, Example of output from one of the failing files. First from OS X and=
 then same file after failed copy to XFS.
> =

> OS X Maverik:
> file: "/Users/username/Pictures/iPhoto Library/Database/apdb/BigBlobs.apd=
b"
> type: "\0\0\0\0"
> creator: "\0\0\0\0"
> attributes: avbstclinmedz
> created: 01/25/2014 11:43:17
> modified: 01/28/2014 20:02:46
> =

> =

> Ubunutu =

> getfattr: Removing leading '/' from absolute path names
> # file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto Library/Dat=
abase/BigBlobs.apdb
> user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94


Sorry, but I don't quite follow your thought. What do you show by this outp=
ut?
What do you mean? Could you describe in more details?

Thanks,
Vyacheslav Dubeyko.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
