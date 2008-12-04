Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CaGrK027364 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:36:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECDC31B2D1EE
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 04:36:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5ea2TBdLFZG4fnOH for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 04:36:15 -0800 (PST)
Date: Thu, 4 Dec 2008 07:35:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 12/22] kill dead inode flags
Message-ID: <20081204123545.GD7085@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.264876000@bombadil.infradead.org>
	<87r64o7k57.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87r64o7k57.fsf@cxhome.ath.cx>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 04, 2008 at 01:24:04PM +1100, Niv Sardi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > There are a few inode flags around that aren't used anywhere, so remove
> > them.  Also update xfsidbg to display all used inode flags correctly.
> 
> Thanks for splitting things up, you have your idbg patch somewhere
> though ? should the reference to it be removed from the commit ?

No, sorry.  When I ported things to the new tree I lost those changes.
Given that I do all work on the master branch don't expect fixes for
these bits unless it's specificly for the -dev branch (e.g. dmapi).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
