Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ANL9FU082567 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 17:21:09 -0600
Message-ID: <49920CB5.1020103@sgi.com>
Date: Wed, 11 Feb 2009 10:24:37 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
References: <20090210194422.767988000@bombadil.infradead.org>	<20090210194515.509547000@bombadil.infradead.org>	<A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>	<20090210195756.GA7569@infradead.org>
	<1E52072E-CA98-430B-9B2F-FDD0FDD1A7A4@sgi.com>
In-Reply-To: <1E52072E-CA98-430B-9B2F-FDD0FDD1A7A4@sgi.com>
Reply-To: lachlan@sgi.com
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Felix Blyakher wrote:
> 
> On Feb 10, 2009, at 1:57 PM, Christoph Hellwig wrote:
> 
>> On Tue, Feb 10, 2009 at 01:56:31PM -0600, Felix Blyakher wrote:
>>> Isn't it a reworked Lachlan's patch:
>>>
>>> http://oss.sgi.com/archives/xfs/2009-02/msg00175.html
>>
>> The patch isn't related to that one at all,
> 
> ... from the implementation point of view, yes.
> 
>> but it aims to fix the
>> same issue.
> 
> That's what I meant.
> 
>> Should probably get a Reported-by: tag for him,
> 
> Seems reasonable.
> 
>> if
>> this is indeed the thing the original patch tried to fix.
> 
> That was my understanding. Let's Lachlan pitch in.
I'd prefer both fixes go in so we have maximum defence against
this problem happening again but I'm really not fussed.

> 
> Felix
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
