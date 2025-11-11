Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F5B2F49FE
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 09:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762854650; cv=none; b=Z9Y8D7GAL2MIXjeaZCPozrjnBf+00tSjw2hPyLLL+/eHPb9hD4BpyXXEneXB3sil77JwzODZiE+MxEqAdsOnQ2uT7z0Q7IYRVpj6cKzzh3rngHfxYa0MAExlosZRbgXaFc1SkfBok2MvBbxKt0wUUSL1+AawAgOIh70WPOOTqTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762854650; c=relaxed/simple;
	bh=d/6qmPIr6XfIAiRzU4wN1UuSbgtZ/Xh4tt0OqSWfrPw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=W4FSAa10DZMtaNmDy67FaL/p5i2daucalzcDLi3TFKlOJHVU3nnHefotx5F8/nUv7bGEWDqt7j1pWJfFGF+MT+nSemIVBldpY8mPgG64TqXspTjuTWxu9liXRZX+1dijkj26LGI4IGedqwHZ99GNAJH2bbFkwKZg0eE6SZtVoW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjDJrOak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjDJrOak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762854647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Scsyq6luIilwuHQq5aSleNZrTNqfMNUGhbn0iJxWQUY=;
	b=KjDJrOakX3AZMWev5w8/JXCx/28oxGIhSTg6rqh8f2VfdePU2P6mBrf9Eb6ky0grA4BRat
	O9e1C9ueAcsE/beBWmxO4Lo45/kySVjm+iLTITDjAxifVfIsj6PgAx258n9ZUQ2GEUpLkT
	u8ZZf1Ffpw2smEBFa8n2i7BbwFsnoqo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-189-PKQaNzSFPMevevEoDCLEzw-1; Tue,
 11 Nov 2025 04:50:23 -0500
X-MC-Unique: PKQaNzSFPMevevEoDCLEzw-1
X-Mimecast-MFC-AGG-ID: PKQaNzSFPMevevEoDCLEzw_1762854621
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A683180028A;
	Tue, 11 Nov 2025 09:50:20 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7082195608E;
	Tue, 11 Nov 2025 09:50:15 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,  "linux-xfs@vger.kernel.org"
 <linux-xfs@vger.kernel.org>,  Carlos Maiolino <cem@kernel.org>,  Dave
 Chinner <david@fromorbit.com>,  "Darrick J . Wong" <djwong@kernel.org>,
  "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,  Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [RFC] xfs: fake fallocate success for always CoW inodes
In-Reply-To: <20251111090547.GC11723@lst.de> (hch@lst.de's message of "Tue, 11
	Nov 2025 10:05:47 +0100")
References: <20251106133530.12927-1-hans.holmberg@wdc.com>
	<lhuikfngtlv.fsf@oldenburg.str.redhat.com>
	<20251106135212.GA10477@lst.de>
	<aQyz1j7nqXPKTYPT@casper.infradead.org>
	<20251106144610.GA14909@lst.de>
	<8b9e31f4-0ec6-4817-8214-4dfc4e988265@wdc.com>
	<20251111090547.GC11723@lst.de>
Date: Tue, 11 Nov 2025 10:50:13 +0100
Message-ID: <lhu4ir0kiei.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

> On Tue, Nov 11, 2025 at 08:31:30AM +0000, Hans Holmberg wrote:
>> In stead of returning success in fallocate(2), could we in stead return
>> an distinct error code that would tell the caller that:
>> 
>> The optimized allocation not supported, AND there is no use trying to
>> preallocate data using writes?
>> 
>> EUSELESS would be nice to have, but that is not available.
>> 
>> Then posix_fallocate could fail with -EINVAL (which looks legit according
>> to the man page "the underlying filesystem does not support the operation")
>> or skip the writes and return success (whatever is preferable)
>
> The problem is that both the existing direct callers of fallocate(2)
> including all currently released glibc versions do not expect that
> return value.

That could be covered by putting a flag into the mode argument of
allocate that triggers the new behavior.

Thanks,
Florian

