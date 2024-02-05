Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1153A3CF58
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707147171; cv=none; b=WuYYGZB0/jQ+W3MiijdStB3gw7fs+f6p1TM+L0DO9JBqrpeeYZDhkFUr0JXlzA1Pyp0TnZXMfaY2EsWUEO0USAmvHL8gUXtDhM48mmqrp9m16JSpVq8tct/B7szOonSIsSl9unPI7CwfcQH1ZVVWdWBuWoboRi7hNLlSMf2wU1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707147171; c=relaxed/simple;
	bh=YjybTbiH6+mn+QYS0STDNx5/X3rF3BbV/TwjTuDcDTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGuSlS2oMTtadqsicaFowz8eO0lGTOKIrCdhFTwAsAAIc7rWsllQZtb5O8mngCYppReZHFZz1j7D0SHwxKQPw4p1D/BPoH3Y3eI4EU+paL+67ZHJxTIUVVGrAHddjKkA/HSQf5JeQ9qCpNP3fpaOpub1eOhAsvTmrjp4J9FvMrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rb7egKHZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rb7egKHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707147169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CsHOpyyNz6zLdrRHdpKUhlbdO+IltU0fGAYIWwSsnME=;
	b=Rb7egKHZrd6O28Tr/eScJxRoF4QGc326DOwamiV2v+TCMD0Aik2345EOFMu7F8EZuF818d
	vZcP4d/GDK1O1qZpbfNTtIT0edrTu34OX2nQF+40YvkZE3Ho3gganMgW+yrilKIoV2g8K8
	hSHj4viwdbnplMFjWkFnXV1w7eQ5wvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-cs0W5ccaM4ODy2vVK0aelA-1; Mon, 05 Feb 2024 10:32:44 -0500
X-MC-Unique: cs0W5ccaM4ODy2vVK0aelA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 348C0863018;
	Mon,  5 Feb 2024 15:32:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C14982166B31;
	Mon,  5 Feb 2024 15:32:43 +0000 (UTC)
Date: Mon, 5 Feb 2024 10:34:02 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.com>, David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] writeback: Remove a use of write_cache_pages()
 from do_writepages()
Message-ID: <ZcD/6iyU6SR28bf4@bfoster>
References: <20240203071147.862076-1-hch@lst.de>
 <20240203071147.862076-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203071147.862076-14-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Sat, Feb 03, 2024 at 08:11:47AM +0100, Christoph Hellwig wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new writeback_iter() directly instead of indirecting
> through a callback.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> [hch: ported to the while based iter style]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

LGTM, modulo Jan's comments:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  mm/page-writeback.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 5fe4cdb7dbd61a..53ff2d8219ddb6 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2577,13 +2577,25 @@ int write_cache_pages(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(write_cache_pages);
>  
> -static int writepage_cb(struct folio *folio, struct writeback_control *wbc,
> -		void *data)
> +static int writeback_use_writepage(struct address_space *mapping,
> +		struct writeback_control *wbc)
>  {
> -	struct address_space *mapping = data;
> -	int ret = mapping->a_ops->writepage(&folio->page, wbc);
> -	mapping_set_error(mapping, ret);
> -	return ret;
> +	struct folio *folio = NULL;
> +	struct blk_plug plug;
> +	int err;
> +
> +	blk_start_plug(&plug);
> +	while ((folio = writeback_iter(mapping, wbc, folio, &err))) {
> +		err = mapping->a_ops->writepage(&folio->page, wbc);
> +		mapping_set_error(mapping, err);
> +		if (err == AOP_WRITEPAGE_ACTIVATE) {
> +			folio_unlock(folio);
> +			err = 0;
> +		}
> +	}
> +	blk_finish_plug(&plug);
> +
> +	return err;
>  }
>  
>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
> @@ -2599,12 +2611,7 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  		if (mapping->a_ops->writepages) {
>  			ret = mapping->a_ops->writepages(mapping, wbc);
>  		} else if (mapping->a_ops->writepage) {
> -			struct blk_plug plug;
> -
> -			blk_start_plug(&plug);
> -			ret = write_cache_pages(mapping, wbc, writepage_cb,
> -						mapping);
> -			blk_finish_plug(&plug);
> +			ret = writeback_use_writepage(mapping, wbc);
>  		} else {
>  			/* deal with chardevs and other special files */
>  			ret = 0;
> -- 
> 2.39.2
> 

