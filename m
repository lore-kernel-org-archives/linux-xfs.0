Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 705C429E02
	for <linux-xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:55:44 -0500 (CDT)
Message-ID: <523A134B.6010609@sgi.com>
Date: Wed, 18 Sep 2013 15:55:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_check: fix test for too-high level in v2 dir node
References: <52322B67.80305@redhat.com> <523A0086.1080000@sgi.com>
	<523A0AF0.3000507@sandeen.net>
In-Reply-To: <523A0AF0.3000507@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 09/18/13 15:20, Eric Sandeen wrote:
> On 9/18/13 2:35 PM, Mark Tinguely wrote:
>> On 09/12/13 16:00, Eric Sandeen wrote:
>>> The test as it stands allows level == XFS_DA_NODE_MAXDEPTH (5),
>>> but a max depth of 5 equates to level values of 0 through 4.
>>>
>>> Level 5 would be a depth of 6.
>>>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
...
>> I think the current code is correct.

> So confused.  :/  (Maybe the cursor array needs to be 1 bigger?)
>
> -Eric


Well, I am frequently noted as being permanently confused!

I was referring to the kernel use of XFS_DA_NODE_MAXDEPTH. All the
comparison indicate that having a value of 1 to XFS_DA_NODE_MAXDEPTH as
being okay.

When it accesses the xfs_da_state_blk_t blk[XFS_DA_NODE_MAXDEPTH],
it decrements the index first there is no blk[] entry for a leaf that
is why it does not need another entry.

I need to study this more.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
