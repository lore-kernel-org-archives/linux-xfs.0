Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n38DYAVm092220 for <xfs@oss.sgi.com>; Wed, 8 Apr 2009 08:34:25 -0500
Date: Wed, 8 Apr 2009 09:33:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2, RESEND] [XFS] a couple of fixes
Message-ID: <20090408133350.GA12013@infradead.org>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
	<20090406222831.GA12016@infradead.org>
	<09C35383-EA8E-4EC2-A067-B3FA327AFF4C@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <09C35383-EA8E-4EC2-A067-B3FA327AFF4C@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 07, 2009 at 11:45:33PM -0500, Felix Blyakher wrote:
>
> On Apr 6, 2009, at 5:28 PM, Christoph Hellwig wrote:
>
>> I've sucked these patches into my tree after reviewin and QAing them.
>> Felix, can you pull this and send it to Linus for 2.6.30?
>>
>> 	git://git.kernel.org/pub/scm/fs/xfs/xfs.git
>
> I did pull from your tree, and pushed to oss.
> But I stopped short from pushing the for-linus branch,
> and generating the pull request, as I'm again seeing
> the 'merge' commits. I'll try to sort it out tomorrow.

Note that you will always see some merge commits of both merged trees
touched the same files.  What Linus objected was the large amount of
merge commits.  The way to bring them down is to simply do less merges,
just stay on the same mainline level for a longer time and only merge
with mainline short before you prepare a pull or when you really need it
due to conflicting changes making it in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
