Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF11C7F56
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:25:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFD028F8068
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 11:25:14 -0800 (PST)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
	[209.85.217.182]) by cuda.sgi.com with ESMTP id
	3AILH2vQ4i0KR4ze (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 11:25:12 -0800 (PST)
Received: by mail-lb0-f182.google.com with SMTP id w7so3800589lbi.13
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 11:25:11 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
In-Reply-To: <52EBB431.50301@oracle.com>
Date: Fri, 31 Jan 2014 20:25:08 +0100
Message-Id: <6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>
	<1391178074.4275.19.camel@ubuntu> <52EBB431.50301@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>


On 31 jan 2014, at 15:33, Jeff Liu <jeff.liu@oracle.com> wrote:

> =

> On 01/31 2014 22:21 PM, Vyacheslav Dubeyko wrote:
>> On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:
>> =

>>>> =

>>>> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
>>>> failed on 3803 bytes size of xattr. So, I suppose that you have Mac OS=
 X
>>>> Lion. And EAs is larger under Lion yet.
>>>> =

>>>> What version of Mac OS X have you?
>>>> =

>>> Yup, Mountain Lion v10.8.4 :)
>>> =

>> =

>> I suspect that xattrs with significant size is stored in compressed
>> state on HFS+. I implemented support of compressed xattrs partially but
>> I don't share this code yet. But, yes, EAs with size greater than 64 KB
>> can be a problem.


FYI, Example of output from one of the failing files. First from OS X and t=
hen same file after failed copy to XFS.

OS X Maverik:
file: "/Users/username/Pictures/iPhoto Library/Database/apdb/BigBlobs.apdb"
type: "\0\0\0\0"
creator: "\0\0\0\0"
attributes: avbstclinmedz
created: 01/25/2014 11:43:17
modified: 01/28/2014 20:02:46


Ubunutu =

getfattr: Removing leading '/' from absolute path names
# file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto Library/Datab=
ase/BigBlobs.apdb
user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94

>> =

>>> FYI, there have a couple of things regarding HFSPlus+xattr+acl on Linux=
 might be
>>> deserved to discuss together.
>>> =

>>> We once have a discussion about the errno in case of hit the limits of =
ACLs, which
>>> could be referred to:
>>> http://www.spinics.net/lists/linux-fsdevel/msg71125.html
>>> =

>>> HFSPlus return ENOMEM in this case, but it should be E2BIG as per Dave'=
s comments.
>>> I worked out a patch series includes HFSPlus, but not yet posted for so=
me reasons.
>>> =

>>> Also, it seems to me we'd better consolidate the errno for EA as well, =
that is to
>>> say, it's better to fix the return error to be consistent with VFS inte=
rface in case
>>> of the given EA name/value length is larger than the specified limits.
>>> =

>>> Would you like to take a look at the following two patches?
>>> =

>> =

>> Yes, sure. Patches looks correct and good for me. But did you take into
>> account recent significant changes of Christoph Hellwig? If so, then all
>> looks good.
> =

> Thanks for the review.  That's one major reason I postpone the patch set =
submission
> as I did it before Christoph's changes got merged, it looks like no obvio=
us conflicts
> with that, but I will find time to double check and sent it to you -- sti=
ll on vacation
> for Chinese Spring Festival.
> =

> Thanks,
> -Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
