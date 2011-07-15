Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FDkwn9206019 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 08:46:58 -0500
Subject: Re: [PATCH 1/1] XFS TESTS: Correct extent flag parsing for punch
	hole tests
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
Date: Fri, 15 Jul 2011 08:46:54 -0500
Message-ID: <1310737614.2921.4.camel@doink>
MIME-Version: 1.0
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2011-07-14 at 20:52 -0700, Allison Henderson wrote:
> The fiemap filters used in the punch hole tests parse the
> extent flags in the fiemap to determine the extent type.
> They are currently parsing them as decimal values, but
> they should be parsing hex values.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

Looks good to me.  This may not have a practical
effect but it looks correct now.

I will commit this for you.  Thanks for fixing it.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
