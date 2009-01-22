Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MMQNmn116810 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:26:24 -0600
Date: Thu, 22 Jan 2009 17:25:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
Message-ID: <20090122222539.GA9643@infradead.org>
References: <49378B60.1060603@sgi.com> <20081222085354.GC24795@infradead.org>
	<49502F91.4050406@sgi.com> <49742371.2000806@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49742371.2000806@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 19, 2009 at 05:53:37PM +1100, Lachlan McIlroy wrote:
> Lachlan McIlroy wrote:
> > Christoph Hellwig wrote:
> >> Did you guys come to a conclusion in your discussions?
> >>
> > No conclusion, well nothing that resulted in an ack.
> 
> Was anyone okay with this fix?

I think it's okay to go.  It fixes the one off so it's go.

The code is still a very hard to understand mess, but that's not what
the patch was supposed to fix..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
