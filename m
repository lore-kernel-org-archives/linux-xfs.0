Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B1007F5A
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:11:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9B10304051
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:11:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bo53R02kavKDNhea for
	<xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:11:08 -0800 (PST)
Message-ID: <512E9285.30005@redhat.com>
Date: Wed, 27 Feb 2013 17:11:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com> <20130227230443.GB5551@dastard>
In-Reply-To: <20130227230443.GB5551@dastard>
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
Cc: xfstests <xfs@oss.sgi.com>, list.btrfs@jan-o-sch.net, linux-btrfs@vger.kernel.org, Wang Sheng-Hui <shhuiw@gmail.com>

On 2/27/13 5:04 PM, Dave Chinner wrote:
> On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
>> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
>> -x option of filefrag, and will fail with
>> 	'FIBMAP: Invalid argument'
>> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>>     'FIEMAP failed with unsupported flags 2'
>> Remove the '-x' option.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> I can see that this changes what gets dumped into the $seq.full
> file, but it seems to me that also changes the extent list returned
> to the checking functions. So either the test previously worked and
> now it fails with this change, or the test never worked and now it
> does, or perhaps something else?

Agreed - I wondered as well.

> IOWs, I can't tell why you want to change this from the patch
> description, hence I don't know if the original behaviour was
> intentional or not.  Can you say describe what the overall effect of
> the change is in the commit description?

It looks like -x is only recently rejected:

commit 05dadc09f52ad5a631da1aa8767c5b80e121f0c4
Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date:   Thu Nov 29 05:08:26 2012 +0000

    Btrfs: add fiemap's flag check

+#define BTRFS_FIEMAP_FLAGS     (FIEMAP_FLAG_SYNC)

+       ret = fiemap_check_flags(fieinfo, BTRFS_FIEMAP_FLAGS);

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
