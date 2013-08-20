Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CD597FDB
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 16:26:03 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D98D6AC001
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 14:26:02 -0700 (PDT)
Message-ID: <5213DF1A.20600@sgi.com>
Date: Tue, 20 Aug 2013 16:26:50 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com>
In-Reply-To: <20130816205409.976658624@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Looks good there than the one typo below.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
The result from the lseek() call will be printed to the output.
For example:

xfs_io> lseek -h 609k
         ^

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
