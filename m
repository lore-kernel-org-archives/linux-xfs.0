Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02DA87CD5
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 08:23:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C52478F8054
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 06:23:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m9pPT1vuLexwW1rl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 06:23:15 -0700 (PDT)
From: "Benjamin Coddington" <bcodding@redhat.com>
Subject: Re: [PATCH 2/2] abstract block export operations from nfsd layouts
Date: Fri, 08 Jul 2016 09:24:27 -0400
Message-ID: <EAD93DB0-20FD-4EC5-9232-F12671E21630@redhat.com>
In-Reply-To: <20160707223809.GH12670@dastard>
References: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
	<073be10a55e5e952adbfd320abcce075fb3958ae.1467889001.git.bcodding@redhat.com>
	<20160707223809.GH12670@dastard>
MIME-Version: 1.0
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 7 Jul 2016, at 18:38, Dave Chinner wrote:

> On Thu, Jul 07, 2016 at 07:02:32AM -0400, Benjamin Coddington wrote:
>> Instead of creeping pnfs layout configuration into filesystems, move the
>> definition of block-based export operations under a more abstract
>> configuration.
>>
>> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
>> ---
>>  fs/Kconfig          | 3 +++
>>  fs/nfsd/Kconfig     | 2 ++
>>  fs/xfs/Makefile     | 3 +--
>>  fs/xfs/xfs_export.c | 2 +-
>>  fs/xfs/xfs_pnfs.h   | 4 ++--
>>  5 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index 6725f59c18e6..6e57b4237d72 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -66,6 +66,9 @@ config FS_POSIX_ACL
>>  config EXPORTFS
>>  	tristate
>>
>> +config BLOCK_EXPORT_OPS
>> +	bool
>> +
>
> default n, help text?

Not set is n, and as it isn't visible or intended to be set by a user, I
left out the help text.  I'll add both for completeness.

> Also, BLOCK_* prefix config options are for block layer
> functionality, hence I suspect this will confuse people because it's
> a filesystem config option. EXPORTFS_BLOCK_OPS seems more obvious
> and correct to me, as the block mapping ops are part of the exportfs
> operations interface....

OK. I agree - that is better.

>>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
>> -xfs-$(CONFIG_NFSD_BLOCKLAYOUT)	+= xfs_pnfs.o
>> -xfs-$(CONFIG_NFSD_SCSILAYOUT)	+= xfs_pnfs.o
>> +xfs-$(CONFIG_BLOCK_EXPORT_OPS)	+= xfs_pnfs.o
>
> Why do we need the first patch to XFS anymore? Just convert it
> straight to using CONFIG_EXPORTFS_BLOCK_OPS....

Doing this in a single patch would combine two changes in a single commit:
 - the definition of the extra operations for a config of only SCSI_LAYOUT
 - the addition of CONFIG_EXPORTFS_BLOCK_OPS.

Since the first is the originally intended behavior, and the second fixes it
up, I'll just send it along in a single patch if that's preferred.

Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
