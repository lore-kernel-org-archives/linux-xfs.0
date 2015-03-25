Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10D347F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 04:14:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A53B9AC001
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 02:14:25 -0700 (PDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id 4HsHDmVDtpBFnuvM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Mar 2015 02:14:20 -0700 (PDT)
Received: by wgs2 with SMTP id 2so19702742wgs.1
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 02:14:19 -0700 (PDT)
Message-ID: <55127C69.2000207@plexistor.com>
Date: Wed, 25 Mar 2015 11:14:17 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 8/8] xfs: add initial DAX support
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-9-git-send-email-david@fromorbit.com>
	<55115E20.7090105@plexistor.com> <20150324212550.GU28621@dastard>
In-Reply-To: <20150324212550.GU28621@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On 03/24/2015 11:25 PM, Dave Chinner wrote:
<>
> 
> No, I don't see any reason for a mount flag for this, because we
> do not want to be stuck relying on a mount option forever. Once
> This code has been shaken out, I fully intend DAX to be turned on
> automatically for any device that supports, and for it to be turned
> on and off on a per-inode basis through on-disk inode flags. i.e.
> the mount option is really a temporary solution and I don't want to
> code in any dependencies on DAX being mount wide existing.
> 

OK I dropped this flag. I will just check for the direct_access
vector. I'll need a wrapper that defines to nothing in the
!CONFIG_FS_DAX case

> Cheers,
> Dave.
> 

Thanks for your help
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
