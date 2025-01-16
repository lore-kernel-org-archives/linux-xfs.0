Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2C1DE2B9
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737037321; cv=none; b=BK1cO9ZpWnJtqvsJdaKr+XxwAqBz5BVUF5AVgD562ZBHeOFe3H1VzxJSzEEbuKvPm3WqOoDK3pGHwAcOfgl5jyY3gwe6DdBJIMiSCkAVxpkPCSa5K6W0yAZ5IgeNlzmENz1/+aWVWZQu/wN8zm2CdGttobKyOy0+jz9c434nYO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737037321; c=relaxed/simple;
	bh=mCw18u2J6qPjqZ+8x4vbOPTeiIF0IlEEGCCGLoE77y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loYITNqS4Xs2XrmzKi24YozX22ZJFCQGjtp2RP6hmtawBAWaBnGXA9qVzMvEtIDiSd/L7YvCc2af7CIPv6D5SUaTPEVxqSeU5NwMnSk+hhZ1Zn98lban1tinkn7NfcfZwdLfYnIFW50XUcvtGjK1GqDG8HK1SBRHal6EOQnHWyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BRgqG7zI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRgqG7zI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737037318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tp7+GNNEsMl5oBvFWsGmcrfew9326ftMjsVHomAf348=;
	b=BRgqG7zIOCtEpjoIp7ac97R7dAdfEPRWiVuJiI9BrIYXkdOqktlfd2vUIzBx7eTCVnictU
	9zz+xsRS1effa8c3PPxM+FqSicvzuUi5a1xRbY2quoUTd3MaAD5ftJrpkytyfbx/SizETy
	6GWR8WA9gxTUad6sgIeEyh81HTzO5d8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-vg9s_JarObKFLM4j5hafSw-1; Thu,
 16 Jan 2025 09:21:52 -0500
X-MC-Unique: vg9s_JarObKFLM4j5hafSw-1
X-Mimecast-MFC-AGG-ID: vg9s_JarObKFLM4j5hafSw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD3BC1955DA7;
	Thu, 16 Jan 2025 14:21:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 258111955F10;
	Thu, 16 Jan 2025 14:21:46 +0000 (UTC)
Date: Thu, 16 Jan 2025 09:23:59 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4kWf4oCHNd86Hkd@bfoster>
References: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4grgXw2iw0lgKqD@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Jan 16, 2025 at 08:41:21AM +1100, Dave Chinner wrote:
> On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
> > On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
...
> 
> > I don't really have time to turn this hand waving into, but maybe we 
> > should think if it's worthwhile or if I'm missing something important.
> 
> If people are OK with XFS moving to exclusive buffered or DIO
> submission model, then I can find some time to work on the
> converting the IO path locking to use a two-state shared lock in
> preparation for the batched folio stuff that will allow concurrent
> buffered writes...
> 

Ack to this, FWIW. I think this is a natural/logical approach,
prototyping and whatnot notwithstanding.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

