Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54FA67F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 21:14:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38700304039
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 19:14:10 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bgF9Gvy5PuYa3vWI for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 19:14:07 -0800 (PST)
Date: Thu, 7 Jan 2016 14:13:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/35 v2] separate operations from flags in the
	bio/request structs
Message-ID: <20160107031341.GC32200@dastard>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<yq14meqi2va.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <yq14meqi2va.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, target-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On Wed, Jan 06, 2016 at 08:40:09PM -0500, Martin K. Petersen wrote:
> >>>>> "Mike" == mchristi  <mchristi@redhat.com> writes:
> 
> Mike> The following patches begin to cleanup the request->cmd_flags and
> bio-> bi_rw mess. We currently use cmd_flags to specify the operation,
> Mike> attributes and state of the request. For bi_rw we use it for
> Mike> similar info and also the priority but then also have another
> Mike> bi_flags field for state. At some point, we abused them so much we
> Mike> just made cmd_flags 64 bits, so we could add more.
> 
> Mike> The following patches seperate the operation (read, write discard,
> Mike> flush, etc) from cmd_flags/bi_rw.
> 
> Mike> This patchset was made against linux-next from today Jan 5 2016.
> Mike> (git tag next-20160105).
> 
> Very nice work. Thanks for doing this!
> 
> I think it's a much needed cleanup. I focused mainly on the core block,
> discard, write same and sd.c pieces and everything looks sensible to me.
> 
> I wonder what the best approach is to move a patch set with this many
> stakeholders forward? Set a "speak now or forever hold your peace"
> review deadline?

I say just ask Linus to pull it immediately after the next merge
window closes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
