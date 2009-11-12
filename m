Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACAKg5l241942 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 04:20:42 -0600
Date: Thu, 12 Nov 2009 05:21:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/14] repair: cleanup helpers for tracking block usage
Message-ID: <20091112102100.GD25058@infradead.org>
References: <20090902175841.479553130@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ADF0@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADF0@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 21, 2009 at 02:33:05PM -0500, Alex Elder wrote:
> > +	switch (state != XR_E_UNKNOWN)  {
> 
> BUG.      You mean "if (state != XR_E_UNKNOWN)"???

Oops, yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
