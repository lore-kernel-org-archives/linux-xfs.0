Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F78326D44
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750863; cv=none; b=q8Tn6m3lrP8ERa3uE+IYCyszVS5ZYGmF0XPR+r60odCJxmmkiZdke2k31gp6sB9xBYa+Al8GqoittwT3e5DvjbvwXaDbFO2G8wiVbTYYokG8sMGBIWD4q6maytNbdJQdgs/CGDiN80SW/PNmAP9VJ/PJ7BTEOWRlIckmi0sGJlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750863; c=relaxed/simple;
	bh=a2MedpXYJ/WWBxJR4ZubXioWf8I0yl8QMk755YFCpWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXh/DGte9U1yOCy7hH0FvmcC560HAnhFdZ7lsX2VRtEoNr8RBZWJQ6DCp7j0NYnwwa6OYkXhP+v7zU+hGBP66FtkDC47nUdG2OY59mZu18lr6rCcQCznMtqpihyLsOREEJrSSKDMDut2QcS5PfMEe0qKvfmRo7s2Egm8T8wVvcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K1HMgm/L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1HMgm/L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770750861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dcj/eGMjgm49uADtPlV4T2MT7+Gx/kjw3bCB2opkvMg=;
	b=K1HMgm/Lkr0h6EncziRZ8N8SocZkGdFVFoi/fMK11ckjqSAWOP3b+JBM7aobly+FG65a6G
	BlhLBJRYsg/E+PFmiaymUcrtPHsoBAu+qTkqy/+Gjotw2lkCwa6g9mxh6x8GfCJCIF4B8t
	EfnvbjoaUdfJ016eYxxpNNiL4m9kH8w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-h6J-58aiOkKKK2UjE9g4mw-1; Tue,
 10 Feb 2026 14:14:17 -0500
X-MC-Unique: h6J-58aiOkKKK2UjE9g4mw-1
X-Mimecast-MFC-AGG-ID: h6J-58aiOkKKK2UjE9g4mw_1770750857
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 043761956095;
	Tue, 10 Feb 2026 19:14:17 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ED5119560A3;
	Tue, 10 Feb 2026 19:14:15 +0000 (UTC)
Date: Tue, 10 Feb 2026 14:14:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aYuDhQj_xw3ByeD5@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <aYtZtuqy72C0VvnQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtZtuqy72C0VvnQ@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Feb 10, 2026 at 08:15:50AM -0800, Christoph Hellwig wrote:
> This looks sensible to me.  I'll add it to my zoned xfs test queue
> to make sure it doesn't break anything there, but as the zoned
> iomap_begin always allocates new space it should be fine.
> 
> 

Thanks. As you've probably noticed from looking through the rest of the
patches, this one is mainly a lift-and-shift initial step from iomap to
xfs. Let me know if anything breaks.

Brian

