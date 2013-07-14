Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 379CC7F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 18:43:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7001AC001
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 16:43:54 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id q4XON6rAxj4OWLcB
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 16:43:53 -0700 (PDT)
Message-ID: <51E337BC.3090304@hardwarefreak.com>
Date: Sun, 14 Jul 2013 18:43:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: specify agsize?
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E2CE83.9080003@sandeen.net> <51E32144.3020109@hardwarefreak.com>
	<2869A4A3-909A-486D-90A2-C1B04317EA40@gmail.com>
In-Reply-To: <2869A4A3-909A-486D-90A2-C1B04317EA40@gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: aurfalien <aurfalien@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 7/14/2013 5:42 PM, aurfalien wrote:

> My initial post on this was to try and understand if there mobs make sense to the general XFS community 

They do not.

> and wether I could benefit from them in applying those mods to general purpose storage.

You may or may not.  There's simply not enough information available in
that guide.  Obviously Autodesk has a reason for recommending 128 AGs,
but no such reasoning is provided.  I already explained why, in the
general case, agcount has no relevance in isolation.  Setting agcount
properly for the general XFS case requires knowledge of the underlying
storage device size, geometry, spindle speed, etc.

The Autodesk instructions Eric linked are specific to a select group of
Autodesk certified HP workstation models, Autodesk's own storage arrays,
or unspecified FC SAN storage.  Nowhere in the "storage configuration"
chapter does it mention the number of disks or RAID level required or
recommended backing the LUNs.

Thus, given what I've explained of the relationship between array
capacity, spindle count, RAID level, etc, it simply doesn't make sense
to arbitrarily specify 128 allocation groups, especially when the
storage hardware characteristic are completely ignored.

So if Autodesk is ignoring these critical factors when telling you to
use 128 allocation groups, then they either have some application
specific file layout that benefits from 128 AGs, or, as I said, they
don't know XFS as well as they think they do.  I'm not disparaging
Autodesk here.  There are plenty of vendors who do things with XFS that
aren't necessarily wise, sometimes flat out bad.

Taking a quick glance at the data directory layout on a current Flame
system may get us closer to understanding why they want 128 AGs.  For
instance, if they've created exactly 128 directories on the XFS volume
that would fully answer the question as to why they want 128 AGs.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
