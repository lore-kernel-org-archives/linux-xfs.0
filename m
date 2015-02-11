Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A1297F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:19:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23E54AC004
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:19:31 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id ot4hXldRZzTkZoeb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:19:29 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id fa1so4995955pad.2
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150210101752.GB12722@dastard>
References: <54ca35b7.2786440a.6990.450d@mx.google.com>
	<20150210101752.GB12722@dastard>
Date: Wed, 11 Feb 2015 21:49:29 +0530
Message-ID: <CALJmpHOZKR4sDceZYq4MLpaej1pDE4KdT1dMvt+d6aw+Que=1g@mail.gmail.com>
Subject: Re: [PATCH 3/4] xfs: Adding XFS_IOC_FIEMAPFS ioctl for use in
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

On Tue, Feb 10, 2015 at 3:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jan 29, 2015 at 06:59:22PM +0530, Dhruvesh Rathore wrote:
>>
>> This patch is concerned with the changes to be done in kernel space code for
>> turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman
>> into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
>> fiemap insfrastructure.
>> By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
>> fiemap commands and allows us to review it and push it as we need, making the
>> process much simpler.
>>
>> ----------------------------------------------------------------------------------------
>>
>> Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
>> Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
>> Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
>> ---
>> fs/ioctl.c            | 3  ++-
>> include/linux/fs.h    | 6  ++++++
>> fs/xfs/xfs_ioctl.c    | 55 +++++++++++++
>> fs/xfs/xfs_fs.h               | 1  +
>> 4 files changed, 64 insertions(+), 1 deletion(-)
>
> Ok, so this patch doesn't remove any of the now unused
> functionality I added to support the VFS based ioctl.
>
> What I'm going to do with this is combine it with the initial
> "introduce FS_IOC_FIEMAP" patch I wrote (including all it's
> documentation!) as the first patch of the kernel side patch series
> to introduced XFS_IOC_FIEMAPFS.
>

Seems appropriate to us.

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
