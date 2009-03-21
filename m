Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2LMD5iA018599 for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 17:13:25 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 276701B50EC
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 15:12:25 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id PTaAfXFge1vrdKQq for <xfs@oss.sgi.com>;
	Sat, 21 Mar 2009 15:12:25 -0700 (PDT)
Message-ID: <49C5663A.7010403@sandeen.net>
Date: Sat, 21 Mar 2009 17:12:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add test 203, xfs_io bmap reallocation
References: <20090320072857.GB26571@infradead.org>	<49C4632D.2050901@sandeen.net>
	<20090321200215.GA8568@infradead.org>
In-Reply-To: <20090321200215.GA8568@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomasz Majkowski <moosh009@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Mar 20, 2009 at 10:46:53PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> Test that we can get all extent/hole information for files with more
>>> than 16 extents and 15 holes which require a reallocation based on
>>> XFS_IOC_FSGETXATTR.
>>>
>>> Based on a testcase from Tomasz Majkowski <moosh009@gmail.com>.
>>>
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Looks fine to me (do we need a GPL header on the c file?  license on all
>> of xfsqa is hard to sort out, I guess...)
> 
> There's no c file.

Oh, heh.  I had Tomasz's original testcase in mind, sorry! :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
