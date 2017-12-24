Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39764 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbdLXUp4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Dec 2017 15:45:56 -0500
Subject: Re: [PATCH 4/7] mkfs: support arbitrary conflict specification
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-5-david@fromorbit.com>
 <20171220025346.GL12613@magnolia> <20171220035227.GD4094@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c68f5c12-f15c-8925-1a61-efb67503b212@sandeen.net>
Date: Sun, 24 Dec 2017 12:45:52 -0800
MIME-Version: 1.0
In-Reply-To: <20171220035227.GD4094@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 12/19/17 7:52 PM, Dave Chinner wrote:
> On Tue, Dec 19, 2017 at 06:53:46PM -0800, Darrick J. Wong wrote:
>> On Mon, Dec 18, 2017 at 08:11:55PM +1100, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Currently the conflict table is a single dimension, allowing
>>> conflicts to be specified in the same option table. however, we
>>> have conflicts that span option tables (e.g. sector size) and
>>> so we need to encode both the table and the option that conflicts.
>>>
>>> Add support for a two dimensional conflict definition and convert
>>> all the code over to use it.
>>>
>>> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>>> ---
>>>  mkfs/xfs_mkfs.c | 257 ++++++++++++++++++++++++++++----------------------------
>>>  1 file changed, 130 insertions(+), 127 deletions(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 7cc5ee2ddb9d..2272700807dc 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -125,7 +125,10 @@ struct opt_params {
>>>  		bool		str_seen;
>>>  		bool		convert;
>>>  		bool		is_power_2;
>>> -		int		conflicts[MAX_CONFLICTS];
>>> +		struct _conflict {
>>> +			struct opt_params	*opts;
>>> +			int			subopt;
>>> +		}		conflicts[MAX_CONFLICTS];
>>>  		long long	minval;
>>>  		long long	maxval;
>>>  		long long	defaultval;
>>> @@ -143,8 +146,8 @@ struct opt_params bopts = {
>>>  	},
>>>  	.subopt_params = {
>>>  		{ .index = B_LOG,
>>> -		  .conflicts = { B_SIZE,
>>> -				 LAST_CONFLICT },
>>> +		  .conflicts = { { &bopts, B_SIZE },
>>> +				 { &bopts, LAST_CONFLICT } },
>>
>> Hmm.  The LAST_CONFLICT entry doesn't require an *opts pointer, right?
>>
>> It feels a little funny to me that the last entry isn't:
>>
>> { NULL, LAST_CONFLICT }
>>
>> ...since we're not actually doing anything with bopts in that last
>> entry, but that might be a matter of taste (aka I punt to sandeen) :)
> 
> Doesn't worry me - I put it there as the loop terminates on
> LAST_CONFLICT, not on a null opts pointer. Eric - up to you.

Meh, 6 one way half a dozen the other; above, this:

+		  .conflicts = { { &bopts, B_SIZE },
+				 { NULL, LAST_CONFLICT } },

seems a little nicer, but when it stands alone, this:

                  .conflicts = { { &dopts, LAST_CONFLICT } },

at least reminds the programmer which opts are generally in play,
in case they add a new one, whereas:

                  .conflicts = { { NULL, LAST_CONFLICT } },

doesn't.  Overall I guess I like NULL better since it's ignored,
and we don't want to imply that opt_params * matters there.

OTOH I don't really want to make it terminate on either/both, because
that adds confusion.  So let's say the only terminator is LAST_CONFLICT,
opts is ignored in that case, and we just choose to use NULL as a matter
of taste.

I could do it on commit if you like (not sure I should get into that
habit...).

:%s/{ &.*, LAST_CONFLICT/{ NULL, LAST_CONFLICT/g


-Eric
