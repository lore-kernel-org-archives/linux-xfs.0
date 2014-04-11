Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B08957F99
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 19:16:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EDDB304039
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 17:16:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q133sncApEC0fCkR for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 17:16:38 -0700 (PDT)
Date: Fri, 11 Apr 2014 10:16:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Add -s option to run only specified sections
Message-ID: <20140411001617.GE15995@dastard>
References: <1397151352-6614-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397151352-6614-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 07:35:52PM +0200, Lukas Czerner wrote:
> This commit adds -s option which allows you to specify only certain
> sections from the config file to be run. The '-s' argument can be
> specified multiple times to allow multiple sections to be run.
> 
> The options are still carried between section, that includes the
> sections which are not going to be run.
> 
> Update README.config-sections as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Neat. Looks simple enough.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
