Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFAAC29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:57:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6D538F8059
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 11:57:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1OeEX9x2NXUoDS5I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 11:57:12 -0800 (PST)
Subject: Re: [PATCH] xfsprogs: guard fsxattr definition for newer kernels
References: <56BA24A9.4090403@redhat.com> <20160209195502.GR27429@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56BA4495.9060304@redhat.com>
Date: Tue, 9 Feb 2016 13:57:09 -0600
MIME-Version: 1.0
In-Reply-To: <20160209195502.GR27429@dastard>
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

On 2/9/16 1:55 PM, Dave Chinner wrote:
> On Tue, Feb 09, 2016 at 11:40:57AM -0600, Eric Sandeen wrote:
>> After 334e580,
>> fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
>>
>> the file include/linux/fs.h now defines struct fsxattr.
>>
>> It defines FS_IOC_FSGETXATTR as well, so use that to wrap
>> our local definition, and skip it if the kernel is providing
>> it so that we don't get multiple definitions.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Should the kernel also #define HAVE_FSXATTR to help existing
>> xfsprogs-devel installations?
>>
>> (And what if headers are included in the other order?  Should
>> we try to guard on the kernel side or no?)
> 
> I've already sent a patch to fix this - it was with the foreign
> filesystem xfs_quota patch....

Oh, sorry, spaced it.

What do you think of the HAVE_FSXATTR definition in fs.h?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
