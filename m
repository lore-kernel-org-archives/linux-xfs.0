Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KIgEtJ076803 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:42:14 -0500
Received: from na3sys009aog104.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC0161403C78
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:47:32 -0700 (PDT)
Received: from na3sys009aog104.obsmtp.com (na3sys009aog104.obsmtp.com
	[74.125.149.73]) by cuda.sgi.com with ESMTP id vK20t57FT3cXrnaR
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:47:32 -0700 (PDT)
Received: by mail-yw0-f42.google.com with SMTP id 8so683834ywa.29
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:42:12 -0700 (PDT)
Date: Tue, 20 Sep 2011 13:42:08 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110920184208.GB2119@BohrerMBP.rgmadvisors.com>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
	<20110915145556.GA19902@infradead.org>
	<20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
	<20110916002557.GN11984@tux1.beaverton.ibm.com>
	<20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
	<20110920163034.GB18914@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110920163034.GB18914@infradead.org>
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

On Tue, Sep 20, 2011 at 12:30:34PM -0400, Christoph Hellwig wrote:
> On Fri, Sep 16, 2011 at 11:32:32AM -0500, Shawn Bohrer wrote:
> > So for the most part it sounds like this change is needed for DIF/DIX.
> > Could we only enable the wait_on_page_writeback() if
> > CONFIG_BLK_DEV_INTEGRITY is set?  Does it make sense to tie these
> > together?
> 
> It will also allow for huge efficiency gains on software raid.  There
> have been some Lustre patches for that.
> 
> > The other thread in this case is the [flush-8:0] daemon writing back
> > the pages.  So in our case you could see the spikes every time it wakes
> > up to write back dirty pages.  While we can control this to some
> > extent with vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs
> > it essentially impossible to ensure the writeback doesn't coincide
> > with us writing to the page again.
> 
> Can you explain how your use case looks in more details?  Right now

In one case we have an app that receives multicast data from a socket
and appends it to one of many memory mapped files.  Once it writes the
data to the end of the file it updates the header to record the new
size.  Since we update the header page frequently we are very likely
to encounter a stall here as the header page gets flushed in the
background.  We also have reader processes that check the file header
to find the new data since the last time they checked.  A stall in
updating the header means the readers do not get the latest data.

It is also possible that as we append the data to the file a partially
filled page at the end of the file could get flushed in the background
causing a stall since we append in chunks smaller than 4K.  This is
less likely though because we have tuned our
vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs so that we
normally completely fill a page before the OS flushes it.

> for example a mlock removes the page from the lru list and thus stops
> VM writeback.  If such an interface would be useful for you we could
> offer an fadvice call that stops writeback entirely, and requires you
> to force it when you want it.

For the case I described above I'm not sure this would help because
we don't know the incoming rate of data so even if we force the sync
it could still cause a stall.

I do have a second application that is also suffering from these
stalls and I believe we could avoid the stalls by using fadvise to
disable writeback for a portion of the file and manually sync it
ourselves.  So this could potentially solve one of my problems.

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
