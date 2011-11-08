Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8H4r4T134590 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 11:04:56 -0600
Date: Tue, 8 Nov 2011 12:04:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111108170446.GA17399@infradead.org>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
	<20111107132533.GP12759@twin.jikos.cz> <87sjm0kqjk.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sjm0kqjk.fsf@dmbot.sw.ru>
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
Cc: tytso@mit.edu, xfs@oss.sgi.com, dave@jikos.cz, aelder@sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Mon, Nov 07, 2011 at 05:31:11PM +0400, Dmitry Monakhov wrote:
> Have you recompile fsstress via make?
> test explicitly want use new feature "-f setattr=1"

Btw, one useful thing for these patches would be to clearly error
out if fsstress does't recognize the option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
