Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7BA77F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:34:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6B61304043
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 09:34:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id VDYqj2ADzRId4E7f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 09:34:18 -0800 (PST)
Date: Thu, 13 Nov 2014 09:34:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] quota: Split ->set_xstate callback into two
Message-ID: <20141113173416.GA31481@infradead.org>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-5-git-send-email-jack@suse.cz>
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

On Tue, Nov 11, 2014 at 10:04:18PM +0100, Jan Kara wrote:
> Split ->set_xstate callback into two callbacks - one for turning quotas
> on (->sysquota_on) and one for turning quotas off (->sysquota_off). That
> way we don't have to pass quotactl command into the callback which seems
> cleaner.

Yes, I much prefer these to be split.  But the names seem a little odd,
why not enable_quota/disable_quota?

> +static unsigned int generic_to_xfs_flags(unsigned int uflags)

xfs_quota_flags() ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
