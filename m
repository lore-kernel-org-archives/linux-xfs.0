Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD9179953
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724086288; cv=none; b=jsqVnluT+1HN62HBsWe9DKsRffqi/r8q4QOk9ey4elNwLBqdv7RXB6nwwJ6Dxb+noReTWcq0BIP0So+n3k0wdVkHJeNy+4WbZYEqPYjLaFgudN7cceck9XKbGqoJFKRTz5TKP72Jw4gq/zEC9StHZDIe/3V5rMPMiYwHn+Lnveo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724086288; c=relaxed/simple;
	bh=ogNa5gtDMg5QGxyuwqQRDNXrNTIdHkuIUDmVxfecU2U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=rJm0Gd+XMzyrUWJsbkUscJsq/RJnbMsTL3wYqD8dGlvW/1XU/DJJX4dPiFVdBI3iD8XzyPkgA7riXQT7q/hwmLPHcaSp75+OJ06qN5sKej2UtPXFU3eIVAehSQkYnsYMaHGhRFGmNqcN62kLyhoR8k9Kqv58HQJ19JyjthRYOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ez1rVZbQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ez1rVZbQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724086285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baSDQDw5G5UUnctFQXilEPZrnly/docCCU+r/lFMOuI=;
	b=ez1rVZbQyo0wM0TXG7q7NGpvki0CPvHPyjDkZi7s7R9eP9wbUoMdMCRzwMY9TmND8p//LR
	gjQiwTR1ovfRIwTUApTBnbCjCm6SPJzfH8kwEVEXhcu94EiozETYghhgRZBJ5mGlYEBtuB
	9w04wPfLHH7F9fxxCj0QZhgFc1at0jw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-rWSG64mtNlKc-GWHIcJm3Q-1; Mon,
 19 Aug 2024 12:51:17 -0400
X-MC-Unique: rWSG64mtNlKc-GWHIcJm3Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB3B21954B19;
	Mon, 19 Aug 2024 16:51:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E19E01955BF8;
	Mon, 19 Aug 2024 16:51:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2924797.1723836663@warthog.procyon.org.uk>
References: <2924797.1723836663@warthog.procyon.org.uk> <20240815090849.972355-1-kernel@pankajraghav.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: dhowells@redhat.com, brauner@kernel.org, akpm@linux-foundation.org,
    chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org,
    djwong@kernel.org, hare@suse.de, gost.dev@samsung.com,
    linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com,
    Zi Yan <ziy@nvidia.com>, yang@os.amperecomputing.com,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    willy@infradead.org, john.g.garry@oracle.com,
    cl@os.amperecomputing.com, p.raghav@samsung.com, mcgrof@kernel.org,
    ryan.roberts@arm.com
Subject: Re: [PATCH v12 00/10] enable bs > ps in XFS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3455346.1724086266.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Aug 2024 17:51:06 +0100
Message-ID: <3455347.1724086266@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Okay, I think there is a bug in your patches also.  If I do:

	xfs_io -t -f -c "pwrite -S 0x58 0 40" -c "fsync" \
		-c "truncate 4" -c "truncate 4096" \
		/xfstest.test/wubble; od /xfstest.test/wubble

I see:

  xfs_io-6059: netfs_truncate: ni=3D9e isz=3D1000 rsz=3D1000 zp=3D0 to=3D0
  xfs_io-6059: netfs_set_size: ni=3D9e resize-file isz=3D0 rsz=3D0 zp=3D0
  xfs_io-6059: netfs_write_iter: WRITE-ITER i=3D9e s=3D0 l=3D28 f=3D0
  xfs_io-6059: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 mod-n-=
clear d=3D5858585858585858
  xfs_io-6059: netfs_write: R=3D0000000c WRITEBACK c=3D00000002 i=3D9e by=3D=
0-ffffffffffffffff
  xfs_io-6059: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 store =
d=3D5858585858585858
  xfs_io-6059: netfs_sreq: R=3D0000000c[1] UPLD PREP  f=3D00 s=3D0 0/0 e=3D=
0
  xfs_io-6059: netfs_sreq: R=3D0000000c[1] UPLD SUBMT f=3D100 s=3D0 0/28 e=
=3D0
 kworker-5948: netfs_sreq: R=3D0000000c[1] UPLD TERM  f=3D100 s=3D0 28/28 =
e=3D0
 kworker-5948: netfs_rreq: R=3D0000000c WB COLLECT f=3D2120
 kworker-5948: netfs_sreq: R=3D0000000c[1] UPLD FREE  f=3D00 s=3D0 28/28 e=
=3D0
 kworker-5948: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 clear =
d=3D5858585858585858
 kworker-5948: netfs_rreq: R=3D0000000c WB WR-DONE f=3D2120
 kworker-5948: netfs_rreq: R=3D0000000c WB WAKE-IP f=3D2120
 kworker-5948: netfs_rreq: R=3D0000000c WB FREE    f=3D2100
  xfs_io-6059: netfs_truncate: ni=3D9e isz=3D28 rsz=3D28 zp=3D0 to=3D4
  xfs_io-6059: netfs_set_size: ni=3D9e resize-file isz=3D4 rsz=3D4 zp=3D0

But ->release_folio() should have been called here because netfs_inode_ini=
t()
would have called mapping_set_release_always() for ordinary afs files.

  xfs_io-6059: netfs_truncate: ni=3D9e isz=3D4 rsz=3D4 zp=3D0 to=3D1000
  xfs_io-6059: netfs_set_size: ni=3D9e resize-file isz=3D1000 rsz=3D1000 z=
p=3D0
      od-6060: netfs_read: R=3D0000000d READAHEAD c=3D00000002 ni=3D9e s=3D=
0 l=3D2000 sz=3D1000
      od-6060: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 read d=
=3D58585858
      od-6060: netfs_sreq: R=3D0000000d[1] ---- ADD   f=3D00 s=3D0 0/2000 =
e=3D0
      od-6060: netfs_sreq: R=3D0000000d[1] ZERO SUBMT f=3D00 s=3D0 0/2000 =
e=3D0
      od-6060: netfs_sreq: R=3D0000000d[1] ZERO CLEAR f=3D02 s=3D0 2000/20=
00 e=3D0
      od-6060: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 read-d=
one d=3D0
      od-6060: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 read-u=
nlock d=3D0
      od-6060: netfs_sreq: R=3D0000000d[1] ZERO TERM  f=3D02 s=3D0 2000/20=
00 e=3D0
      od-6060: netfs_sreq: R=3D0000000d[1] ZERO FREE  f=3D02 s=3D0 2000/20=
00 e=3D0
      od-6060: netfs_rreq: R=3D0000000d RA ASSESS  f=3D20
      od-6060: netfs_rreq: R=3D0000000d RA WAKE-IP f=3D20
      od-6060: netfs_rreq: R=3D0000000d RA DONE    f=3D00
      od-6060: netfs_folio: pfn=3D10d996 i=3D0009e ix=3D00000-00001 read-p=
ut d=3D0
 kworker-5948: netfs_rreq: R=3D0000000d RA FREE    f=3D00

David

