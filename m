Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE30E7F8D
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 09:13:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 560C2AC001
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 07:12:57 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Y8gRO4Jm1YGvNnSv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 07:12:52 -0800 (PST)
Message-ID: <52EE6069.7090905@oracle.com>
Date: Sun, 02 Feb 2014 23:12:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Extended attributes limit in Linux
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>	<1391178074.4275.19.camel@ubuntu>
	<52EBB431.50301@oracle.com>	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
In-Reply-To: <14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
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
To: Sun_Blood <sblood@gmail.com>, Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: xfs@oss.sgi.com


On 02/02 2014 22:33 PM, Sun_Blood wrote:
> =

> On 1 feb 2014, at 15:08, Vyacheslav Dubeyko <slava@dubeyko.com
> <mailto:slava@dubeyko.com>> wrote:
> =

>>
>> On Jan 31, 2014, at 10:25 PM, Sun_Blood wrote:
>>
>>>
>>> On 31 jan 2014, at 15:33, Jeff Liu <jeff.liu@oracle.com
>>> <mailto:jeff.liu@oracle.com>> wrote:
>>>
>>>>
>>>> On 01/31 2014 22:21 PM, Vyacheslav Dubeyko wrote:
>>>>> On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:
>>>>>
>>>>>>>
>>>>>>> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
>>>>>>> failed on 3803 bytes size of xattr. So, I suppose that you have
>>>>>>> Mac OS X
>>>>>>> Lion. And EAs is larger under Lion yet.
>>>>>>>
>>>>>>> What version of Mac OS X have you?
>>>>>>>
>>>>>> Yup, Mountain Lion v10.8.4 :)
>>>>>>
>>>>>
>>>>> I suspect that xattrs with significant size is stored in compressed
>>>>> state on HFS+. I implemented support of compressed xattrs partially b=
ut
>>>>> I don't share this code yet. But, yes, EAs with size greater than 64 =
KB
>>>>> can be a problem.
>>>
>>>
>>> FYI, Example of output from one of the failing files. First from OS X
>>> and then same file after failed copy to XFS.
>>>
>>> OS X Maverik:
>>> file: "/Users/username/Pictures/iPhoto
>>> Library/Database/apdb/BigBlobs.apdb"
>>> type: "\0\0\0\0"
>>> creator: "\0\0\0\0"
>>> attributes: avbstclinmedz
>>> created: 01/25/2014 11:43:17
>>> modified: 01/28/2014 20:02:46
>>>
>>>
>>> Ubunutu =

>>> getfattr: Removing leading '/' from absolute path names
>>> # file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto
>>> Library/Database/BigBlobs.apdb
>>> user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94
>>
>>
>> Sorry, but I don't quite follow your thought. What do you show by this
>> output?
>> What do you mean? Could you describe in more details?
>>
>> Thanks,
>> Vyacheslav Dubeyko.
> =

> Sorry late reply. The output is just to show what happen after I
> transfer a file from OS X to XFS that has EA bigger then 64k(I think).
> When I try for example to rsync this file from OS X to Linux XFS I get
> this error:
> rsync: rsync_xal_set:
> lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Pictures/iPhoto
> Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") failed:
> Operation not permitted (1)
> =

> But also rsync can give this error.
> rsync: rsync_xal_set:
> lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/IMG_6872-Edit.tif=
"","user.com.apple.ResourceFork")
> failed: Argument list too long (7)
> =

> Is this 2 errors related?

Those errors are unrelated IMO, the first one is due to the permission rule=
s but
I'm not sure the root cause, the second one is occurred as the EA value is =
larger
than 64K I guess.
 =

> =

> I will make a bug report for rsync also that it should not try to copy
> files with EA bigger then the destination can handle. But it would be
> great if XFS could handle this files and be fully compatible with OS X
> backups.

64K size is not limited by XFS directly, it is limited by VFS setxattr sysc=
all.
IOWs, EA set operation is not yet get into XFS when "Argument list too long=
" error
is returned, so I think you would ran into the same error on other file sys=
tems
which are support 64K EA value size as well.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
