Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7HLfBmH094869 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 16:41:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0EEF1BDADFA
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:41:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lasE1JBSWWX92MHg for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:41:38 -0700 (PDT)
Date: Mon, 17 Aug 2009 17:41:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: disk performance strange/low
Message-ID: <20090817214136.GA26060@infradead.org>
References: <200908172311.07660@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200908172311.07660@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, Aug 17, 2009 at 11:11:07PM +0200, Michael Monnerie wrote:
> I've got an Areca RAID Controller with 5x 1TB disks, and in the last 
> time I often found it to be strange. Now I investigated, and found this. 
> >From another server I NFS mount a share, and make
> dd if=/dev/sda of=/server/share/test.dd bs=1024k
> so that should do big sequential writes. But the performance goes up and 
> down, like you see in this output from "iostat -kx 5 555". You see write 
> KB/s is 5824, 23207, 87283, 704, 40187. Up and down all the time. Could 
> that be solved by the patch you discussed last time, or is there 
> something else?

Yes, that sounds like the problem of the VM not feeding us enough
pages to write.  What kernel is this on?  Latest 2.6.31-rc has a
workaround for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
