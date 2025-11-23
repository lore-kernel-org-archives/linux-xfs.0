Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1724812F5A5
	for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763905776; cv=none; b=bVv/yGCA9SFd3qbqr/c07i0NEv2mlStSC+xtykKEyvYVk7EmO+Mf2a1btM1sVl1izdwKM2wLWsgjaN7MKW/EoS0uFKaoDI+U0dFHc9jg4Bo70g+ptvVhvPq1+kX9SsyyCb++AkVl4s50z7N46liub3SGELIsMexo4NrA5zvKF4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763905776; c=relaxed/simple;
	bh=lWbENcEh389vbMCqSvNUZZKi4TBeYFD6rNt9N2yVjFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQFCad8iKaIjCYuZxYepe9sCO4EKEoNfDkmM8xBguWpMEDXUlUUjZirP8Njxmy0HRbHHeZF8wxHxSNxpMgNMozJpOyI7hKV+xZN32rOIGu5kQWy4Ya8qTUed3jtaU4eyvk5WwEMy0a69vLcBvsjRR3VN56cQIiPU5mlpV09FhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g+o+63Ca; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+o+63Ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763905771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hRt8RZtumHYeZ62c0KfBKB9aID9kM568jUutNHXhRA=;
	b=g+o+63CanVDf2aBYD890+iC73OffoWngMg8CL8jIad1YaJJF9tpqbxpAj7+CKbh1yASRx9
	d/rpd13Y0GHnfqSJuVvq9TOz7YvTuHXeC6NSt7jBpobaiTrIb3F+OOieuU9139Usf+JJJh
	JtLDMkDex9dXgmm0vFKa9mrn1JpaZ7E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-JoNijKGXNZWpb1v6IBGpVw-1; Sun,
 23 Nov 2025 08:49:18 -0500
X-MC-Unique: JoNijKGXNZWpb1v6IBGpVw-1
X-Mimecast-MFC-AGG-ID: JoNijKGXNZWpb1v6IBGpVw_1763905754
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C2AF180045C;
	Sun, 23 Nov 2025 13:49:13 +0000 (UTC)
Received: from fedora (unknown [10.72.116.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E12D91800451;
	Sun, 23 Nov 2025 13:49:02 +0000 (UTC)
Date: Sun, 23 Nov 2025 21:48:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Stephen Zhang <starzhangzsd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn,
	Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSMQyCJrqbIromUd@fedora>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora>
 <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
 <aSGmBAP0BA_2D3Po@fedora>
 <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sat, Nov 22, 2025 at 03:56:58PM +0100, Andreas Gruenbacher wrote:
> On Sat, Nov 22, 2025 at 1:07 PM Ming Lei <ming.lei@redhat.com> wrote:
> > > static void bio_chain_endio(struct bio *bio)
> > > {
> > >         bio_endio(__bio_chain_endio(bio));
> > > }
> >
> > bio_chain_endio() never gets called really, which can be thought as `flag`,
> 
> That's probably where this stops being relevant for the problem
> reported by Stephen Zhang.
> 
> > and it should have been defined as `WARN_ON_ONCE(1);` for not confusing people.
> 
> But shouldn't bio_chain_endio() still be fixed to do the right thing
> if called directly, or alternatively, just BUG()? Warning and still
> doing the wrong thing seems a bit bizarre.

IMO calling ->bi_end_io() directly shouldn't be encouraged.

The only in-tree direct call user could be bcache, so is this reported
issue triggered on bcache?

If bcache can't call bio_endio(), I think it is fine to fix
bio_chain_endio().

> 
> I also see direct bi_end_io calls in erofs_fileio_ki_complete(),
> erofs_fscache_bio_endio(), and erofs_fscache_submit_bio(), so those
> are at least confusing.

All looks FS bio(non-chained), so bio_chain_endio() shouldn't be involved
in erofs code base.


Thanks,
Ming

