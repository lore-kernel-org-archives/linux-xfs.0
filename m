Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 853557CCC
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 02:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 097DFAC002
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 00:56:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id chhUBGv3nBjB7juP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2016 00:56:04 -0700 (PDT)
Date: Mon, 8 Aug 2016 15:56:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 12/17] reflink: test cross-mountpoint reflink and dedupe
Message-ID: <20160808075601.GA27776@eguan.usersys.redhat.com>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 04:47:32PM -0700, Darrick J. Wong wrote:
> Test sharing blocks via reflink and dedupe between two different
> mountpoints of the same filesystem.  This shouldn't work, since
> we don't allow cross-mountpoint functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

> +
> +# real QA test starts here
> +_supported_os Linux

I added "_supported_fs generic"

> +_require_scratch_reflink
> +_require_cp_reflink

> +
> +filter_md5() {

and move "{" to a new line. Also made the same changes to 928 and queued
the patch up.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
