Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 345807F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 09:35:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4F52AC006
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 07:35:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I4FGDWV8Qpr6hggP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 07:35:55 -0800 (PST)
Subject: Re: [PATCH, RFC] mkfs: get sector size from host fs dev when mkfs'ing
	file
References: <5660CD5E.2040209@redhat.com> <20151214012712.GL26718@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <566EE1DA.9090404@redhat.com>
Date: Mon, 14 Dec 2015 09:35:54 -0600
MIME-Version: 1.0
In-Reply-To: <20151214012712.GL26718@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12/13/15 7:27 PM, Dave Chinner wrote:
...

> So the current behaviour is to use the underlying filesystem
> sector size, but we might have a 4k fs sector on a 512 physical
> sector device, and you want to detect this, right? The logical
> sector size is exposed by the filesystem in the XFS_IOC_DIOINFO
> information. i.e:
> 
>         case XFS_IOC_DIOINFO: {
>                 struct dioattr  da;
>                 xfs_buftarg_t   *target =
>                         XFS_IS_REALTIME_INODE(ip) ?
>                         mp->m_rtdev_targp : mp->m_ddev_targp;
> 
>                 da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
>                 da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> 
>                 if (copy_to_user(arg, &da, sizeof(da)))
>                         return -EFAULT;
>                 return 0;
>         }
> 
> Isn't this exactly what XFS_IOC_DIOINFO is for?

Oh, right.  SO MANY INTERFACES.  ;)

But sure, that makes more sense, thanks for the reminder.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
