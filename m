Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868CA1CC15B
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568972; cv=none; b=a7IBw4qj2h3SIbBpHjMy1t54TWBup1NBYT9QP3ZXutM5J+fQ6jKLV4Aa1/RzF6MO8hqrM13+z5G3E44NY3H6jrsuoh4xgsjFjsnUpDBsfcOjSX+hZUz6SRVhZsRJEy9rFg/oPhjF7xNRV1gRg6A9s8W5ENlSib8EJxcOtMY8iHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568972; c=relaxed/simple;
	bh=iniW9mI/M0C48JhzJwZRL5cpXfLadNoh3/DjmqDEi9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyjoQ3Drakhns4NVHY1JJet/qPxWRMd1ke2LQ9lr0TLoTeSUgioY9YIbzb0dplZH2nhxxuHJ4u9CmYFSSFodxoNRS4MIO80ISi3FbqcorRAkRT4FWL/Nu3qxwWfwzlNvyzmWlzaoNfUk7vtyITLKy1azDJnKiucB+7HdXeGfZGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NVgRMJQq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NVgRMJQq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728568969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WntD1/CFbNeVgJTp927xJh9A1Vcn0/F+QKLXYmfTVZQ=;
	b=NVgRMJQqCUqF+6H1YDXqInJJ6Lhw6Zkqw+mqGTREAI3PE5fH8bDeX4u4pDJs46Q+w10a9j
	GI3PBgru48/VDD43XquKlVX2d7tGBeYl2WPhfXaCKmFLr1SuuMHzcBfWw4mH/Lb0qn2NpM
	/V7Ql+3lujeXiPoXLSc/Mftqf4UJwt8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-_QB4SInKOcKpQhxIcbffgw-1; Thu,
 10 Oct 2024 10:02:47 -0400
X-MC-Unique: _QB4SInKOcKpQhxIcbffgw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F52E19560B5;
	Thu, 10 Oct 2024 14:02:46 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 620181956086;
	Thu, 10 Oct 2024 14:02:45 +0000 (UTC)
Date: Thu, 10 Oct 2024 10:04:00 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: error out when a superblock buffer updates
 reduces the agcount
Message-ID: <Zwfe0PDK9cVa8i3d@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-5-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Sep 30, 2024 at 06:41:45PM +0200, Christoph Hellwig wrote:
> XFS currently does not support reducing the agcount, so error out if
> a logged sb buffer tries to shrink the agcount.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 03701409c7dcd6..3b5cd240bb62ef 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3343,6 +3343,10 @@ xlog_recover_update_agcount(
>  	int				error;
>  
>  	xfs_sb_from_disk(&mp->m_sb, dsb);
> +	if (mp->m_sb.sb_agcount < old_agcount) {
> +		xfs_alert(mp, "Shrinking AG count in log recovery");
> +		return -EFSCORRUPTED;
> +	}
>  	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
>  			mp->m_sb.sb_dblocks, &mp->m_maxagi);
>  	if (error) {
> -- 
> 2.45.2
> 
> 

