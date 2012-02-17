Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HFR7GB090759 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 09:27:07 -0600
Received: from seldrel01.sonyericsson.com (seldrel01.sonyericsson.com
	[212.209.106.2]) by cuda.sgi.com with ESMTP id BEEXrv7mQsPEu6Td
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Feb 2012 07:27:04 -0800 (PST)
From: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Date: Fri, 17 Feb 2012 16:27:02 +0100
Subject: Re: XFS memory recomendation?
Message-ID: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722DA4@seldmbx01.corpusers.net>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<20120217024941.GH14132@dastard> <1410714.dziNWBeyu6@saturn>
In-Reply-To: <1410714.dziNWBeyu6@saturn>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "michael.monnerie@is.it-management.at" <michael.monnerie@is.it-management.at>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for the answer Dave and Michael.

As you might realize, I have no knowledge if the internal works of
XFS :-P 

My problem is that the file system sometimes seems to be a bit laggy
when listing directories and so on. I really don't know how to deal with
it. I guess more memory always will help but where should I put the
limit?

Can it be a solution (ugly) to warm up the cache by making a complete
"find" on the file system sending output to /dev/null? but then again it
would probably be a stupid way to use precious memory for something that
isn't used that often.

--
Emil


fre 2012-02-17 klockan 14:05 +0100 skrev Michael Monnerie:
> Am Freitag, 17. Februar 2012, 13:49:41 schrieb Dave Chinner:
> > What's a "file allocation table"? XFS doesn't have one.
> 
> I guess he means the inode/dentry cache and such.
> 
> BTW, what's the difference of inode and dentry caches? I'd like to 
> understand the setting of
> /proc/sys/vm/vfs_cache_pressure
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
