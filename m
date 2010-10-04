Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94DnclD068831 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 08:49:38 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4CCAEA5E1C
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 07:04:14 -0700 (PDT)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id cy23gpWBr1hTEYi4 for
	<xfs@oss.sgi.com>; Mon, 04 Oct 2010 07:04:14 -0700 (PDT)
Message-ID: <4CA9DBAF.4080101@sandeen.net>
Date: Mon, 04 Oct 2010 08:50:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair never finishes on lvm partition
References: <AANLkTinH93VekNiAEbJbp43xnG2QPgnr+70nvC771ifG@mail.gmail.com>
	<20101004071613.GG4681@dastard>
In-Reply-To: <20101004071613.GG4681@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Knowledge Seeker <knoseeker@googlemail.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Mon, Oct 04, 2010 at 02:57:42AM +0000, Knowledge Seeker wrote:
>> Extra information:
>> The versions:
>> # xfs_repair -V
>> xfs_repair version 2.9.8
> 
> upgrade to a more recent version - that is positively ancient ;)
> 
> Then if it still freezes in pahse 6, run with the -P option to turn
> off prefetching (slower, but should prevent the hang).

And before that, if you'd like to preserve something for us to
look at, run 

# xfs_metadump /dev/blah imagefile

to capture the state of the fs which was causing problems.

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
