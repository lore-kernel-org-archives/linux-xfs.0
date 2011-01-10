Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AKKV1u038486 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 14:20:31 -0600
Subject: Re: [PATCH 01/12] xfsprogs: some things aren't all that special
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110110201137.GA27277@infradead.org>
References: <1293741599.2294.342.camel@doink>
	<20110110201137.GA27277@infradead.org>
Date: Mon, 10 Jan 2011 14:22:36 -0600
Message-ID: <1294690956.5374.48.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2011-01-10 at 15:11 -0500, Christoph Hellwig wrote:
> Also you've stopped overwriting orphanage_ino if it already exists.

Actually, I had noticed I did more (or worse) than
just that.  Once orphanage_ino has been saved, my
change no longer says it should avoid obfuscating
it.  (Or is that what you mean by "overwriting"?)

Anyway, I noticed that problem the other day and
thought I'd fix it if I had a chance to re-post.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
