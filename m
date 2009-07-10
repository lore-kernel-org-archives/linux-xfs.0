Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ALEXZu123105 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:14:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 440B8A32B29
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 14:22:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id tJUs2kjY6ljXHPCy for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 14:22:20 -0700 (PDT)
Message-ID: <4A57AF5D.6080603@sandeen.net>
Date: Fri, 10 Jul 2009 16:15:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com>
	<4A56D176.9010702@sandeen.net>	<4A56ED5F.10400@gmail.com>
	<4A57A1C4.40004@sandeen.net> <4A57AC69.7070502@gmail.com>
In-Reply-To: <4A57AC69.7070502@gmail.com>
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
To: Tomek Kruszona <bloodyscarion@gmail.com>
Cc: xfs@oss.sgi.com

Tomek Kruszona wrote:
> Eric Sandeen wrote:
>> This looks like some of the caching that xfs_repair does is mis-sized,
>> and it gets stuck when it's unable to find a slot for a new node to
>> cache.  IMHO that's still a bug that I'd like to work out.  If it gets
>> stuck this way, it'd probably be better to exit, and suggest a larger
>> hash size.
>>
>> But anyway, I forced a bigger hash size:
>>
>> xfs_repair -P -o bhash=1024 <blah>
>>
>> and it did complete.  1024 is probably over the top, but it worked for
>> me on a 4G machine w/ some swap.
> :D
> 
> Is it safe to use xfs_repair without this options after the FS was
> repaired? Or maybe I should use them every time I have similar problem?


These are all good questions ;)  TBH I'm kind of digging through repair
in earnest for the first time.  I'm not certain why it got into this
state, whether there is some underlying bug, perhaps leaving things
wrongly referenced, or just a plain ol' mis-sizing of the caches.

I have a patch now that ends like this; if all else fails at least it'd
not spin forever, and give a hint of what to try.

-Eric

...

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
unknown magic number 0 for block 8388608 in directory inode 40541
rebuilding directory inode 40541
unknown magic number 0 for block 8388608 in directory inode 48934
rebuilding directory inode 48934
unknown magic number 0 for block 8388608 in directory inode 56139
rebuilding directory inode 56139
unknown magic number 0 for block 8388608 in directory inode 63785
rebuilding directory inode 63785
Unable to free any items in cache for new node; exiting.
Try increasing the bhash and/or ihash size beyond 64
cache: 0x190ed4d0
Max supported entries = 512
Max utilized entries = 512
Active entries = 512
Hash table size = 64
Hits = 130779
Misses = 271155
Hit ratio = 32.54
MRU 0 entries =      0 (  0%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   2 entries      2 (  0%)
Hash buckets with   3 entries      2 (  1%)
Hash buckets with   4 entries      4 (  3%)
Hash buckets with   5 entries      1 (  0%)
Hash buckets with   6 entries      8 (  9%)
Hash buckets with   7 entries      9 ( 12%)
Hash buckets with   8 entries      9 ( 14%)
Hash buckets with   9 entries     10 ( 17%)
Hash buckets with  10 entries      9 ( 17%)
Hash buckets with  11 entries      6 ( 12%)
Hash buckets with  12 entries      1 (  2%)
Hash buckets with  13 entries      2 (  5%)
Hash buckets with  14 entries      1 (  2%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
