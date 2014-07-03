Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E18929DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 18:17:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 861658F8049
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 16:17:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HTiv7bJ7Osy8DlBd for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 16:17:32 -0700 (PDT)
Date: Fri, 4 Jul 2014 09:17:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS syncs
Message-ID: <20140703231730.GW4453@dastard>
References: <53B59B81.2030603@hotbox.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53B59B81.2030603@hotbox.ru>
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
To: flux@hotbox.ru
Cc: xfs@oss.sgi.com

On Thu, Jul 03, 2014 at 10:05:53PM +0400, flux@hotbox.ru wrote:
> Hi,
> 
> I issue 'mkdir abc' on my xfs partition the cut off the power. After
> reboot there's no 'abc' directoy.

Because you didn't sync(1) the filesystem or fsync(2) the directory
before you cut the power. Hence the change never hit the disk.

> However, when I do that on ext4
> the 'abc' direcory is always created after reboots.

That'll be pure fluke - ext4 delays journal writes on namespace
operations just like XFS does.

> All the
> settings, about mount options are default for my distro. What am I
> missing or how do I change the things of the jounral or whatever?

If you want directory operations to hitthe disk immediately, then
mount with the "-o wsync" option. Be aware, however, that this will
kill performance unless you have expensive storage with a large
amount of battery backed write cache in front of the disks. There's
a good chance it will also cause excessive wear on SSDs due to the
frequent journal writes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
