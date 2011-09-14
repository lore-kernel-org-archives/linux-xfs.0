Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EEv9uD146509 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 09:57:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72EA21611D9
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 07:57:08 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Fht7fumvJlxfB4G7 for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2011 07:57:08 -0700 (PDT)
Message-ID: <4E70C0C5.1080100@sandeen.net>
Date: Wed, 14 Sep 2011 09:57:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaut in stage 6
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl>
	<20110912161215.GA17798@infradead.org>
	<4E707624.9030703@nasza-klasa.pl>
	<20110914142430.GA28049@infradead.org>
In-Reply-To: <20110914142430.GA28049@infradead.org>
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
Cc: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 9/14/11 9:24 AM, Christoph Hellwig wrote:
> On Wed, Sep 14, 2011 at 11:38:44AM +0200, Bartosz Cisek wrote:
>> W dniu 12.09.2011 18:12, Christoph Hellwig pisze:
>>> I've repaired the image fine using xfs_repair from the Debian testing
>>> xfsprogs 3.1.5+nmu1 package.  It found two invalid blocks in a
>>> directory, which look like the result from the hardware error you saw.
>>>
>>> You should be able to just rebuild the current xfsprogs (from
>>> testing/unstable or git) on Lenny and get the same result.
>>
>> I've build xfs_repair from git on lenny and got segfault before my first
>> email to this list (please refer to first email in this thread) :)
> 
> Ooops.
> 
>> What else I can do to find what differ our two cases?
> 
> The hardware?  Given that you were getting read I/O errors from the
> hardware when shutting the fs down you probably got those as well when
> running repair and that caused the segfault.   Can you run xfs_repair
> under gdb for me, that is:
> 
> gdb /path/to.xfs_repair
> 
> (gdb) set args /dev/cciss/c0d5p1
> (gdb) run
> 
> and see what backtrace it gives you?
> 
> Please make sure to build xfs_repair in the git tree manually using
> make and not the Debian packaging, as that removes the debug symbols.
> 
> You can run gdb on the xfs_repair binary just built in the tree, no
> need to install it first.

If it worked for Christoph and not for Bartosz ....

Is the -DDEBUG / -DNDEBUG type setting the same in both cases?
Maybe Fedora is the only one doing -DNDEBUG :( but maybe worth
checking.

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
