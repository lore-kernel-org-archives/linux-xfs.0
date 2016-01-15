Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BBBB7F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 11:31:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EACAB8F8035
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 09:31:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id j595OGlTQ9NTmFob for <xfs@oss.sgi.com>;
	Fri, 15 Jan 2016 09:31:01 -0800 (PST)
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net> <20160111162807.GK6262@quack.suse.cz>
	<5696D27A.9070700@sandeen.net> <20160115093507.GA15950@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56992CD4.6030408@sandeen.net>
Date: Fri, 15 Jan 2016 11:31:00 -0600
MIME-Version: 1.0
In-Reply-To: <20160115093507.GA15950@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Eric Sandeen <sandeen@redhat.com>

Hi Jan -

On 1/15/16 3:35 AM, Jan Kara wrote:
> On Wed 13-01-16 16:40:58, Eric Sandeen wrote:
>> On 1/11/16 10:28 AM, Jan Kara wrote:

...

>>> Actually, what I want from you is just an interface which is usable for VFS
>>> quotas as well since I'd like to avoid adding GETQUOTA2 quotactl shortly
>>> after XGETQUOTA2 :).
>>
>> Actually, that's exactly what I thought would *need* to happen ... we already
>> have this weird 15-year-old split-brain quota interface, so if xfs and ext4
>> both need the same functionality, then we'd probably add both GETQUOTA2 and
>> XGETQUOTA2.  If we were doing this all from scratch, sure, but adding a new
>> handles-both-quota-types interface when every other operation is already split
>> between the two almost seems to make matters worse.
> 
> Well, currently GETQUOTA and XGETQUOTA (and all the other quotactls) are
> actually translated so they work regardless of the underlying filesystem.
> So the only difference between XFS and VFS quotactls is in the formatting
> of input/output structures. So from kernel POV it seems somewhat pointless
> to add two calls doing the same thing and differing just in the formatting
> of output - especially when we want the call to be extensible.
> 
> I agree that having a unified call means having a new structure for passing
> dquot info between kernel and userspace. So just for adding that one small
> feature you want it seems like an overkill. But when thinking about new
> extensible getquota quotactl it IMHO makes sense to unify the VFS/XFS split
> brain. Thoughts?

My first lazy/hacky thought is "how terrible would it be to overload the
quotactl syscall return value with quota ID for Q_GETQUOTA2 calls?"

For a purpose-built interface of "find the next ID" that wouldn't require any
structure or interface changes...

We could name it Q_GETNEXTQUOTA / Q_XGETNEXTQUOTA to make it explicit about
the purpose, and document that return behavior.  Done & done.  ;)

A new grand unified extensible quota call sounds like a great idea, I just
hate to gate this work on designing a brand-new interface.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
