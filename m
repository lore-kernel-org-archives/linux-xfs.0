Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF40D7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 09:32:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EE748F8054
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 07:32:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8YWFdnwhlPB41wum for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 07:32:52 -0700 (PDT)
Message-ID: <51754A13.5000808@sandeen.net>
Date: Mon, 22 Apr 2013 09:32:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
References: <20130419204102.736961610@sgi.com>
	<20130421174107.007313126@sgi.com>
	<5174603A.8030208@sandeen.net> <51753EDE.6000301@sgi.com>
In-Reply-To: <51753EDE.6000301@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 4/22/13 8:45 AM, Mark Tinguely wrote:
> On 04/21/13 16:55, Eric Sandeen wrote:
>> On 4/21/13 12:41 PM, Mark Tinguely wrote:
>>
>>> This problem happened locally with a bad inode number from xfs
>>> recovery. xfs_perag_get() can return NULL if given a bad agno.
>>> Most callers of xfs_perag_get() do not check for a NULL before
>>> using the pointer. This patch forces a shutdown of the filesystem
>>> for those callers that do not check the return value rather than
>>> crashing on a dereferenced NULL pointer.
>>
>> Hi Mark -
>>
>> I'm curious, what was the callchain when this happened?  Was it
>> during recovery?  If so, would aborting recovery be more prudent?
>>
>> I might be missing something, but I'm not sure how shutting
>> down avoids a subsequent null ptr deref&  crash.
>>
>> i.e. if a caller does something like:
>>
>>          pag = xfs_perag_get(mp, agno);
>>          spin_lock(&pag->pagb_lock);
>>
>> shutting down in xfs_perag_get doesn't save us from a
>> null pag pointer, would it?
>>
>> Thanks,
>> -Eric
> 
> You are correct, we have to exit the routine(s) to avoid the dereference. Let the callers handle the error.
> 
> Sorry for the noise.

No problem, glad I'm useful on the rare occasion.  ;)

Can you share the backtrace on the null deref you saw?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
