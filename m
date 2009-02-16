Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1GHFlI2156798 for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 11:15:48 -0600
In-Reply-To: <20090215191614.GA862@infradead.org>
References: <49378B60.1060603@sgi.com> <20081222085354.GC24795@infradead.org>
	<49502F91.4050406@sgi.com> <49742371.2000806@sgi.com>
	<20090122222539.GA9643@infradead.org>
	<20090215191614.GA862@infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <F0F018EE-210F-4502-862B-4A9F6D085E17@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
Date: Mon, 16 Feb 2009 11:14:59 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Feb 15, 2009, at 1:16 PM, Christoph Hellwig wrote:

> On Thu, Jan 22, 2009 at 05:25:39PM -0500, Christoph Hellwig wrote:
>> On Mon, Jan 19, 2009 at 05:53:37PM +1100, Lachlan McIlroy wrote:
>>> Lachlan McIlroy wrote:
>>>> Christoph Hellwig wrote:
>>>>> Did you guys come to a conclusion in your discussions?
>>>>>
>>>> No conclusion, well nothing that resulted in an ack.
>>>
>>> Was anyone okay with this fix?
>>
>> I think it's okay to go.  It fixes the one off so it's go.
>>
>> The code is still a very hard to understand mess, but that's not what
>> the patch was supposed to fix..
>
> Any reason this isn't in yet?

Sorry, I was holding it. I had some doubts with the mod, but
couldn't materialize them into a real argument.
I guess, I just check it in (I saw your ACK some time ago, Christoph),
and deal with anything popping up in this area later.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
