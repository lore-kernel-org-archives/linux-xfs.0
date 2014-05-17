Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7486A7F3F
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 05:54:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11408AC001
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 03:54:03 -0700 (PDT)
Received: from b.painless.aa.net.uk (b.painless.aa.net.uk [81.187.30.52]) by
	cuda.sgi.com with ESMTP id RdhJ4FdiiiggRR2x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 17 May 2014 03:54:01 -0700 (PDT)
From: Adam Sampson <ats@offog.org>
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
References: <20140516055650.GF26353@dastard>
	<y2a8uq11g5k.fsf@cartman.at.offog.org>
	<20140517002309.GA18954@dastard>
Date: Sat, 17 May 2014 11:53:08 +0100
In-Reply-To: <20140517002309.GA18954@dastard> (Dave Chinner's message of "Sat,
	17 May 2014 10:23:09 +1000")
Message-ID: <y2a4n0o1xt7.fsf@cartman.at.offog.org>
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
Cc: xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> [...] it's preferable to have things like xfs_repair abort when it
> comes across an inconsistency it can't handle than to continue blindly
> along and making a bigger mess of the filesystem it's supposed to be
> fixing...

Yes -- that's why I was building with DEBUG= on previous releases
(i.e. I want assertions enabled). doc/INSTALL says that DEBUG=-DNDEBUG
disables assertions, so packagers are quite likely to have DEBUG= in
their build process.

> Anyway, we'll look to fix it for 3.2.1.

Cheers. :)

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
