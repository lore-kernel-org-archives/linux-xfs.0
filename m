Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3B837F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 04:39:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DE33AC0BA
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 02:39:53 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EUyh2dwiSYGEWAUZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 02:39:52 -0700 (PDT)
Date: Mon, 16 Jun 2014 02:39:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: add mount options to xfs.5 manpage
Message-ID: <20140616093952.GB26172@infradead.org>
References: <5398B5ED.6030703@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5398B5ED.6030703@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Karel Zak <kzak@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 11, 2014 at 03:02:53PM -0500, Eric Sandeen wrote:
> This is a straight cut and paste from the util-linux
> mount manpage to xfs.5.
> 
> It's pretty much impossible for util-linux to keep up
> with every filesystem out there, and Karel has more than
> once expressed a wish that mount options move into fs-specific
> manpages.
> 
> So, here we go.

Looks reasonable, but it seems there it seems to lack documentation
for the biosize option.  Also it would be good to mention which
options could be changed using remount, as our limited set for that
seems to confuse users a lot.

Is it worth mentioning the various deprecated options thast the kernel
just warns about now?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
