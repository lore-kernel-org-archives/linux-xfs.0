Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 408567CB9
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 17:27:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 016628F8052
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:27:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Rgoy4W5G6HFvtV3V for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 15:27:44 -0700 (PDT)
Date: Sat, 9 Apr 2016 08:27:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Use latest xfs_repair on older file systems
Message-ID: <20160408222742.GC567@dastard>
References: <CAD4UnC8M32_GO1+2rfi=v6f3R02T70dhxQJeZtnGFi_muL2z9g@mail.gmail.com>
	<5708194D.4080406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5708194D.4080406@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 03:49:17PM -0500, Eric Sandeen wrote:
> Obsolete features do occasionally get dropped upstream, as well - witness
> your V1 inode message.  However, that was likely just some other form of
> corruption, seen as V1 inodes, unless this really was a very, very old
> filesystem (created prior to 2007), which seems unlikely.

That error does not come from inode number checking - it is emitted
if the NLINK feature bit is missing from the superblock feature
field.

> On 4/8/16 3:37 PM, Chris M Moser wrote:
> I unmounted and ran xfs_repair 2.9.4 form the host OS a few more
> times.

Is this filesystem was created with 2.9.4, we're talking about a
filesystem that was released:

xfsprogs-2.9.4 (7 Sep 2007)

And, importantly:

xfsprogs-2.9.5 (21 Jan 2008)
        - Updated mkfs.xfs defaults.

It was then very next release that sets NLINK by default via:

commit 8d537733f52a642d471f6781f32f306241dd4308
Author: Niv Sardi <xaiki@sgi.com>
Date:   Fri Nov 16 05:16:34 2007 +0000
....
    -
    V2 inodes per default, and move DFL bits to XFS_DFL_SB_VERSION_BITS,

    Activate XFS_SB_VERSION_NLINKBIT per default, which will enable V2 INODES.
    refactor bits that we want everytime in XFS_DFL_SB_VERSION_BITS.
    -
....


So, your host has the very last version of xfsprogs that defaulted
to v1 inodes, and so recent xfsprogs versions will simply refuse to
run on it. It does not imply there is any corruption, however, you
just need to use a version of xfs_repair that supports v1 inodes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
