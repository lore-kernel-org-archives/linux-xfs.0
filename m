Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F16EA7FDD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:37:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA908304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:37:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id DGhhMXHNrCgB3VMk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:37:45 -0700 (PDT)
Date: Tue, 6 May 2014 01:37:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140506083744.GA9976@infradead.org>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506075905.GA5421@dastard>
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
Cc: xfs@oss.sgi.com

I like this in general, but one major and one minor issue with
the include files:

 - headers that just include other headers are a bad idea in general.
   Either they are dependent enough that they should be merged, or
   they are not, in which case they shouldn't.

   In this case it seems like we should temporarily provide a
   xfs_mount.h stub in userspace, and just leave all the includes
   for things in libxfs.h as they were.  That doesn't preclude further
   merging of the headers into more sensible ones as we've started
   with the disk formats.
 
 - do we really need the separate include/ dir?  That always annoys
   me when editing code.  It makes sense for something that is a real
   public interface, which this is not.

Also is libxfs/ really the right name?  libxfs in userspace has quite
a bit more code than this, so maybe we should just called this "shared"
for the shared user/kernel code?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
