Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E8247CA1
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 12:39:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4595C304039
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 10:39:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TfBxJHPa0jtgAq6B for <xfs@oss.sgi.com>;
	Wed, 28 Sep 2016 10:39:48 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1FA182B51
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 12:39:19 -0500 (CDT)
Subject: Re: [PATCH 3/6] xfs: detect AGFL size mismatches
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-4-git-send-email-david@fromorbit.com>
	<28b962d6-aa0c-076d-be74-99006252eab4@sandeen.net>
	<20160914212651.GN30497@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6db94874-c1a3-ee0c-c82b-719e25e3ec3e@sandeen.net>
Date: Wed, 28 Sep 2016 12:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <20160914212651.GN30497@dastard>
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
To: xfs@oss.sgi.com

On 9/14/16 4:26 PM, Dave Chinner wrote:

> Bad wrap case:
> 
> 	flfirst = 10	(invalid!)
> 	fllast = 0
> 	flcount = 2
> 	agfl_size = 10
> 	active = 0 - 10 + 1
> 	       = -9 + agfl_size
> 	       = 1 (correct as flfirst is invalid!)

Ok, I guess maybe I got confused w.r.t. the actual accounting vs.
the expected/correct accounting.

I saw "active = 1" and thought no, that's wrong, there are 2.
But active is what it /should/ be not what it /is/ ?

More comments would help I suppose, around either the first assignment
or the variable declaration, for this and for flcount.

(I guess flcount is actual number on the list, active is what
it /should/ be?)

> 	if (flfirst > agfl_size)		not true
> 	if (flfirst == agfl_size)		true, warn
> 
> 	if (fllast > agfl_size)			not true
> 	if (fllast == agfl_size)		not true
> 
> 	if (flcount > agfl_size + 1)		not true
> 	if (flcount == agfl_size)		not true
> 
> 	if (active <= 0)			not true
> 	if (flcount > active + 1)		not true
> 	if (flcount < active)			not true
> 	if (flcount != active)			true, warn
> 
> So, two correction needed warnings, which is correct because both
> flfirst and flcount need fixing due to being off by one.

ok
 
> The bad fllast case:
> 
> 	flfirst = 5
> 	fllast = 10	(invalid!)
> 	flcount = 6	
> 	agfl_size = 10
> 	active = fllast - flfirst + 1
> 	       = 10 - 5 + 1
> 	       = 6 (invalid as fllast is out of range)
> 
> 	if (flfirst > agfl_size)		not true
> 	if (flfirst == agfl_size)		not true
> 
> 	if (fllast > agfl_size)			not true
> 	if (fllast == agfl_size)		true, warn
> 
> 	if (flcount > agfl_size + 1)		not true
> 	if (flcount == agfl_size)		not true
> 
> 	if (active <= 0)			not true
> 	if (flcount > active + 1)		not true
> 	if (flcount < active)			not true
> 	if (flcount != active)			not true
> 
> So we've got a warning that a fllast correction will take place,
> which will also correct the flcount once the fllast index is
> updated.
> 
> But I think the case you are concerned about is a corner case of
> this one - a full AGFL, right?  Something that, in practice, will
> never happen as no single transaction will free or require a full
> AGFL worth of blocks in a single allocation/free operation.

Actually no, I hadn't caught that one ;)

> As such, I didn't actually consider it or test that case, so, it may
> be wrong.  Let's run the numbers:
> 
> 	flfirst = 0
> 	fllast = 10	(invalid!)
> 	flcount = 11	(invalid!)
> 	agfl_size = 10
> 	active = fllast - flfirst + 1
> 	       = 10 - 0 + 1
> 	       = 11 (invalid as fllast is out of range)
> 
> 	if (flfirst > agfl_size)		not true
> 	if (flfirst == agfl_size)		not true
> 
> 	if (fllast > agfl_size)			not true
> 	if (fllast == agfl_size)		true, warn
> 
> 	if (flcount > agfl_size + 1)		not true
> 	if (flcount == agfl_size)		not true
> 
> 	if (active <= 0)			not true
> 	if (flcount > active + 1)		not true
> 	if (flcount < active)			not true
> 	if (flcount != active)			not true
> 
> So it issues the same fllast warning as the not full, not wrapped
> case, and that correction also fixes up the flcount. Maybe it's the
> full wrapped case, which may be a pure flcount error?
> 
> 	flfirst = 5
> 	fllast = 4
> 	flcount = 11	(invalid!)
> 	agfl_size = 10
> 	active = fllast - flfirst + 1
> 	       = 4 - 5 + 1
> 	       = 10 (different to flcount!)
> 
> 	if (flfirst > agfl_size)		not true
> 	if (flfirst == agfl_size)		not true
> 
> 	if (fllast > agfl_size)			not true
> 	if (fllast == agfl_size)		not true
> 
> 	if (flcount > agfl_size + 1)		not true
> 	if (flcount == agfl_size)		not true
> 					(yes, that should warn)
> 
> 	if (active <= 0)			not true
> 	if (flcount > active + 1)		not true
> 	if (flcount < active)			not true
> 	if (flcount != active)			true, warn
> 
> So we do get a warning about the flcount being wrong because it's
> only one block different to the calculated active size (and hence it
> will be corrected), but no warning from the flcount being out of
> range by one block. So, yes, I think you are right, Eric, that the
> check should be against agfl_size + 1, even it it means we get
> multiple warnings...

Ah, ok :)  So this is essentially:

-	if (flcount == agfl_size)
+	if (flcount == agfl_size + 1)
		xfs_warn(mp, "AGF %u: freelist count needs correction(1)",
			be32_to_cpu(agf->agf_seqno));

for your patch, right.  Glad we agree.  :)

-Eric

> Thanks for thinking about this case!
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
