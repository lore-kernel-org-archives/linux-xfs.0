Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2114B7FC1
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:56:05 -0500 (CDT)
Date: Thu, 31 Oct 2013 10:56:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs:xfs_dir2_node.c: pointer use before check for null
Message-ID: <20131031155602.GP1935@sgi.com>
References: <20131022203322.GA2797@dastard>
	<1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
	<20131025150609.GB10553@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131025150609.GB10553@sgi.com>
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
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: ldv-project@linuxtesting.org, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 10:06:09AM -0500, Ben Myers wrote:
> On Fri, Oct 25, 2013 at 03:53:25PM +0400, Denis Efremov wrote:
> > ASSERT on args takes place after args dereference.
> > This assertion is redundant since we are going to panic anyway.
> > 
> > Found by Linux Driver Verification project (linuxtesting.org) -
> > PVS-Studio analyzer.
> > 
> > Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> 
> Looks good. 
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks Denis.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
