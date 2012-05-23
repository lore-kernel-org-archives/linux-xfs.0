Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4NDCKTY163414 for <xfs@oss.sgi.com>; Wed, 23 May 2012 08:12:20 -0500
Message-ID: <4FBCE22F.80205@sgi.com>
Date: Wed, 23 May 2012 08:12:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 030: fix for new xfs_repair versions
References: <20120331232836.GA19572@infradead.org> <4F848278.501@sgi.com>
In-Reply-To: <4F848278.501@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 04/10/12 13:56, Mark Tinguely wrote:
> On 03/31/12 18:28, Christoph Hellwig wrote:
>> Given that we now drop invalid unlinked inode lists there is no message
>> to capture. Also add a sed expression to avoid failures on old repair
>> versions.
>>
>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>
>
>
> This is something that worked on an older OS:
>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> 030 | 3 ++-
> 030.out.linux | 1 -
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: b/030
> ===================================================================
> --- a/030
> +++ b/030
> @@ -55,7 +55,8 @@ _check_ag()
> for structure in 'sb 0' 'agf 0' 'agi 0' 'agfl 0'
> do
> echo "Corrupting $structure - setting bits to $1"
> - _check_repair $1 "$structure"
> + _check_repair $1 "$structure" |
> + sed -e '/^error following ag 0 unlinked list$/d'
> done
> }
>
> Index: b/030.out.linux
> ===================================================================
> --- a/030.out.linux
> +++ b/030.out.linux
> @@ -85,7 +85,6 @@ bad agbno AGBNO for inobt root, agno 0
> root inode chunk not found
> Phase 3 - for each AG...
> - scan and clear agi unlinked lists...
> -error following ag 0 unlinked list
> - process known inodes and perform inode discovery...
> - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

ping.

People are still listing 030 as broken. We should get this fixed.

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
