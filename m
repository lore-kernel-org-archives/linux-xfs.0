Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CFLadA002400 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 10:21:36 -0500
Date: Mon, 12 Sep 2011 11:21:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110912152133.GA8345@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
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
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Sep 10, 2011 at 02:23:12PM +0200, Stefan Priebe wrote:
> Hello List,
> 
> on some of our heavy loaded servers using xfs we're seeing a deadlock where reading/writing to the xfs filesystem suddenly stops working.
> 
> Here you can find sysrq w triggered log messages of the locked processes.
> 
> http://pastebin.com/JWjrbrh4

What kind of workload are you running?  Also did the workload run fine
with an older kernel, and if yes which one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
