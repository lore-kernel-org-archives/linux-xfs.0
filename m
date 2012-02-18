Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1I1FWro123984 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 19:15:32 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cYEJgCnwIY0Cudf0 for
	<xfs@oss.sgi.com>; Fri, 17 Feb 2012 17:15:31 -0800 (PST)
Message-ID: <4F3EFB75.5040404@redhat.com>
Date: Fri, 17 Feb 2012 17:14:29 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS memory recomendation?
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<20120217024941.GH14132@dastard> <1410714.dziNWBeyu6@saturn>
	<2BF070A7A2375D46BA1B6087F8D5DCB68BEA722DA4@seldmbx01.corpusers.net>
In-Reply-To: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722DA4@seldmbx01.corpusers.net>
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
To: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Cc: "michael.monnerie@is.it-management.at" <michael.monnerie@is.it-management.at>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2/17/12 7:27 AM, Assarsson, Emil wrote:
> Thanks for the answer Dave and Michael.
> 
> As you might realize, I have no knowledge if the internal works of
> XFS :-P 
> 
> My problem is that the file system sometimes seems to be a bit laggy
> when listing directories and so on. 

This would have been a better starting point for your question. :)

> I really don't know how to deal with
> it. I guess more memory always will help but where should I put the
> limit?

How slow is slow?  What kernel are you using, and what does your storage
look like?  How many files are in the directory?  How much memory do you
have, and what else is going on in the system at the time?

I think you'll need to quantify it a bit more.

-Eric

> Can it be a solution (ugly) to warm up the cache by making a complete
> "find" on the file system sending output to /dev/null? but then again it
> would probably be a stupid way to use precious memory for something that
> isn't used that often.
> 
> --
> Emil
> 
> 
> fre 2012-02-17 klockan 14:05 +0100 skrev Michael Monnerie:
>> Am Freitag, 17. Februar 2012, 13:49:41 schrieb Dave Chinner:
>>> What's a "file allocation table"? XFS doesn't have one.
>>
>> I guess he means the inode/dentry cache and such.
>>
>> BTW, what's the difference of inode and dentry caches? I'd like to 
>> understand the setting of
>> /proc/sys/vm/vfs_cache_pressure
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
