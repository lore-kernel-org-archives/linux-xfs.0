Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13HfBN0149550 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 11:41:11 -0600
Message-ID: <4F2C1C37.60001@sgi.com>
Date: Fri, 03 Feb 2012 11:41:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfsprogs: check for size parsing errors in xfs_quota
References: <4F1D9989.8060808@redhat.com> <20120124175612.GH9853@infradead.org>
	<4F22FA5B.4030500@sandeen.net>
In-Reply-To: <4F22FA5B.4030500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: James Lawrie <james@jdlawrie.co.uk>, xfs-oss <xfs@oss.sgi.com>

On 01/27/12 13:26, Eric Sandeen wrote:
> Doing something like
>
> # xfs_quota -x -c 'limit -u bhard=1.2g ...
>
> will cause cvtnum to fail and return a value of -1LL (because it
> cannot parse the decimal), but the quota caller doesn't check
> for this error value, casts it to U64, shifts right, and we end
> up with an answer of 16 petabytes rather than erroring out.
> Fix this.
>
> Reported-by: James Lawrie<james@jdlawrie.co.uk>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Looks and works great.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
