Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBA6F7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:36:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA9408F804C
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 09:36:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 59uAyjomEhWKmZKK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 09:36:01 -0800 (PST)
Date: Thu, 13 Nov 2014 09:36:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/11] ext4: Use generic helpers for quotaon and quotaoff
Message-ID: <20141113173600.GB31481@infradead.org>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-8-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

>  static const struct quotactl_ops ext4_qctl_sysfile_operations = {
> -	.quota_on_meta	= ext4_quota_on_sysfile,
> -	.quota_off	= ext4_quota_off_sysfile,
> +	.sysquota_on	= dquot_sysquota_on,
> +	.sysquota_off	= dquot_sysquota_off,
>  	.quota_sync	= dquot_quota_sync,
>  	.get_info	= dquot_get_dqinfo,
>  	.set_info	= dquot_set_dqinfo,

This vector now only has generic dquot_ methods.  Maybe move the
vector to fs/quota/dquot.c and allow multiple filesystems to share it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
