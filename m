Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB961A262D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136380; cv=none; b=ZVIi5Oh33YhOvWEjj7KF3zLBG3KJU8AyUMX27w0xdN4s5kk3QB5Fd5cNwEINN7akDiTFLmOZon7IfkvVqZdRnxgaI6En9DhTmGpGS7yA22Vpzd/oWd4OuHMNLkZo7Nvj7vhTSReI7NKcTj/1mBqF2gJxdqR5jBU8/H+U/VUytqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136380; c=relaxed/simple;
	bh=DxpIRk0ZHqpQTmAyWlUIqkE7PKFIpvRpFA5kFTCwPE4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=p1hUZVirBakh39Ijts7gM83YdrL3+yOzZMHUKnvgrVm+vHUJHKRd12dszpGALPA3m6ytP86XyjvKZn8ydeEGDcH+cROVBT0ZIrYWpmFmYE+a7lUCzn55LHKf14+d3zgWRrxopFGTTHLMj16C7+25yqfOdQqe5dx+Wz+8GkGTsuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 8A74C180FCC3;
	Mon, 29 Sep 2025 10:59:24 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id VdszGGxK2mjB0wEAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 29 Sep 2025 10:59:24 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 29 Sep 2025 10:59:24 +0200
From: lukas@herbolt.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs fix sunit size on 512e and 4kN disks.
In-Reply-To: <aNotI3z54Om5MmE1@infradead.org>
References: <20250926123829.2101207-2-lukas@herbolt.com>
 <aNotI3z54Om5MmE1@infradead.org>
Message-ID: <80069d04a7bcbbfbb8daad7191c83fb2@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-09-29 08:54, Christoph Hellwig wrote:
> On Fri, Sep 26, 2025 at 02:38:30PM +0200, Lukas Herbolt wrote:
>> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
>> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
>> and so we set lsu to blocksize. But we do not check the the size if
>> lsunit can be bigger to fit the disk geometry.
> 
> As I had to walk the code to understand (again for the nth time :))
> what the lsunit actually does:  it pads every log write up to that
> size.  I.e. if you set a log stripe unit, that effectively becomes the
> minimum I/O size for the log.  So yes, setting it to the minimum I/O
> size of the device makes sense.  But maybe the commit log should be
> a bit more clear about that?  (and of course our terminology should
> be as well, ast least outside the user interface that we can't touch).
> 
>> Before:
> 
> You Before/after also contain changes for metadir/zoned, looks like you
> upgraded to a new xfsprogs for your patch, but not the baseline.
> 
Yeah it was fedora rawhide, 6.12, did not notice the metadir/zoned.

>> index 8cd4ccd7..05268cd9 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3643,6 +3643,10 @@ check_lsunit:
>>  		lsu = getnum(cli->lsu, &lopts, L_SU);
>>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>> +		if (cfg->dsunit){
>> +			cfg->lsunit = cfg->dsunit;
>> +			lsu = 0;
>> +		}
> 
> I don't think just picking the data stripe unit is correct here, given
> that the log can also be external and on a separate device.  Instead
> we'll need to duplicate the calculation based on ft.log, preferably by
> factoring it into a helper.
Hmmm, aren't all the <data|rt|log>.sunit" set by blkid_get_topology()?
So as log is internal lsunit should be equal to dsunit and it can only
differ if the log is external?

Based on comment:

     /*
      * check that log sunit is modulo fsblksize; default it to dsunit 
for
      * an internal log; or the log device stripe unit if it's external.
      */

> The lsu = 0 also drop the multiple of block size check.  If that is not
> a hard requirement (and I'd have to do some research where it is coming
> from) we should relax the check instead of silently disabling it like
> this.

My understanding was the LSU check is there mostly if cli->lsu is set.
Actually if that's assumption is correct it can be done just like this.

---
  mkfs/xfs_mkfs.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8cd4ccd7..3aecacd3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3644,7 +3644,7 @@ check_lsunit:
  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */

-	if (lsu) {
+	if (cli->lsu) {
  		/* verify if lsu is a multiple block size */
  		if (lsu % cfg->blocksize != 0) {
  			fprintf(stderr,
-- 
2.51.0

