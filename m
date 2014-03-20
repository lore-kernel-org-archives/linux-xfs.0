Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50BDF7F63
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2014 15:30:30 -0500 (CDT)
Message-ID: <532B4FE2.30505@sgi.com>
Date: Thu, 20 Mar 2014 15:30:26 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: free the EFI entries from AIL on forced shutdown
References: <20140314163723.916178776@sgi.com> <20140317052951.GE7072@dastard>
	<532B45E1.3060309@sgi.com>
In-Reply-To: <532B45E1.3060309@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/20/14 14:47, Mark Tinguely wrote:
> On 03/17/14 00:29, Dave Chinner wrote:

>
>> The only case we
>> then have to handle specially is the xfs_trans_reserve failure in
>> xfs_bmap_finish(), where we need to release the EFI directly in the
>> error path.
>
> any reason to not move the efd creation earlier to not special case it?

Umm, other than no ticket or space for the log_item. Never mind, we have 
to special case it.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
