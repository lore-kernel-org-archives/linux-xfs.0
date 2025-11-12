Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C12882CE
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762957148; cv=none; b=W0NMxEeT+zmT7DlKsmzUAsSgPgj8vhZHxEYk1uIacGLG4tv7cuW0DobINKtJ0EuNsF7cgQEXYc/s5BazPl8aXuesMy/v89rmaNCuhXyU2ufTRZMGMcIFUjWCq9Wjzv3d7BHbP6QLz80FF/5t4Fp08r+QnR8m2hN7wjLKYKaYa2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762957148; c=relaxed/simple;
	bh=t+kYm055Q/4/JVRyEGrqO/ETHMRrbbqvnDg9NCLuJQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsjO0zVhTM3UQCvsNiChkb7eMt37DfjDDpaSZhcw86e4mnGyZgqFLSk1hm2Mw7n26YO1/z0EQgiTlMUtNUs+iYBpBItg7tdX7wSoXxfQ6yyL3ei5TPkapOc1Zd5IdRl0r5DqygZBwwu3AWkZRngNfNfMJ30DNXERWLlaezKsZ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/IQIiy3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/IQIiy3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762957146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11dzZTZID/e9Yjzv4yjI8lw4KBQwSPfbDNh4cEy8sp8=;
	b=H/IQIiy3ykeWgaw7Q7k92J1WZ8nQydY0zQXphvUiLXoDjhc+vU1U/Y8c7fGJsMP5WUIpBp
	zLQ2G012m+Y/yOpWZorUQpWMTYjB2XdmafWIPNtVeLQs1hUHf3bBoTLH1LX1GN19pVTQJv
	Bpb4k37IFItw4QdN09dJ+0L7Xwd07qQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-XOLzT4QWP0C5oz8QabkWEQ-1; Wed,
 12 Nov 2025 09:19:02 -0500
X-MC-Unique: XOLzT4QWP0C5oz8QabkWEQ-1
X-Mimecast-MFC-AGG-ID: XOLzT4QWP0C5oz8QabkWEQ_1762957141
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 785BA18002C2;
	Wed, 12 Nov 2025 14:19:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.179])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BECD31800947;
	Wed, 12 Nov 2025 14:18:52 +0000 (UTC)
Date: Wed, 12 Nov 2025 22:18:40 +0800
From: Ming Lei <ming.lei@redhat.com>
To: hch <hch@lst.de>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
	Keith Busch <kbusch@kernel.org>, Dave Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: fall back from direct to buffered I/O when stable writes are
 required
Message-ID: <aRSXQKgkV55fFtNG@fedora>
References: <20251031130050.GA15719@lst.de>
 <aQTcb-0VtWLx6ghD@kbusch-mbp>
 <20251031164701.GA27481@lst.de>
 <kpk2od2fuqofdoneqse2l3gvn7wbqx3y4vckmnvl6gc2jcaw4m@hsxqmxshckpj>
 <20251103122111.GA17600@lst.de>
 <20251104233824.GO196370@frogsfrogsfrogs>
 <20251105141130.GB22325@lst.de>
 <20251105214407.GN196362@frogsfrogsfrogs>
 <9530fca4-418d-4415-b365-cad04a06449b@wdc.com>
 <20251106124900.GA6144@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106124900.GA6144@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Nov 06, 2025 at 01:49:00PM +0100, hch wrote:
> On Thu, Nov 06, 2025 at 09:50:10AM +0000, Johannes Thumshirn wrote:
> > On 11/5/25 10:44 PM, Darrick J. Wong wrote:
> > > Just out of curiosity -- is qemu itself mutating the buffers that it is
> > > passing down to the lower levels via dio?  Or is it a program in the
> > > guest that's mutating buffers that are submitted for dio, which then get
> > > zerocopied all the way down to the hypervisor?
> > 
> > If my memory serves me right it is the guest (or at least can be). I 
> > remember a bug report on btrfs where a Windows guest had messed up 
> > checksums because of modifying inflight I/O.
> 
> qemu passes I/O through, so yes it is guest controller.  Windows is most
> famous, but the Linux swap code can trigger it easily too.

Looks buffer overwrite is actually done by buggy software in guest side,
why is qemu's trouble? Or will qemu IO emulator write to the IO buffer
when guest IO is inflight?


Thanks,
Ming

