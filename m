Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BB187F82
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 19:56:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C7C1AC003
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 17:56:22 -0700 (PDT)
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 3XSlFUZUXytMusjl (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 17:56:21 -0700 (PDT)
Date: Mon, 8 Jul 2013 20:56:13 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709005613.GA6000@thunk.org>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
	<20130708135953.GF5988@quack.suse.cz> <51DAD943.6050703@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51DAD943.6050703@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon, Jul 08, 2013 at 05:22:43PM +0200, Marco Stornelli wrote:
> 
> Funny, if I well remember Google guys switched android from yaffs2
> to ext4 due to its superiority on SMP :)

The bigger reason why was because raw NAND flash doesn't really make
sense any more; especially as the feature size of flash cells has
shrunk and with the introduction of MLC and TLC, you really need to
use hardware assist to make flash sufficiently reliable.  Modern flash
storage uses dynamic adjustment of voltage levels as the flash cells
age, and error correcting codes to compensate for flash reliability
challenges.  This means accessing flash using eMMC, SATA, SAS, etc.,
and that rules out YAFFS2.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
