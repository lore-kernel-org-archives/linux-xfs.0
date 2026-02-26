Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B161332620
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124166; cv=none; b=gUUji28JDvkeTFtMH8K8voQnnnfJTq4x+35hLpz1pI5vOHLeYc7Sk6zu9WiQQ+8Cf15/4lsF9udCb1/mvC1Xg9xs8x6+iou3cekEOteFJ9vfRvizO2MSdA0Pi0cJYJiF7mRv6TUy+ZlQ1HCaxnih2+tPbbVlaGdtQ2zmTiWrq4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124166; c=relaxed/simple;
	bh=6YalIR2DtD1+GY77RJ/bxVU4NwCwD9ItbbKj2+ekkJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u85Sgq2yHSOrDS24/NlJ2PEoVqc/NwBb/N/iL7fbrPe1FEvB63q58zHv+5qKJ+KuiMDDGjC2e1DLkKRFQ+Hwn8dEaMCze9XffZrTE++wYsry/eCguO7lVm970pHRut0BOryZR+p9n8GltxePCDdn3ktorf19Ti6kbVaAXtRVl9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AysYb/vZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AysYb/vZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772124164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x7rWcOD+pcORVfqwmn55zpuuLbu77Kq98FpVHYlx6fo=;
	b=AysYb/vZwIuTA2BcrjwdhumCoCwBICLotpLtXd0Tce9JzUEcaIDC4OLoGj0NVEgORRW+0Q
	MhxYdDO+jSLk81nhZbI7bK5qqPcuZkwGUnxHtVZ6bjENPi5XS8Berg7HDivsdzFhlG10FX
	+SsELT2xRsn1seGW9uPt/c/OW8lAH5U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-dxkN4faTNLCBlKJGeaHb4g-1; Thu,
 26 Feb 2026 11:42:39 -0500
X-MC-Unique: dxkN4faTNLCBlKJGeaHb4g-1
X-Mimecast-MFC-AGG-ID: dxkN4faTNLCBlKJGeaHb4g_1772124157
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30F831955F16;
	Thu, 26 Feb 2026 16:42:37 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.229])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 826C81800348;
	Thu, 26 Feb 2026 16:42:35 +0000 (UTC)
Date: Thu, 26 Feb 2026 11:42:26 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
	djwong@kernel.org, cem@kernel.org, hch@infradead.org,
	p.raghav@samsung.com
Subject: Re: [PATCH v10] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aaB38r55RPLj3ij-@bfoster>
References: <20260225083932.580849-2-lukas@herbolt.com>
 <wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Feb 26, 2026 at 02:44:05PM +0000, Pankaj Raghav (Samsung) wrote:
> On Wed, Feb 25, 2026 at 09:39:33AM +0100, Lukas Herbolt wrote:
> > Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> > the unmap write zeroes operation.
> > 
> Hi Lukas,
> 
> I independently started implmenting this feature as well. I ran a test case
> on your patches and it resulted in a warning in iomap_zero_range.
> iomap_zero_range has a check for folios outside eof, and it is being
> called as a part of setsize, i.e, before we change the size of the file.
> 
> I think we need to do a PREALLOC and then do a XFS_BMAPI_ZERO with
> XFS_BMAPI_CONVERT. Or I don't know if we should change the warning in
> iomap_zero_range.
> 

The reason the warning is there is because iomap_zero_range() uses
buffered writes but doesn't actually bump i_size for writes beyond eof.
Therefore if it ends up zeroing folios that start beyond eof, writeback
would potentially toss those folios if i_size wasn't updated somehow or
another by the time it occurs..

I'd guess there are two likely scenarios that lead to this warning, but
you'd have to confirm. One is that we're unnecessarily zeroing an
unwritten range for some reason. That would probably be harmless, but
unexpected. The other would be zeroing written blocks beyond eof, which
is risky and probably something we want to avoid, but also suspicious in
that I don't think we should ever have written extents beyond eof in XFS
(but rather either delalloc or written).

Brian

> Doing unwritten extents first and then converting them to written with
> zeroes is what ext4 does as well. Maybe it is better this way because we
> can quickly allocate the blocks and return while holding the aglocks and
> then do the actually write. I guess someone more experienced with XFS
> can comment on that.
> 
> I can send what I have and I will CC you in the series.
> 
> This is the warning I get when I test your patch:
> 
> WARNING:
> 
> [  112.551102] WARNING: fs/iomap/buffered-io.c:1525 at iomap_zero_range+0x42d/0x7b0, CPU#2: write_zeroes/411
> [  112.560073] RIP: 0010:iomap_zero_range+0x42d/0x7b0
> [  112.593471]  xfs_zero_range+0x86/0xd0 [xfs]
> <snip>
> [  112.594100]  xfs_setattr_size+0x5c2/0xd90 [xfs]
> <snip>
> [  112.598895]  xfs_falloc_setsize+0x158/0x200 [xfs]
> 
> 
> This is the test case:
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
> #include <errno.h>
> 
> #ifndef FALLOC_FL_ZERO_RANGE
> #define FALLOC_FL_ZERO_RANGE 0x10
> #endif
> 
> #ifndef FALLOC_FL_WRITE_ZEROES
> #define FALLOC_FL_WRITE_ZEROES 0x80
> #endif
> 
> #define TEST_SIZE (10 * 1024 * 1024)
> 
> void test_fallocate(const char *filename, int mode, const char *mode_name) {
>     int fd;
> 
>     printf("Testing %s on %s...\n", mode_name, filename);
> 
>     unlink(filename);
> 
>     fd = open(filename, O_RDWR | O_CREAT, 0666);
>     if (fd < 0) {
>         perror("open failed");
>         return;
>     }
> 
>     if (fallocate(fd, mode, 0, TEST_SIZE) == 0) {
>         printf(" -> fallocate(%s) succeeded!\n", mode_name);
>     } else {
>         printf(" -> fallocate(%s) failed: %s\n", mode_name, strerror(errno));
>     }
> 
>     close(fd);
> 
>     /* Dump extent info using xfs_io */
>     char cmd[256];
>     snprintf(cmd, sizeof(cmd), "xfs_io -c 'bmap -vp' %s", filename);
>     printf("=== Extents for %s ===\n", filename);
>     system(cmd);
>     printf("\n");
> }
> 
> int main() {
>     printf("Starting fallocate tests...\n");
>     printf("------------------------------------------------\n\n");
> 
>     test_fallocate("test_zero_range.bin", FALLOC_FL_ZERO_RANGE, "FALLOC_FL_ZERO_RANGE");
>     test_fallocate("test_write_zeroes.bin", FALLOC_FL_WRITE_ZEROES, "FALLOC_FL_WRITE_ZEROES");
> 
>     printf("Test complete.\n");
>     return 0;
> }
> 
> --
> Pankaj
> 

