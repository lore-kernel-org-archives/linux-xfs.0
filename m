Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n598dlqR023048
	for <linux-xfs@oss.sgi.com>; Tue, 9 Jun 2009 03:39:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEA118D3B14
	for <linux-xfs@oss.sgi.com>; Tue,  9 Jun 2009 01:47:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qNk3xJjBjvzdH44w for
	<linux-xfs@oss.sgi.com>; Tue, 09 Jun 2009 01:47:11 -0700 (PDT)
Date: Tue, 9 Jun 2009 04:40:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090609084006.GA31760@infradead.org>
References: <20090520003745.GA27491@samad.com.au>
	<h0hbb2$1358$1@osprey.mgras.de> <h0jrcu$tkc$1@osprey.mgras.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <h0jrcu$tkc$1@osprey.mgras.de>
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
To: Martin Spott <Martin.Spott@mgras.net>
Cc: linux-xfs@oss.sgi.com

On Mon, Jun 08, 2009 at 08:13:18PM +0000, Martin Spott wrote:
> Martin Spott wrote:
> > Christoph Hellwig wrote:
> > 
> >> I recently started auditing the code and started to fix some locking
> >> issues in there, could you give the patch below a try?
> > 
> >  http://foxtrot.mgras.net/static/messages-20090607.2.bz2
> > 
> > I'm sorry but I'll have to boot the system using the previous kernel,
> 
> Next 'maintenance window'  ;-)  starts wednesday evening. Please advise
> if you'd like me to perform further tests,

For now I'd love you to test the locking patch I sent you in my last
mail.  In the meantime I still fail to reproduce anything like your
problem locally.  I know we do need to reboot the machine or
unexport/rexport the nfs export while it's mounted on a client to hit
the codepath, but even while running stree tests on an nfs client while
continuesly un/reexporting things on the server I can't hit it.

> 
> 	Martin.
> -- 
>  Unix _IS_ user friendly - it's just selective about who its friends are !
> --------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
