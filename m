Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09JbBcI017091 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 13:37:12 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1F93AC003
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 11:37:07 -0800 (PST)
Message-ID: <4967A73E.9020907@sgi.com>
Date: Fri, 09 Jan 2009 13:36:30 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump support for 64K page size
References: <4964C5EF.3060308@sgi.com> <4965629C.2000703@sgi.com>
	<20090108222800.GG9448@disturbed>
In-Reply-To: <20090108222800.GG9448@disturbed>
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
To: Mark Goodwin <markgw@sgi.com>, Bill Kendall <wkendall@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Jan 08, 2009 at 01:19:08PM +1100, Mark Goodwin wrote:
>> Bill Kendall wrote:
>>> Various fixes to allow xfsdump/xfsrestore to work with 64K
>>> page size. This is essentially Chinner's patch from a while
>>> back.
>>>
>>> Signed-off-by: Bill Kendall <wkendall@sgi.com>
>> Lachlan reviewed and ack'd this on an internal list and I've committed
>> it (on Bill's behalf) as follows :
>>
>> git://oss.sgi.com/xfs/cmds/xfsdump.git
>> 	commit 9502587dbbfdd465958889a568dc2842f10b1ff9
>> 	Author: Mark Goodwin <markgw@sgi.com>
>> 	Date:   Thu Jan 8 12:37:53 2009 +1100
>>
>> 	    Various fixes to allow xfsdump/xfsrestore to work with 64K
>> 	    page size. This is essentially Chinner's patch from a while
>> 	    back.
> 
> I guess I don't have a real name ;)
> 
> BTW, these changes are the *exact* patches I sent back in March.
> I note that the change logs from those patches have been dropped
> on the floor. i.e.:

Right, only difference is that I removed the asserts rather than
just having them commented out. In my determination the asserts
are totally bogus -- there isn't a dependency on the system's
page size in the inomap code.

> 
> http://oss.sgi.com/archives/xfs/2008-05/msg00339.html

Sorry, didn't recall that you posted the patch to this list.
I got your patch off of the internal bug db.

> 
> The extended attr buffer size used by xfsdump is based on page size.
> The maximum buffer size the kernel will accept is 64k. On a 64k page
> machine, the default buffer size will be rejected by the kernel,
> thereby breaking dump and restore.
> 
> Limit the buffer size to XATTR_LIST_MAX in dump, restore and
> libhandle so the kernel won't reject otherwise valid requests.
> 
> ----
> 
> http://oss.sgi.com/archives/xfs/2008-05/msg00340.html
> 
> xfsrestore has assumptions about page size built into the inode hunk
> size in the dump format. Seems to be a stupid thing to do - this
> patch simply comments out the asserts to allow it to work on
> 64k page size machine, but probably subtly breaks the code.
> Nasty hack, really, but allows xfsqa tests to pass.
> 
> ----
> 
> I'd also like to know what validation has been done of the second
> patch. e.g. is it going to break when dump and restore are done on
> machines of different page size? This is why I didn't sign-off on
> the second patch....

The inomap code uses xfsdump's PGSZ variable, which is fixed at 4K.
There's no dependency here on the system's actual page size. I was
able to dump and then restore on a system with a different page size.

> 
>> In any case, Christoph, please pull these commits into your kernel.org 
>> -dev trees.
> 
> NACK. Lets do a proper review cycle first.

Once that is done, I suggest we put Dave's original patches in the
-dev trees. That way it'll have proper attribution as well as commit
messages with some detail.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
