Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2IE0uMP240707 for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 09:00:57 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Ga5P6cYheX5y9p60 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 18 Mar 2012 07:00:53 -0700 (PDT)
Date: Sun, 18 Mar 2012 10:00:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Message-ID: <20120318140051.GA2594@infradead.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20325.50714.237894.328039@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

On Sun, Mar 18, 2012 at 11:25:14AM +0000, Peter Grandi wrote:
> >  ?There have been decent but no major improvements in XFS metadata
> >   *performance*, but weaker implicit *semantics* have been made an
> >   option, and these have a different safety/performance tradeoff
> >   (less implicit safety, somewhat more performance), not "just"
> >   better performance.?
> 
> I have left implicit a point that perhaps should be explicit: I
> think that XFS metadata performance before 'delaylog' was pretty
> good, and that it has remained pretty good with 'delaylog'.

For many workloads it absolutely wasn't.

> People who complained about slow metadata performance with XFS
> before 'delaylog' were in effect complaining that XFS was
> implementing overly (in some sense) safe metadata semantics, and
> in effect were demanding less (implicit) safety, without
> probably realizing they were asking for that.

No, they weren't, and as with most posts to the XFS and RAID lists
you are completely off the track.

Plese read through Documentation/filesystems/xfs-delayed-logging-design.txt
and if you have any actual technical questions that you don't understand
feel free to come back and ask.

But please stop giving advise taken out of the thin air to people on the
lists that might actually believe whatever madness you just dreamed up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
