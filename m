Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BHHKE3143282 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 11:17:21 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96BE710ABEF
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:16:44 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id sdqAY8FP66Js9Y6Q for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2009 09:16:44 -0800 (PST)
Message-ID: <499300E2.7000207@sandeen.net>
Date: Wed, 11 Feb 2009 10:46:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: sunit & swidth on RAID-1?
References: <20090211155638.GA3864@dentifrice>
In-Reply-To: <20090211155638.GA3864@dentifrice>
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
To: mike dentifrice <fluor@poivron.org>
Cc: xfs@oss.sgi.com

mike dentifrice wrote:
> Hello,
> 
> I would like to know if it makes any sense to specify sunit & swidth
> parameters as mount options to XFS filesystems sitting on a Linux
> software RAID-1 array, as advertised here [1] or there [2].
> 
> I'm asking, because it seems that chunk_size does not matter in a RAID-1
> context, nor do stripe units; or do they?

I don't think it does matter.  And for what it's worth, mkfs.xfs queries
an MD raid, but ignores raid1/10/0:

                /*
                 * Ignore levels we don't want aligned (e.g. linear)
                 * and deduct disk(s) from stripe width on RAID4/5/6
                 */
                switch (md.level) {
                case 6:
                        md.raid_disks--;
                        /* fallthrough */
                case 5:
                case 4:
                        md.raid_disks--;
                        /* fallthrough */
                case 1:
                case 0:
                case 10:
                        break;
                default:
                        return 0;

In general, mkfs.xfs on md should just "do the right thing"

-Eric


> Any tip would be appreciated,
> 
> [1] http://www.socalsysadmin.com/2008/10/15/optimizing-xfs-on-raid-arrays/
> [2] http://feedblog.org/2008/06/18/howto-configure-raid-strides-in-xfs/
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
