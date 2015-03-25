Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0C2F7F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 03:47:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B4E0AC001
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 01:47:43 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	XwmOKIt3WG4YYI6A (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 01:47:42 -0700 (PDT)
Received: by wixw10 with SMTP id w10so28040506wix.0
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 01:47:41 -0700 (PDT)
Message-ID: <5512762A.2040604@plexistor.com>
Date: Wed, 25 Mar 2015 10:47:38 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
	<551153C4.6000808@plexistor.com> <20150324211740.GT28621@dastard>
In-Reply-To: <20150324211740.GT28621@dastard>
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

On 03/24/2015 11:17 PM, Dave Chinner wrote:
> On Tue, Mar 24, 2015 at 02:08:36PM +0200, Boaz Harrosh wrote:
<>
> 
> iter_file_splice_write() uses vfs_iter_write, which goes through
> ->write_iter, which we punt to the direct IO path for DAX.
> 

Cool real cool. What I thought too. Will send a patch to fix
and simplify ext2/4 ASAP. Its ready only still testing ...

> Cheers,
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
