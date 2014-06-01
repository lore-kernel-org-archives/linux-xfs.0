Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC2087F87
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 20:25:16 -0500 (CDT)
Received: from eagdhcp-232-192.americas.sgi.com
	(eagdhcp-232-192.americas.sgi.com [128.162.232.192])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A37598F8037
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 18:25:16 -0700 (PDT)
Message-ID: <538A80FC.10809@sgi.com>
Date: Sat, 31 May 2014 20:25:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
	<53850F92.7010401@sgi.com> <20140527225138.GD8554@dastard>
	<53851836.2070301@sgi.com> <20140528002906.GH8554@dastard>
	<538743E0.70103@sgi.com> <20140531003918.GI14410@dastard>
	<538A8064.2030304@sgi.com>
In-Reply-To: <538A8064.2030304@sgi.com>
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
To: xfs@oss.sgi.com

On 05/31/14 20:22, Mark Tinguely wrote:
>
> The xfs_inode thinks there are 11 bmbt entries when there should only be
> 11:
>    i_df = {
>      if_bytes = 0xb0, <- here 11 entries 0x10 bytes long

sorry bad editing when I could not do hex math. There are 11 entries, 
should be 11 entries, but we have one missing entry and one garbage entry.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
