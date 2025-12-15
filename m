Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A41C2D879B
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765839440; cv=none; b=sQKYwaTM8NwSndl8jo9rCwK6VD7E4CnCmSDVW2Afa7l5Sg5GW9sNbS8DZ0ehMs8M/Vs+Wd0sSFhykd73uoS9vOd4Whk2RuL5eBBKA7pXI35LiJVxa9DKa+o40KkTbV/pWCx8nkd6NWBnwJcswEAq1w0JMa1fPpg/5Eh4soOg4Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765839440; c=relaxed/simple;
	bh=Mo8npNI1mnwaMl8eIRut9S+z4yOJNHDtaRBff0EnRQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z91O+1zQZ1lTYgWxsb3GY2NvrioKHBoSR81GUYh9vROO9GJSmy5KuNzGVxB6jstF1Qy2sbJBt2AWQm09vj6XveJrkcuFHD3XIhRZj2nUDMLuqDYfw0PFU0rzUq8+XcN1EvIQeKu8q3AMZMnmcaHUOyj8MwuiIgLRKXDpukbhu1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ffM6O6fP; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ffM6O6fP"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7f121c00dedso4873762b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 14:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765839438; x=1766444238; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mTpQguh3p4C+vnztQMYppt9Q4tUN6G+UcS/BdQBjJIo=;
        b=ffM6O6fPdsSDZf5rFkYwk7RF2yrBC+DhSQUCVRLz6zxrndtM3ve1B6cc9EmCvzUrF5
         4WPlF/UdfKqiuVWkP2//cPVTuAyYlTb0Q3I6SWH6K020hLzTiQiY4nxjSUqb6/m0vA2w
         NSxLfS+Iv5qiCHh4gv6rTFC/+pX3m5nL03vLi/b4Y2ywra7ItEcUkZI9qMpH9pUE8W5l
         TjB5mF+8thMWJRGn3mKiFOdwluQylKgR+CmLotYNU4nNd3cQoEKJf5iioZgVLJ7AnIS6
         DPfCJMAICmLYA+wfxLQwn6gQyJMSUqxbViwPe6SNfn3PA9lMN8eXjGY0FJjrWhrM6UXo
         PjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765839438; x=1766444238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTpQguh3p4C+vnztQMYppt9Q4tUN6G+UcS/BdQBjJIo=;
        b=oXGvVtclinNOsEOM5qBfhwozJZ0r09D+1uuVEXvNfjxJacTJh7LPUyLO4AskaSMH+R
         WmwoyEGBw1AlOfL+UkHW5gutzFWh3ClGo2CMXa9rnm2vm12Wj4oksFZvHOSlSRG/6fjV
         OqZlziedDZb8Ixx2QGJkRWDGj821fVZ51jZPbsp0/3c/k4QJIgHfb8WdCFnNfj9DYccO
         nHu0lwgtYNHv7y7QLuIZGiVkmdUAV0W4oy213wAsgiYkQLub0tI/ld4fTLEtMSJU+QHa
         G4Qpcsubs+UNMKtxisxP5DYcmJ5BkURPi3AoPqshwV2jG0B4HjoV+aGz777fSuVtQyl/
         mBRA==
X-Gm-Message-State: AOJu0YzNSZBCyA6IxCpkU56QHD7gtl0xBVn4dJVXCIBR/EoPhwGh7sX0
	q9Zs8Q54FNMVycTzj7hbGQJqo4NhdKiE2KuBVk6P4zoz0FOnN0NIvunCZ+yxIWU43mE=
X-Gm-Gg: AY/fxX5u22WEkQqYRgGGGy7hGfz0F4KEjh0WWZuYATvslUBN956FDx+v2QMyVfmhjOG
	av0UDCOUPB8kUlC3UjAzMrYvyT9til/T7SMPff95OlVB3HpVVJGawMXmjMv2dUJRChbpPToZS3T
	qjQ0RLJibQbhoK/w1xokNQynhkpU30i0C8ZlfYmjKuZa39sgHH8wlRhSY5XLBteClh7cbw736rM
	ItpanM90G4NafSWobvjPWMl7MADmadgrpuGmlyaZiPHQmONGvLPFdzHa878BWyaFE2nvEhcOC59
	wrupzh12p1u0ttSQKygVmHKaMQo5rwmRblud260Pi4b2p8UXAnBHnZf9ZsV/ZsTroMflrao9CYx
	J/kLpgR8tLjScchOOha1q6/vIsQj5CCpdFc45CJqYs2uenLLmK0Y/otcRtBZht7zEzRgjGLKNXx
	HiYbb+lI93B1kJbbSGiREeOzYNv//DRsZiL94lgJheJIx1DcVySS82Kt/4qbQ=
X-Google-Smtp-Source: AGHT+IGh+PZ64ZKbzmLn0P0SPPptzy1gIdA5DvdkzL67oRitFDfbQFVVpH7nAy5FKx4qv6LMo9wA4g==
X-Received: by 2002:a05:6a20:918c:b0:366:14b0:1a32 with SMTP id adf61e73a8af0-369afef5bb6mr12760479637.64.1765839438133;
        Mon, 15 Dec 2025 14:57:18 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d9d6bsm13394493a12.24.2025.12.15.14.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 14:57:17 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vVHVC-00000003KkS-2MjH;
	Tue, 16 Dec 2025 09:57:14 +1100
Date: Tue, 16 Dec 2025 09:57:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4] xfs: test reproducible builds
Message-ID: <aUCSSuowzrs480pw@dread.disaster.area>
References: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215193313.2098088-1-luca.dimaio1@gmail.com>

On Mon, Dec 15, 2025 at 08:33:13PM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.
> 
> v1 -> v2:
> - Changed test group from parent to mkfs
> - Fixed PROTO_DIR to point to a new dir
> - Populate PROTO_DIR with relevant file types
> - Move from md5sum to sha256sum
> v2 -> v3
> - Properly check if mkfs.xfs supports SOURCE_DATE_EPOCH and
>   DETERMINISTIC_SEED
> - use fsstress program to generate the PROTO_DIR content
> - simplify test output
> v3 -> v4
> - Add _cleanup function
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  tests/xfs/841     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/841.out |   3 +
>  2 files changed, 174 insertions(+)
>  create mode 100755 tests/xfs/841
>  create mode 100644 tests/xfs/841.out
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> new file mode 100755
> index 00000000..a75f5879
> --- /dev/null
> +++ b/tests/xfs/841
> @@ -0,0 +1,171 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 841
> +#
> +# Test that XFS filesystems created with reproducibility options produce
> +# identical images across multiple runs. This verifies that the combination
> +# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid= options result in
> +# bit-for-bit reproducible filesystem images.
> +
> +. ./common/preamble
> +_begin_fstest auto quick mkfs
> +
> +# Image file settings
> +IMG_SIZE="512M"
> +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> +PROTO_DIR="$TEST_DIR/proto"
> +
> +# Fixed values for reproducibility
> +FIXED_UUID="12345678-1234-1234-1234-123456789abc"
> +FIXED_EPOCH="1234567890"
> +
> +_cleanup() {
> +	rm -r -f "$PROTO_DIR" "$IMG_FILE"
> +}

After test specific cleanup, this needs to call _generic_cleanup()
to handle all the internal test state cleanup requirements.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
