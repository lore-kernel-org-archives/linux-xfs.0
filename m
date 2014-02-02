Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECA4E7F96
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 09:22:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBCDB304070
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 07:22:32 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LUSswEu0ln4EXiSN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 07:22:31 -0800 (PST)
Message-ID: <52EE62AD.4030509@oracle.com>
Date: Sun, 02 Feb 2014 23:22:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Extended attributes limit in Linux
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>	<1391178074.4275.19.camel@ubuntu>	<52EBB431.50301@oracle.com>	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
	<52EE6069.7090905@oracle.com>
In-Reply-To: <52EE6069.7090905@oracle.com>
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


On 02/02 2014 23:12 PM, Jeff Liu wrote:
> =

> On 02/02 2014 22:33 PM, Sun_Blood wrote:
<snip>
>>>> FYI, Example of output from one of the failing files. First from OS X
>>>> and then same file after failed copy to XFS.
>>>>
>>>> OS X Maverik:
>>>> file: "/Users/username/Pictures/iPhoto
>>>> Library/Database/apdb/BigBlobs.apdb"
>>>> type: "\0\0\0\0"
>>>> creator: "\0\0\0\0"
>>>> attributes: avbstclinmedz
>>>> created: 01/25/2014 11:43:17
>>>> modified: 01/28/2014 20:02:46
>>>>
>>>>
>>>> Ubunutu =

>>>> getfattr: Removing leading '/' from absolute path names
>>>> # file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto
>>>> Library/Database/BigBlobs.apdb
>>>> user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94
>>>
>>>
>>> Sorry, but I don't quite follow your thought. What do you show by this
>>> output?
>>> What do you mean? Could you describe in more details?
>>>
>>> Thanks,
>>> Vyacheslav Dubeyko.
>>
>> Sorry late reply. The output is just to show what happen after I
>> transfer a file from OS X to XFS that has EA bigger then 64k(I think).
>> When I try for example to rsync this file from OS X to Linux XFS I get
>> this error:
>> rsync: rsync_xal_set:
>> lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Pictures/iPhoto
>> Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") failed:
>> Operation not permitted (1)
>>
>> But also rsync can give this error.
>> rsync: rsync_xal_set:
>> lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/IMG_6872-Edit.ti=
f"","user.com.apple.ResourceFork")
>> failed: Argument list too long (7)
>>
>> Is this 2 errors related?
> =

> Those errors are unrelated IMO, the first one is due to the permission ru=
les but
> I'm not sure the root cause, the second one is occurred as the EA value i=
s larger
> than 64K I guess.
>  =

>>
>> I will make a bug report for rsync also that it should not try to copy
>> files with EA bigger then the destination can handle. But it would be
>> great if XFS could handle this files and be fully compatible with OS X
>> backups.
> =

> 64K size is not limited by XFS directly, it is limited by VFS setxattr sy=
scall.
> IOWs, EA set operation is not yet get into XFS when "Argument list too lo=
ng" error
> is returned, so I think you would ran into the same error on other file s=
ystems
> which are support 64K EA value size as well.

To be more precise, larger EA set operation would not works via setxattr(2)=
 on Linux
regardless of the underlying file systems :).

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
