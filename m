Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p729tfHU095693 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 04:55:41 -0500
Date: Tue, 2 Aug 2011 05:55:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: allow multi-digit dialog prompts
Message-ID: <20110802095537.GA1248@infradead.org>
References: <1311784913-14191-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311784913-14191-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 27, 2011 at 11:41:53AM -0500, Bill Kendall wrote:
> xfsdump issues a multiple-choice dialog in various circumstances
> (e.g., media change request). An assert incorrectly limits this to
> at most 8 choices even though the code can handle up to 9.  Remove
> the assert and change the code to handle multi-digit responses.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
