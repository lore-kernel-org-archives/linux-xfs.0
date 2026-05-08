Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3965337646C
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778228986; cv=none; b=I1qjKzwVDsMJONegH1kcdQjy5wJri7OIMLONTZEVQkNtJ8lYhcZITl3XyHcMCk3g3oO1fS8M2RGPDp/cJoiDgmlxqiKfcoN30ZpH0kn/eY1S/5WylpOwfEB8KoVTCykr73gDiR1x5WXKuoC3owksNymPVWNLYqp61Oq/3bs/eW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778228986; c=relaxed/simple;
	bh=ClwpIaAgXcZh1weG38DsTZJuhYX07nOsNLHS9BjrJ1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r07iQeIIJcMmTM6ZgJZEcHXpesfxBuJseQjCsi8JkwaO+PEZ8MBwfnI2TJP6b4jOtBlBWmj+OfbVdvspJMXL+KzKU4NKfVuvZ4uB+Tt2BEU927bvjfpBDidy1fvYBCqhP1CjdgQ348gOgA62QkGxbUZpXtzLp+STvQUCFHEGC4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cmBeoACw; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cmBeoACw"
Message-ID: <610346dc-ba8d-471f-be38-2429c5646416@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778228981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/5uKqIQmgeYtCIr5CurOMA0gGBXp2iccE7+P2DeZURU=;
	b=cmBeoACw3G9Y52niCGU1Xqm+KJRy5cCsjgSunztT+xTRCfKqDLRn9DUIIU9PBFnXHNZkle
	jLKU3LB6aRJPQHAwd3cH66Zi/rqVwqupT+VGWgCrworPSNJvYf95VD4CETkK4Bmdqs7JrZ
	jSjASOZnkTz3ymM7/Bj23uZ6DSmryHo=
Date: Fri, 8 May 2026 10:29:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
To: Christoph Hellwig <hch@lst.de>
Cc: Andres Freund <andres@anarazel.de>, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, Christian Brauner <brauner@kernel.org>,
 gost.dev@samsung.com, p.raghav@samsung.com
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
 <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
 <20260508081047.GA19748@lst.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260508081047.GA19748@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 5/8/26 10:10, Christoph Hellwig wrote:
> On Thu, May 07, 2026 at 10:34:43PM +0200, Pankaj Raghav (Samsung) wrote:
>> This fix seems to reduce the number flush calls and fix the regression.
>> @carlos and @hch let me know if this is the correct fix or I am just
>> suppressing the symptom and not fixing the root cause.
> 
> This looks good from a very quick look.  It'll need testing, a line
> length fix and preferably a comment as a reminder and should be good
> to go.
> 

What about this:

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..1b373fe1100d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2124,7 +2124,12 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
                            inode_iversion_need_inc(inode))
                                return -EAGAIN;
                } else {
-                       if (inode_maybe_inc_iversion(inode, !!dirty))
+                       /*
+                        * Don't force iversion increment for pure lazytime
+                        * updates (when dirty is set to I_DIRTY_TIME only).
+                        */
+                       if (inode_maybe_inc_iversion(inode,
+                                                    dirty != I_DIRTY_TIME))
                                dirty |= I_DIRTY_SYNC;
                }
        }

If you are tests are passing, then I can send a fix as a separate patch.

--
Pankaj


