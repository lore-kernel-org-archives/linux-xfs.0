Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 563087F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 18:04:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DE7FAC006
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 16:04:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S4kHTymz6sMNBkE5 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 16:04:50 -0800 (PST)
Message-ID: <53166A20.4040109@sandeen.net>
Date: Tue, 04 Mar 2014 18:04:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 00/13] xfsprogs: initial EFSBADCRC support
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/4/14, 2:51 AM, Dave Chinner wrote:
> Hi Folks,
> 
> This series is a userspace port of Eric's EFSBADCRC verifier error
> discrimination patch set. It brings across all the relevant pathes
> form the kernel code and shoe-horns them into the libxfs codebase.
> There are two extra patches on the end of the series - one to make
> xfs_db use EFSBADCRC for it's CRC validity indication, and the other
> to make xfs_repair detect and handle primary superblock CRC failures
> and recalculation when the primary superblock is rebuilt and
> rewritten.
> 
> This is the first step in bring full awareness of CRC errors into
> xfs_repair. More patches will follow as I make more repair code
> aware that EFSBADCRC means that the object that was just read
> needs repair.

You can slap:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

on the first 11 of these anyway.

(or maybe we should swap SOB/RB, and add a new Userspace-ported-by ;))

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
