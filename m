Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E11D7F56
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 21:22:22 -0500 (CDT)
Message-ID: <533A22DB.2030608@sgi.com>
Date: Mon, 31 Mar 2014 21:22:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix bad hash ordering
References: <20140328173430.622616177@sgi.com>
	<20140331001055.GD16336@dastard> <53399B06.5010400@sgi.com>
	<20140331214016.GD17603@dastard>
In-Reply-To: <20140331214016.GD17603@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 03/31/14 16:40, Dave Chinner wrote:
> On Mon, Mar 31, 2014 at 11:42:46AM -0500, Mark Tinguely wrote:
>> On 03/30/14 19:10, Dave Chinner wrote:
>>> On Fri, Mar 28, 2014 at 12:33:34PM -0500, Mark Tinguely wrote:
>>>> Fix the fix directory "bad hash ordering" bug introduced in
>>>> commit f5ea1100.
>>>
>>
>> ...
>>
>>>
>>>> ---
>>>> A C program that generates this problem can be found at:
>>>>   http://oss.sgi.com/archives/xfs/2014-03/msg00373.html
>>>>
>>>> A xfstest for this bug is coming from Hannes Frederic Sowa.
>>>
>>> Can you convert this program to an xfstest yourself so that I can
>>> commit the regression test at the same time I commit an updated
>>> fix?
>>
>> We narrowed the iterations down to make it a quick test.
>> I have every confidence that Hannes can generate the test in a timely
>> manner and I will help in any way possible.
>
> Well, it's been over a week now and you're asking me to trust that
> someone I don't know and who has never submitted an xfstests before
> to do something in a timely manner so we can test a critical bug fix
> during a merge window. I'm willing to be pleasently surprised, but
> history tells me that people that report bugs rarely follow up with
> xfstest cases and it's usually the developer that fixes the bug that
> generates the xfstests patch.
>
> So if the xfstests patch doesn't arrive in the next few hours, can
> you please do that for us so I can get this sorted out for the merge
> window?
>
> Cheers,
>
> Dave.

Dave,

I think we need to take a step back and clear a little confusion here.
There are 2 different directory bugs.

1) Freeing of a already free extent. It presents with the error:
	XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 16XX of file
	 fs/xfs/xfs_alloc.c.
    Could be a right or a left edge (or both) that is free.

    Morgan Meyers <Morgan.Mears@netapp.com> sent the latest occurrence on
    March 12, but others have been seeing it in the community code in the
    last few mounts. SGI has been seeing it lately with big customers and
    it has occurred off and on for 7-8  years according to our bug
    database.

    It is a nasty bug that can can cause corruption. As I mentioned last
    week in the analysis of Morgan's metadata dump, XFS can allocate the
    same buffer multiple times. In his metadata dump there is a directory
    block and inode clusters that also allocated as user blocks. These
    duplicate allocated blocks are land mines waiting to go off either
    when written to by one owner or when when both allocations are
    removed which causes the XFS_WANT_CORRUPTED_GOTO forced shutdown.

2) Hannes Frederic Sowa found a different directory bug on Thursday,
    March 27. He included a replicator. I bisected the source of the this
    bug on Thursday. Walked the bisected patch on Friday and posted the
    patch. The idea to make a xfstest from the replicator was also made
    on March 28.

    This bug has been only known for 3 business days. I already promised
    that a xfstest will be made. If you need to verify the problem and
    the patch, there already is a replicator.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
