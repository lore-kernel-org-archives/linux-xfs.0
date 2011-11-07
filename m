Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7GwTmV068171 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 10:58:29 -0600
Message-ID: <4EB80E34.9070704@sgi.com>
Date: Mon, 07 Nov 2011 10:58:28 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add 059 and 060 for multi-stream xfsdump
References: <1320322464-6559-1-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320322464-6559-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On 11/03/2011 07:14 AM, Bill Kendall wrote:
> Implement the multi-stream placeholder tests 059 and 060. The comments
> imply that these tests existed on IRIX, but I was unable to find them.
>
> Test 059 does a simple 4-way dump and restore. Test 060 does a 4-way
> dump, then restores each dump file individually (in a cumulative
> fashion).
>
> The tests are skipped if the installed xfsdump does not support
> multi-stream output.
>
> Signed-off-by: Bill Kendall<wkendall@sgi.com>
> ---
>   059         |   23 ++++++++++++++---------
>   060         |   29 ++++++++++++++++++++---------
>   common.dump |   40 ++++++++++++++++++++++++++++++++++++++--
>   group       |    4 ++--
>   4 files changed, 74 insertions(+), 22 deletions(-)

I realized the .out files were not included in my patch.
I'll repost shortly...

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
