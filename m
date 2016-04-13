Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 047317CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:02:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40698AC005
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:30 -0700 (PDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id E5glkMEFVbgrcHPr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 21:02:24 -0700 (PDT)
Received: by mail-wm0-f52.google.com with SMTP id u206so53614866wme.1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:24 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <23e35813cb097c7b15686852500cbf97@mail.gmail.com>
	<20160412082759.GI9088@dastard>
	<5e9c99552ae829dce9eb574d72085323@mail.gmail.com>
	<20160412211619.GK567@dastard>
In-Reply-To: <20160412211619.GK567@dastard>
MIME-Version: 1.0
Date: Wed, 13 Apr 2016 09:32:23 +0530
Message-ID: <490d96538225fdaac2d1221081d2e5e4@mail.gmail.com>
Subject: RE: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error to
	get buf
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

Thanks Dave.

You are right that xfs_trans_read_buf_map() is initializing it but
xfs_imap_to_bp() being in the middle spoils it by passing its own local
bp.

--Shyam

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: 13 April 2016 02:46
To: Shyam Kaushik
Cc: xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error
to get buf

On Tue, Apr 12, 2016 at 11:10:13PM +0530, Shyam Kaushik wrote:
> Hi Dave,
>
> Your patch needs a minor correction.
>
> At start of xfs_iflush() either we must initialize "bp = NULL" or else
> xfs_imap_to_bp() when it hits an error need to set "*bpp = NULL".
> Otherwise with your patch we are having an uninitialized bp that
> corrupt_out is trying to do xfs_buf_relse().

Ok, I'll check that - I thought that xfs_trans_buf_read_map() was
initialising it to zero appropriately, but obviously I missed
something.

Thanks for testing!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
