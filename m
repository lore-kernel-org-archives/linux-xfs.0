Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CDC87F4E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 16:19:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B6628F8035
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 14:18:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PbIsN9OamHb9G7U6 for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2014 14:18:57 -0800 (PST)
Date: Mon, 22 Dec 2014 09:18:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: finobt option for end user
Message-ID: <20141221221853.GG24183@dastard>
References: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
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
To: Alphazo <alphazo@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 20, 2014 at 11:52:57PM +0100, Alphazo wrote:
> Hello,
> 
> I'm pretty new to XFS. I'm considering moving away from ext4 to XFS because
> of the new self-describing option, performance and reliability improvements
> that XFS went through over the past year. Now I'm puzzled with the new free
> inode btree option (finobt). I tried to find some documentation about it
> but couldn't find the pros or cons. So from an end-user perspective with a
> couple of TB worth of photos:
> - Does it improve overall reliability?

No effect on reliability, good or bad.

> - Does it provide faster fsck/repair?

No, if anything, it slows it down because there's more metadata to
verify and rebuild.

> - Does it improve any read or write operation?

No.

> - Is it safe to use and does it recover as well as with finobt=0?

Yes and yes.

> - What is the typical case for enabling it

It improves performance on aged filesystems i.e. months or years
down the track when you've added and removed millions of
files to/from the filesystem.

> and would you recommend using it
> for any new fs creation?

Consider the fact that "-m crc=1,finobt=1" will be made the mkfs
default in 3-6 months time - that will probably co-incide with a
xfsprogs 3.3 release....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
