Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96JpCKY198376 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:51:13 -0500
Date: Thu, 6 Oct 2011 15:51:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstest: fsstress should kill children tasks before
	exit
Message-ID: <20111006195109.GH13434@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1317820838.2226.11.camel@doink> <87zkhf369y.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zkhf369y.fsf@dmbot.sw.ru>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, aelder@sgi.com

On Wed, Oct 05, 2011 at 05:41:13PM +0400, Dmitry Monakhov wrote:
> Ok i'll resend patch shortly, Actually test_case was explained inside
> description. So far i've able to caught 3 different minor
> fs-corruptions, one BUG_ON on ext4. And when i've run this test
> on host with 24-cores it deadlock inside dcache core. 

Having the test in the commit message doesn't really help with running
it as part of a regression test suite :)

Please report the details on the dcache deadlock to linux-fsdevel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
