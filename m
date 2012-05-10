Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AK0T7T056624 for <xfs@oss.sgi.com>; Thu, 10 May 2012 15:00:29 -0500
Message-ID: <4FAC1E5A.6050207@sgi.com>
Date: Thu, 10 May 2012 15:00:26 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity test
References: <4F410ABF.7070001@oracle.com>
In-Reply-To: <4F410ABF.7070001@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 02/19/12 08:44, Jeff Liu wrote:
> Introduce 279 for SEEK_DATA/SEEK_HOLE sanity tests.
>
> Changes to v3:
> --------------
> * Redirect seek sanity test run log to 279.full.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   279                    |   58 ++++
>   279.full               |  116 ++++++++
>   279.out                |    1 +
>   group                  |    1 +
>   src/Makefile           |    2 +-
>   src/seek_sanity_test.c |  683 ++++++++++++++++++++++++++++++++++++++++++++++++
>   6 files changed, 860 insertions(+), 1 deletions(-)
>   create mode 100755 279
>   create mode 100644 279.full
>   create mode 100644 279.out
>   create mode 100644 src/seek_sanity_test.c
>
> diff --git a/279 b/279
> new file mode 100755
> index 0000000..b9e9cc3
> --- /dev/null
> +++ b/279
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# FS QA Test No. 279
> +#
> +# SEEK_DATA/SEEK_HOLE sanity tests.
> +#
> +# Improved by Jeff.liu@oracle.com
> +# Creater: josef@redhat.com
> +#

The first open test is 285 now.

It is is a good start of a XFS SEEK_DATA/SEEK_HOLE test.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
