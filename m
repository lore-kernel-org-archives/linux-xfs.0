Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D3D07F37
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 13:38:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 539AD304059
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 11:38:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NGmGeYwCuYi2wpPv for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 11:38:54 -0700 (PDT)
Message-ID: <5541253D.4090701@sandeen.net>
Date: Wed, 29 Apr 2015 13:38:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
References: <553EB3D1.10602@sandeen.net>
	<20150427233754.GT21261@dastard>	<553ED9D8.4050106@sandeen.net>
	<20150428012003.GS15810@dastard> <553EEB36.4080200@sandeen.net>
In-Reply-To: <553EEB36.4080200@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/27/15 9:06 PM, Eric Sandeen wrote:
> On 4/27/15 8:20 PM, Dave Chinner wrote:
> 
>> I think that labels are a far better way of dealing with this
>> problem. Get rid of the UUID mount checking (and hence the nouuid
>> mount option), and tell people to use by-label instead of by-uuid to
>> identify their filesystems when doing clones and snapshots. Labels
>> make it much easier for humans to identify the filesystem than
>> UUIDs...
> 
> I suppose so.  Withdrawn.  ;)

One more thought.  ;)

It'd be quite possible to keep defaults compatible with old kernels,
and only set the new feature if/when a user requests a UUID change.

If UUID changes are rare, it'll rarely matter; if they are required,
it'll be possible.  I might send a patch just to make the discussion
a bit more concrete.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
