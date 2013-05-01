Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 52CEF7F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:58:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D414BAC003
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 13:58:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id o2vH338JYFkFlvUs for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 13:58:10 -0700 (PDT)
Message-ID: <518181E1.2000604@sandeen.net>
Date: Wed, 01 May 2013 15:58:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Weird message from xfs_repair
References: <20130501200633.5d24caf5@galadriel.home>
	<20130501194320.GP29359@sgi.com>
In-Reply-To: <20130501194320.GP29359@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/1/13 2:43 PM, Ben Myers wrote:
> Hi Emmanuel,
> 
> On Wed, May 01, 2013 at 08:06:33PM +0200, Emmanuel Florac wrote:
>> I've just had to resort to the latest devel version of xfs_repair to
>> get back some heavily damaged filesystem (thanks to a failing RAID
>> controller), and it ended with the following message:
>>
>> cache_purge: shake on cache 0x672030 left 1 nodes!?
>>
>> What's this about? I didn't look at the source, but a new run of
>> xfs_repair detected nothing. 
> 
> xfs_repair/libxfs has caches for xfs_bufs and inodes to speed things up.
> cache_purge is trying to flush out all entries from one of those caches.  After
> the purge one entry was left unexpectedly, maybe because someone leaked a
> reference on it or something.  The message doesn't indicate an on-disk problem,
> it's a problem in xfs_repair.

Several of those internal cache housekeeping messages can be
alarming.  Indeed anything out of the ordinary during repair
is alarming to most users.  ;)

At any rate they're completely useless to the administrator.
We should consider a way to reassure the user, and make them
useful at the same time.

Maybe a global set when something like this happens, and
then at the end, a friendly message about what it meant
and how to report the error and/or help debug?

Although if repair is done now, it's probably unlikely(?)
that the message would pop out again, so is there really
anything which could be done at this point?

Emmanuael - if another xfs_repair pops out the same error,
then capturing a metadump of the fs would probably let someone
look into it.  Someone who has time, that is.  ;)

-Eric


> 	Ben
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
