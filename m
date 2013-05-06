Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB0D929DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 09:34:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37022AC002
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 07:34:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LgM52QJCr9xoV4xf for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 07:34:51 -0700 (PDT)
Message-ID: <5187BF8A.2040303@sandeen.net>
Date: Mon, 06 May 2013 09:34:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs_repair segfaults.
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
In-Reply-To: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
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
To: Filippo Stenico <filippo.stenico@gmail.com>
Cc: xfs@oss.sgi.com

On 5/6/13 7:06 AM, Filippo Stenico wrote:
> Hello, I've had an issue on a raid5 volume (2 disks failing at same
> time, and buggy NAS firmware trying hard to sync then stop for I/O
> error then retryes to sync leading (!?) to lost raid and an xfs data
> corruption.

Sooo bad storage hardware, first off \o/  :(

> I've recreated raid, mounted the xfs filesystem, copied about 6TB of
> data out of 8TB, the rest of data being unreachable with "structrure
> needs cleaning" error. Thus I tried to unmount/mount and still got
> same error, then dumped metadata and tried various xfs_repair with
> different options but it always reaches a same point where it always
> segfaults.

OK, what version of xfsprogs?
If not latest usptream, please try that next.

If upstream still segfaults, you could provide a core and associated
binary debug info, or (maybe) an xfs_metadump for analysis.  It sounds
like this fs is in pretty bad shape though, so even the xfs_metadump
might fail and/or not gather enough information.

-Eric

> If someone is interested of investigating what's going on here and
> helping me recover more data I would be happy to send in in more
> details....
> 
> Cheers
> 
> -- F
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
