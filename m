Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC8A77F67
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 21:06:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66CEEAC001
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 19:06:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LuK7dp6r3GPBe6jB for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 19:06:46 -0700 (PDT)
Message-ID: <553EEB36.4080200@sandeen.net>
Date: Mon, 27 Apr 2015 21:06:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
References: <553EB3D1.10602@sandeen.net> <20150427233754.GT21261@dastard>
	<553ED9D8.4050106@sandeen.net> <20150428012003.GS15810@dastard>
In-Reply-To: <20150428012003.GS15810@dastard>
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

On 4/27/15 8:20 PM, Dave Chinner wrote:

> I think that labels are a far better way of dealing with this
> problem. Get rid of the UUID mount checking (and hence the nouuid
> mount option), and tell people to use by-label instead of by-uuid to
> identify their filesystems when doing clones and snapshots. Labels
> make it much easier for humans to identify the filesystem than
> UUIDs...

I suppose so.  Withdrawn.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
