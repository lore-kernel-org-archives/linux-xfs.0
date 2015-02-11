Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CBDD7F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:22:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FB478F8035
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:22:19 -0800 (PST)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id 5GJLfdJQIzfL71Ci
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:22:17 -0800 (PST)
Received: by mail-pa0-f44.google.com with SMTP id kq14so4985586pab.3
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:22:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150210221914.GQ4251@dastard>
References: <54ca361b.6841460a.02cf.3cca@mx.google.com>
	<20150210221914.GQ4251@dastard>
Date: Wed, 11 Feb 2015 21:52:17 +0530
Message-ID: <CALJmpHNTXxt8dZ62JahCqB+E=_DkO310zksa81cSC81VbJCfbw@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfsprogs: Adding XFS_IOC_FIEMAPFS ioctl for use in
	xfs_spaceman
From: Dhruvesh Rathore <adrscube@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, Feb 11, 2015 at 3:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jan 29, 2015 at 07:01:02PM +0530, Dhruvesh Rathore wrote:
>>
>> This patch is concerned with the changes to be done in userspace code for
>> turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman
>> into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
>> fiemap insfrastructure.
>> By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
>> fiemap commands and allows us to review it and push it as we need, making the
>> process much simpler.
> .....
>>  typedef struct histent
>> @@ -201,9 +201,9 @@
>>               fiemap->fm_length = length;
>>               fiemap->fm_extent_count = NR_EXTENTS;
>>
>> -             ret = ioctl(file->fd, FS_IOC_FIEMAPFS, (unsigned long)fiemap);
>> +             ret = xfsctl(file->name,file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
>>               if (ret < 0) {
>   ^
> Patch hunk is corrupt: it is missing the leading whitespace to
> indicate "no change on this line".
>
> I've fixed it up to apply the patch.
>
> -Dave.

We again apologize for the constant white space errors. We will surely make
use of the various git commands that you have mentioned to ensure that we
send clean patches.
Thank you for reworking and applying the patches :)

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
