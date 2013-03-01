Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B1237FC3
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:43:17 -0600 (CST)
Message-ID: <5130CC96.7020705@sgi.com>
Date: Fri, 1 Mar 2013 09:43:18 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/10] xfstest: add configurable load factors
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-3-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> Most stress test has probable behauviour, the longer test run the
> larger corner cases will be cover. It is reasonable to allow
> user to provide some sort of system load factor.
> This patch introduce two global variables
> LOAD_FACTOR: Usually means factor number of running tasks
> TIME_FACTOR: Usually means factor of run time, or number of operations
> If not speficied both variables defined to 1, so original behaviour
> preserved.
>
> TODO: Change all stress tests to use this variables
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Nice addition, looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
