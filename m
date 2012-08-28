Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SCv4Pf097255 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 07:57:04 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	lSW22UKkKRo68VUl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Aug 2012 05:57:55 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so8031306obb.26
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 05:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503C07F4.2080706@sandeen.net>
References: <CAFZPdfjeDGXfhAP4hnnrdA6Fpr18pEq6vH726HpfduPp6vw3-A@mail.gmail.com>
	<503C07F4.2080706@sandeen.net>
Date: Tue, 28 Aug 2012 14:57:54 +0200
Message-ID: <CAFZPdfgfh_Qt5O452vgbAW4ZvLWcC839RRs_PdAtJ8=fR8ZN3w@mail.gmail.com>
Subject: Re: [PATCH] xfstests: Add test case to test xfs projid32bit
	functionality a bit more extensively.
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 28, 2012 at 1:51 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 8/27/12 5:04 AM, Boris Ranto wrote:
>>  The test covers several areas including enabling projid32bit functionality dynamically by xfs_admin, dumping, restoring, quota reporting and xfs_db projid values reporting.
>>  At the time of creation, the test hit two bugs: one for broken xfsdump/xfsrestore functionality and one for enabling projid32bit functionality with xfs_admin on a LVM device (SCRATCH_DEV must be an LVM device to hit this).
>
> FWIW, with a bit of investigation I think the lvm behavior may be an lvm bug.  IOW this should never happen;
> somehow buffered IO to the LVM device seems to be getting lost:
>
> # xfs_db -r -c version  /dev/mapper/vg-01-xfscratch
> versionnum [0xb4a4+0x8a] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
>
> # echo 3 > /proc/sys/vm/drop_caches
>
> # xfs_db -r -c version  /dev/mapper/vg-01-xfscratch
> versionnum [0xb4e4+0xa] = V4,NLINK,QUOTA,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT
>
> But I guess the test itself doesn't explicitly require lvm, so no big deal there.
>
> What is the point of using loopback during dump & restore?  Why not just dump to $tmp
> and restore to $SCRATCH_DEV, either after a fresh mkfs, or to a subdir of the existing
> filesystem?
>
> I get nervous about the loopback handling complexity....
>

I just wanted to keep the original data and compare them with diff.
The subdirectory dump will work fine, as well. I'll post the reworked
version of the patch, soon.

Boris

> -Eric
>
>> Signed-off-by: Boris Ranto <ranto.boris@gmail.com <mailto:ranto.boris@gmail.com>>
>> ---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
