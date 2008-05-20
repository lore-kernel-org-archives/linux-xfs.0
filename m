Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 13:49:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KKnOUf002313
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 13:49:24 -0700
Message-ID: <4833397B.2000109@oracle.com>
Date: Tue, 20 May 2008 13:50:03 -0700
From: Sunil Mushran <Sunil.Mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com> <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk> <op.ubfkzvjx3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080520182315.GA8456@infradead.org>
In-Reply-To: <20080520182315.GA8456@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, Anton Altaparmakov <aia21@cam.ac.uk>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Christoph Hellwig wrote:
> The cond_resched_lock here is not safe here, because the pointer you
> are going to dereference in list_for_each_entry might not be valid
> anymore.  This should look more like:
>
> void d_drop_negative_children(struct dentry *parent)
> {
> 	struct dentry *dentry;
>
>  again:
> 	spin_lock(&dcache_lock);
> 	list_for_each_entry(dentry, &parent->d_subdirs, d_u.d_child) {
> 		if !(dentry->d_inode)
> 			continue;
>
> 		spin_lock(&dentry->d_lock);
> 		__d_drop(dentry);
> 		spin_unlock(&dentry->d_lock);
>
> 		if (need_resched()) {
> 			spin_unlock(&dcache_lock);
> 			cond_resched();
> 			goto again;
> 		}
> 	}
> 	spin_unlock(&dcache_lock);
> }
>   
Yes, we have been bitten by the same issue.

Instead of need_resched(), it may be better if you do:

		if (cond_resched_lock(&dcache_lock))
			goto again;
