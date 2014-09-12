Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A25747FA9
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 14:29:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81D32304062
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 12:29:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vYUU3YmlWHjmn1uy for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 12:29:45 -0700 (PDT)
Message-ID: <541349B1.1070007@sandeen.net>
Date: Fri, 12 Sep 2014 14:29:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
References: <535E8344.2070209@redhat.com>
In-Reply-To: <535E8344.2070209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>
Cc: Boris Ranto <branto@redhat.com>

On 4/28/14 11:35 AM, Eric Sandeen wrote:
> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
> to test for a shut down fs, lest we go down paths we'll
> never be able to complete; Boris reported that during some
> stress tests he had threads stuck in xlog_cil_force_lsn
> via xfs_dir_fsync().

(re-ping)

So Dave, you fixed this with:

So, you did solve the problem properly I guess, in 
commit ac983517ec5941da0c58cacdbad10a231dc4e001
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 7 08:05:50 2014 +1000

    xfs: don't sleep in xlog_cil_force_lsn on shutdown
    

But should my patch still go in, if only to be consistent
with file_fsync() paths?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
