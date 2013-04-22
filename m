Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E50AE7F3F
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 08:45:15 -0500 (CDT)
Message-ID: <51753EF6.6040905@sgi.com>
Date: Mon, 22 Apr 2013 08:45:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: fix common filter include in filter.btrfs
References: <517386CC.8010406@redhat.com> <51746D07.5090300@sandeen.net>
	<51746D8A.60707@sandeen.net>
In-Reply-To: <51746D8A.60707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 04/21/2013 05:51 PM, Eric Sandeen wrote:
> Not sure how this happened, but filter.btrfs including
> itself leads to immense sadness for any file that includes it.
> (I got a segfault when I tried to run 307)
>
> It should be including ./common/filter not ./common/filter.btrfs
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> cripes, I'm sorry that took 3 times to get right :/
>

Third time is the charm ;) Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
