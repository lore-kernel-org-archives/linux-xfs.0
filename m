Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC4B77F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 08:26:49 -0500 (CDT)
Message-ID: <5242E494.7080900@sgi.com>
Date: Wed, 25 Sep 2013 08:26:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
References: <1379829679.4089.2.camel@ThinkPad-T5421> <5241E125.7010902@sgi.com>
	<1380094327.2526.5.camel@ThinkPad-T5421>
In-Reply-To: <1380094327.2526.5.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On 09/25/13 02:32, Li Zhong wrote:
> This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
> as suggested by sekharan.
>
> v2: as Mark pointed out, out in the for loop before also needs list to
> be freed. Also remove out lable as it is not referenced any more.
>
> Signed-off-by: Li Zhong<zhong@linux.vnet.ibm.com>
> ---

Thank-you, that looks great.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
