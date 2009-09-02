Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82BinKe260970 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 06:44:59 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9208C15A9E1D
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 04:45:38 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id nSZfWfV4wA93pamH for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 04:45:38 -0700 (PDT)
Date: Wed, 2 Sep 2009 07:45:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0909020743550.22337@p34.internal.lan>
References: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
	<alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
	<20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
	<20090823224504.GA19942@infradead.org>
	<alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
	<alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
	<20090826180234.GC14019@infradead.org>
	<alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
	<20090826212732.GA18124@infradead.org>
	<alpine.DEB.2.00.0908261728580.1594@p34.internal.lan>
	<alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>



On Fri, 28 Aug 2009, Justin Piszcz wrote:
>
> On Wed, 26 Aug 2009, Justin Piszcz wrote:
>
>> On Wed, 26 Aug 2009, Christoph Hellwig wrote:
>> 
>>> On Wed, Aug 26, 2009 at 05:19:11PM -0400, Justin Piszcz wrote:

Christoph,

Now 6 days without any problems using -o nobarrier.

$ uptime
  07:43:55 up 6 days, 14:12,  1 user,  load average: 0.00, 0.00, 0.00

So -o nobarrier is a workaround for the issue.  How / what debug settings
should be enabled to catch the bug/problem when -o nobarrier is used?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
