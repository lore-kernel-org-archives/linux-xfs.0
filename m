Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 898597F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 12:13:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BCF9AC005
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 10:13:33 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id TnnEl4PMLYB2ujXx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 10:13:32 -0700 (PDT)
In-Reply-To: <20140618120124.GR9508@dastard>
References: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
	<20140618120124.GR9508@dastard>
MIME-Version: 1.0
Subject: Re: log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f
From: Christian Kujau <lists@nerdbynature.de>
Date: Wed, 18 Jun 2014 10:13:23 -0700
Message-ID: <e2537966-9b06-45eb-b2c7-dd5cffa968dd@email.android.com>
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



On June 18, 2014 5:01:24 AM PDT, Dave Chinner <david@fromorbit.com> wrote:
>Yes, that's the only way to safely move a filesystem between
>machines of different endianness - a clean log has nothing to
>replay, so no endian problems and all new records will be written
>according to the endianness of the host the filesystem is currently
>mounted on.

OK, thanks for explaining that.

When the PowerPC box crashed there should not have been any i/o on the file system - so, if there was nothing to commit, clearing the log with "xfs_repair -L" should not lose any data, right?

Christian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
