Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O7sB72172190 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 02:54:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D35C99432
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 00:55:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EDzBZjV10zMLCAlU for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 00:55:07 -0700 (PDT)
Date: Fri, 24 Sep 2010 03:55:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100924075505.GA24664@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C9B6B27.5050606@open-e.com>
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
To: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
Cc: Christoph Hellwig <hch@infradead.org>, Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, ??ukasz Wittig <lukasz.wittig@open-e.com>

On Thu, Sep 23, 2010 at 04:58:47PM +0200, Slawomir Nowakowski wrote:
> iSCSI FileIO is using struct file that serves it as block level
> device via iSCSI technology:
> 
> http://en.wikipedia.org/wiki/ISCSI

Thanks, I know ISCSI very well.  But what is "iSCSI FileIO" ?  The above
sounds like it's an iscsi target, is that correct?

> There are RAID level 6 unit on the Areca RAID controller (1680). On
> the unit is created a volume group. In the volume group we have
> several logical volumes. The iSCSI FileIO volume is mounted and the
> file (lun) is served via SCST target as iSCSI LUN.
> 
> We have checked RAM with memtest+ and verified RAID unit health and
> no issues were found.

I still can't make any sense of the actual setups.

The above seems to be the backend storage.  Then there's SCST somewhere
in which is in a out of tree kernel module.  And then you use XFS
somewhere.  Please provide a full description of the setup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
