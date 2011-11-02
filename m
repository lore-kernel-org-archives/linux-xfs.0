Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2L6eJV200528 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 16:06:40 -0500
Date: Wed, 2 Nov 2011 17:06:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111102210635.GA20955@infradead.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-8-git-send-email-dmonakhov@openvz.org>
	<20111102195357.GA22500@infradead.org> <8739e6z2gb.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8739e6z2gb.fsf@dmbot.sw.ru>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, aelder@sgi.com, hch@lst.de, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 12:36:36AM +0400, Dmitry Monakhov wrote:
> Strange... this means that parent process died unexpectedly.
> Works fine fore me. In my case this happen once due to unknown
> options(new opt " -fsetattr=1" passed to fsstress explicitly) because i've
> forget to rebuilt fsstress via make. Can you please explicitly rebuild,
> and check one more time to be 100% sure.

Oh, looks like it wanted the setattr option.  I held back all the new
features for now until we figure if we want them for existing tests.

I've applied and pushed out the first three patches for now, the others
should follow as soon as I've decided on what to do with new operations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
