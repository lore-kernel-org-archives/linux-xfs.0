Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMEttHT027842 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:55:56 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E68E0176FA94
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:55:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id NoUV8iB6HDXMW5fk for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2008 06:55:53 -0800 (PST)
Message-ID: <494FAA58.7070605@sandeen.net>
Date: Mon, 22 Dec 2008 08:55:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: couple small xfstest patches
References: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
	<20081222130824.GC12367@infradead.org>
In-Reply-To: <20081222130824.GC12367@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Nov 21, 2008 at 01:45:23PM -0800, Matthew Kent wrote:
>> * 189 fails with external devices
>> * add a unified diff output option, find it easier on the eyes ;)
> 
> Thanks, I'll put these into my queue.  Question to the list:  any
> arguments against just making unified diffs the default for xfsqa
> output?

none here; I run patched that way already.

>> Thanks!
>> -- 
>> Matthew Kent <mkent@magoazul.com>
>> http://magoazul.com
>> --- xfs-cmds/xfstests/common.orig	2008-11-21 13:19:47.000000000 -0800
>> +++ xfs-cmds/xfstests/common	2008-11-21 13:22:04.000000000 -0800
>> @@ -107,7 +107,7 @@
>>      -nfs                test NFS
>>      -l			line mode diff (default)
>>      -xdiff		graphical mode diff
>> -    -diffu		show unified diff
>> +    -udiff		show unified diff
>>      -n			show me, do not run tests
>>      -q			quick [deprecated]
>>      -T			output timestamps
>> @@ -158,7 +158,7 @@
>>  	    fi
>>  	    ;;
>>  
>> -	-diffu)	# show unified diff
>> +	-udiff)	# show a unified diff
>>  	    xpand=false
>>  	    diff="$diff -u"
>>  	    ;;
>> --- xfs-cmds/xfstests/189.orig	2008-11-21 13:43:33.000000000 -0800
>> +++ xfs-cmds/xfstests/189	2008-11-21 13:42:48.000000000 -0800
>> @@ -188,8 +188,8 @@
>>  _need_to_be_root
>>  _require_scratch
>>  
>> -unset SCRATCH_OPTIONS
>> -unset MOUNT_OPTIONS
>> +unset SCRATCH_RTDEV
>> +unset SCRATCH_LOGDEV
>>  
>>  _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
>>  
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> ---end quoted text---
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
