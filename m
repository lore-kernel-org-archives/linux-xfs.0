Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNHEPkR252093 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 11:14:25 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E02EFAC019
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 09:15:05 -0800 (PST)
Message-ID: <4B325018.4050708@sgi.com>
Date: Wed, 23 Dec 2009 11:15:04 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use time32_t consistently in xfsdump tree
References: <4B300389.7020905@sgi.com> <20091223133136.GA10345@infradead.org>
In-Reply-To: <20091223133136.GA10345@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>> On Wed, Dec 23, 2009 at 09:20:59AM -0600, Bill Kendall wrote:
>>> Reposting to fix whitespace issues introduced by mailer.
>> 
>> The patch looks good and applies cleanly now,
>> 
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> 
>> 
>> Some notes to look into after this patch:
>> 
>>  - can you provide a testcase for the problems caused by the wrong
>>    time_t usage?  A patch to xfstests would be perfect, but if you
>>    have a raw testcase I'll vounteer to wire it up.

The way I reproduced this was to do a subtree dump followed by
a dump of the inventory. On systems with a 64-bit time_t, this
will show a dump date far into the future.

# xfsdump -F -s tmp -f /dev/null /
# xfsinvutil -C | grep Session
             Session 0: valor:/ Sat Jan 29 17:45:22 2146

The dump needs to be a subtree dump since that sets a flag in
a field which is adjacent to a timestamp field in an inventory
structure. When the time32_t field was cast to a time_t *,
the flag's value was being read.

I don't know if this is worth writing a test for, however.
It catches one specific call to ctime where ctime32 should
have been used. The compiler will issue warnings for these
cases, it's just that the code was explicitly casting to
time_t * to silence the warnings.

>>  - why do we wrap both ctime and ctime_r?  Currently xfsdump isn't
>>    multithreaded so we shouldn't need it.  But if the parallel
>>    dump/restore ever gets merged from IRIX we need to get rid of the
>>    plain ctime calls.  (Btw, are there any plans for the parallel
>>    dump/restore port?)

There was an existing ctime_r call so I just blindly converted
it to ctime32_r. The existing ctime32 calls all come from xfsinvutil,
which will remain single-threaded even if xfsdump/restore is parallel.

However, while looking at this I noticed there's at least one case
where we do printf("...", ctime(), ctime()). That's not going to
work right -- the same value will be printed for both times. I'll
have to repost again...

No plans for the parallel port.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
