Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 849847F5A
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:16:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F092304039
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 12:16:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Jtn1N9bBFPaAyCgp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 12:16:44 -0700 (PDT)
Date: Tue, 15 Oct 2013 12:16:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: filter projid32bit info out of growfs & info
	output
Message-ID: <20131015191642.GB3008@infradead.org>
References: <5251C392.1020407@redhat.com>
 <20131008004317.GR4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131008004317.GR4446@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 08, 2013 at 11:43:17AM +1100, Dave Chinner wrote:
> Yup, that's needed. There's a bunch of other things we need to do to
> correctly test 16/32bit project ids without failures. Have a look
> here:
> 
> http://oss.sgi.com/archives/xfs/2013-06/msg00219.html
> 
> For the mods I posted back in June to avoid failures with the CRC
> enabled filesystems in tests that assume certain options can be
> turned on/off on XFS filesystems.
> 
> I'm still running xfstests with that patch....

Would be good to get it in ASAP!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
