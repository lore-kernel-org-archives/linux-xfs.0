Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CCC27F55
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 07:29:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FDB08F8064
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 05:29:41 -0800 (PST)
Received: from radon.swed.at (b.ns.miles-group.at [95.130.255.144]) by
	cuda.sgi.com with ESMTP id RuiPFMiabhH7ozBm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 05:29:39 -0800 (PST)
Message-ID: <52FE1A3A.9090301@nod.at>
Date: Fri, 14 Feb 2014 14:29:30 +0100
From: Richard Weinberger <richard@nod.at>
MIME-Version: 1.0
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
References: <20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140212214411.GQ18016@ZenIV.linux.org.uk>
	<20140213205146.GS18016@ZenIV.linux.org.uk>
	<20140214132503.GA23265@infradead.org>
In-Reply-To: <20140214132503.GA23265@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>

Am 14.02.2014 14:25, schrieb Christoph Hellwig:
> On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
>> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
>>
>>> I'll try to put something along those lines together, if you or Oleg don't
>>> do it first.
>>
>> OK, having looked at that stuff...
>>
>> 1) things become much more compact if we finish conversion to get_signal()
>> first.
> 
> I have vague memories that Richard sent out a series to convert over all
> architectures a while ago.  Hopefully he has better memory than I do.

Yeah. Sending v2 of that series is on my overflowing TODO list. :-\
I think this is a good reason for me to start working on that series again.
Stay tuned.

Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
