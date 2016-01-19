Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66F3E7F37
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 18:31:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 575CC8F8040
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 16:31:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id faCSfGJmv3iTtcz1 for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2016 16:31:51 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7BE8C63737DD
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 18:31:51 -0600 (CST)
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net> <20160111162807.GK6262@quack.suse.cz>
	<5696D27A.9070700@sandeen.net> <20160115093507.GA15950@quack.suse.cz>
	<56992CD4.6030408@sandeen.net> <20160118103302.GD6850@quack.suse.cz>
	<569D0238.5060407@sandeen.net> <20160118154038.GE6850@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <569D83F6.6090300@sandeen.net>
Date: Mon, 18 Jan 2016 18:31:50 -0600
MIME-Version: 1.0
In-Reply-To: <20160118154038.GE6850@quack.suse.cz>
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
To: xfs@oss.sgi.com



On 1/18/16 9:40 AM, Jan Kara wrote:
> On Mon 18-01-16 09:18:16, Eric Sandeen wrote:
>> On 1/18/16 4:33 AM, Jan Kara wrote:
>>> On Fri 15-01-16 11:31:00, Eric Sandeen wrote:
>>
>> ...
>>
>>>> For a purpose-built interface of "find the next ID" that wouldn't require any
>>>> structure or interface changes...
>>>>
>>>> We could name it Q_GETNEXTQUOTA / Q_XGETNEXTQUOTA to make it explicit about
>>>> the purpose, and document that return behavior.  Done & done.  ;)
>>>>
>>>> A new grand unified extensible quota call sounds like a great idea, I just
>>>> hate to gate this work on designing a brand-new interface.
>>>
>>> OK, ok. I like Dave's proposal for quotactl2(). So let's leave the unification
>>> for later and implent Q_GETNEXTQUOTA and Q_XGETNEXTQUOTA with the
>>> functionality of your original Q_XGETQUOTA2. Having separate call to get
>>> next ID would save us one new quotactl but OTOH we would need two syscalls
>>> (and quota structure lookups) to report one structure and there are
>>> potentially *lots* of them.
>>
>> Ok, I can re-do it with the new Q_[X]GETNEXTQUOTA names, I've already done
>> the non-xfs one as well, just starting testing on that.
>>
>> With or without the flags argument?
> 
> Without. For further extensibility I'd really go for the unified API in the
> end.

Thanks.  I'll get new patches out in a bit, putting some polish on them and
the userspace, and seeing about a regression test as well.

Realized I need to think semi-carefully about what we do for IDs found on
disk but not in the user database; today I think extN will show everything;
XFS only shows IDs in the DB, unless an ID range is specified - probably
need to keep all behavior the same, without some explicit commandline switches
to do differently.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
