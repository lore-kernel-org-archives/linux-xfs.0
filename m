Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBO2AhY0031035 for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 20:10:43 -0600
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBDFB4472E
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 18:10:39 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with
	ESMTP id FkGt05BiJIAcwJYR for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2008 18:10:39 -0800 (PST)
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and	buffered
	I/O with DMAPI]
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
	<493DFDBD.7060909@sgi.com> <20081209092240.GA23915@infradead.org>
	<20081222085311.GB24795@infradead.org> <49503378.2080508@sgi.com>
	<20081223084013.GA7604@infradead.org> <49518BF2.2020709@sgi.com>
Date: Wed, 24 Dec 2008 13:10:20 +1100
In-Reply-To: <49518BF2.2020709@sgi.com> (Lachlan McIlroy's message of "Wed, 24
	Dec 2008 12:10:10 +1100")
Message-ID: <87wsdq727n.fsf@cxhome.ath.cx>
MIME-Version: 1.0
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
To: lachlan@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy <lachlan@sgi.com> writes:

> Christoph Hellwig wrote:
>
>> On Tue, Dec 23, 2008 at 11:40:24AM +1100, Lachlan McIlroy wrote:
>>> Christoph Hellwig wrote:
>>>> Do you need more input on this one?
>>> Actually I just might.  Based on your last reponse I wasn't sure if
>>> you wanted me to make further changes.
>> 
>> Well, my reponse was that I think we could do it more effecient, but the
>> patch still looks correct to me.
> Okay great.  I'll check it in and we can improve it later when I understand
> what you meant!
>
>> 
>>> Then I got side-tracked wondering
>>> why we even have the 'goto retry' in the dmapi post event - why retry the
>>> write if we get ENOSPC when we don't if dmapi is not enabled?  Could the
>>> write get stuck in an infinite loop?
>> 
>> We only retry on ENOSPC if the dmapi nospace even is enabled, or am I
>> missing something?
> I don't think you're missing anything here.  I don't understand how the
> DMAPI stuff works but I imagined the event was there to indicate that the
> write failed but what I don't understand is why that justifies a retry.
> Is there something about DMAPI that needs the write to succeed?

yes

http://www.opengroup.org/onlinepubs/9657099/chap3.htm#tagcjh_04_02_04


-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
