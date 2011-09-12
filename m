Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CK5k37015657 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 15:05:47 -0500
Date: Mon, 12 Sep 2011 16:05:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110912200543.GA22409@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 12, 2011 at 06:46:26PM +0200, Stefan Priebe wrote:
> > What kind of workload are you running?  Also did the workload run fine
> > with an older kernel, and if yes which one?
> 
> Mysql, Web, Mail, ftp ;-) yes it was with 2.6.32. I upgraded from that version.


Just curious, is this the same system that also shows the freezes
reported to the scsi list?  If I/Os don't get completed by lower layers
I can see how we get everything in XFS waiting on the log reservations,
given that we never get the log tail pushed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
