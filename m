Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oABCmRc8051125 for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 06:48:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D5C113AC4B2
	for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 04:49:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jGblK3gBDvSlB0SG for
	<xfs@oss.sgi.com>; Thu, 11 Nov 2010 04:49:55 -0800 (PST)
Date: Thu, 11 Nov 2010 07:49:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mounting fails on MIPS
Message-ID: <20101111124952.GA11052@infradead.org>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
	<20101104125052.GA22429@infradead.org>
	<AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
	<20101109140527.GA13041@infradead.org>
	<AANLkTik09-0udnrpAJ-mTxMx8iKZ5UTq-ucduQJOZkws@mail.gmail.com>
	<AANLkTik=-jiE5xeJCTQZnbf7AFk7Wzap5ToBDceqsEdH@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTik=-jiE5xeJCTQZnbf7AFk7Wzap5ToBDceqsEdH@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mips@linux-mips.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 11, 2010 at 11:10:33AM +0530, Ajeet Yadav wrote:
> I think mips folks agree with the change. I really wish to have there
> comment.
> 
> I also wish to know do we really need fix in XFS for virtual indexed
> architecture, I think its generic issue as many architecture now use VIVT or
> VIPT caches. Do we want to say XFS is relatively unstable with virtual
> indexed architecture ?

The vmap flushing APIs I repeatedly pointed you at are the generic
solution.  They've been implement for arm, parisc and sh already, it's
just that no one has bothered to do it for mips yet.

Without the proper flushing anything that uses vmap, which includes
XFS is not "relatively unstable" but in fact not usable on systems
with virtually indexed caches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
