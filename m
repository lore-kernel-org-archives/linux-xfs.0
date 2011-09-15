Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8FFlrN9218024 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 10:47:54 -0500
Received: from na3sys009aog124.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38DF01C13AB3
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 08:47:52 -0700 (PDT)
Received: from na3sys009aog124.obsmtp.com (na3sys009aog124.obsmtp.com
	[74.125.149.151]) by cuda.sgi.com with ESMTP id
	xHvGIQ226aqfudyO for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2011 08:47:52 -0700 (PDT)
Received: by gwb15 with SMTP id 15so3344142gwb.33
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 08:47:51 -0700 (PDT)
Date: Thu, 15 Sep 2011 10:47:48 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
	<20110915145556.GA19902@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110915145556.GA19902@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

Thanks Christoph,

On Thu, Sep 15, 2011 at 10:55:57AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> > I've got a workload that is latency sensitive that writes data to a
> > memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> > up to 100ms that occur during writeback that we did not see with older
> > kernels.  I've traced the stalls and it looks like they are blocking
> > on wait_on_page_writeback() introduced in
> > d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> > should wait for writeback to finish"
> > 
> > Reading the commit description doesn't really explain to me why this
> > change was needed.
> 
> It it there to avoid pages beeing modified while they are under
> writeback, which defeats various checksumming like DIF/DIX, the iscsi
> CRCs, or even just the RAID parity calculations.  All of these either
> failed before, or had to work around it by copying all data was
> written.

I'm assuming you mean software RAID here?  We do have a hardware RAID
controller.  Also for anything that was working around this issue
before by copying the data, are those workarounds still in place?

> If you don't use any of these you can remove the call and things
> will work like they did before.

I may do this for now.

In the longer term is there any chance this could be made better?  I'm
not an expert here so my suggestions may be naive.  Could a mechanism
be made to check if the page needs to be checksummed and only block in
that case?  Or perhaps some mount option, madvise() flag or other hint
from user-mode to disable this, or hint that I'm going to be touching
that page again soon?

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
