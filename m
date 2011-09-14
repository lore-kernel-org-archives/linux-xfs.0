Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EFNZbu147608 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 10:23:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4971A1614DE
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:23:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id FBk29h2Uyu3SjAe5 for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2011 08:23:34 -0700 (PDT)
Message-ID: <4E70C6F8.3020906@sandeen.net>
Date: Wed, 14 Sep 2011 10:23:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaut in stage 6
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl>
	<20110912161215.GA17798@infradead.org>
	<4E707624.9030703@nasza-klasa.pl>
	<20110914142430.GA28049@infradead.org>
	<4E70C0C5.1080100@sandeen.net> <4E70C3CA.7010103@nasza-klasa.pl>
In-Reply-To: <4E70C3CA.7010103@nasza-klasa.pl>
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
To: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 9/14/11 10:10 AM, Bartosz Cisek wrote:
> W dniu 14.09.2011 16:57, Eric Sandeen pisze:
>> If it worked for Christoph and not for Bartosz ....
>>
>> Is the -DDEBUG / -DNDEBUG type setting the same in both cases?
>> Maybe Fedora is the only one doing -DNDEBUG :( but maybe worth
>> checking.
> 
> Tested both. I was wodering why I got 'value optimized out' in gdb, so
> compiled with DEBUG=-DNDBEUG and DEBUG=-DDEBUG. Both crashed, both had
> 'optimized out' values in gdb backtrace.
> 
> I found two placed where DEBUG may be overwritten:
> 
> hd-slave5 ~/devel/xfsprogs # ack-grep NDEBUG
> libxfs/Makefile
> 39:DEBUG = -DNDEBUG
> 
> libxlog/Makefile
> 16:DEBUG = -DNDEBUG
> 
> When I changed -DNDEBUG to -DDEBUG/ compilation failed.

yeah, that's why it's overridden in those places.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
