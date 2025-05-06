Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491ED1DED60
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746560163; cv=none; b=ALHrJ9ELJd7TyEoKjCLzInZvkjZ/PFx23wyqll5UMQl2CNaQROF5UoJQnCEOUi8YHxthJS61ashvtvanllogcVR+Djrc/VRmVHTgvH7oWOT9WfyH7sY1YCLO01pleW20fkZ8TY8QXSSlUWdEBMbS+D2WKlpDE8QapkYtuiy2xnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746560163; c=relaxed/simple;
	bh=0eIysUF5njc4VkshtwO4iAeDnr7fqlNJmozempjgDg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KX+7GAze1ZCW3qKdLjxnxaICvH1zg4zL9ccMwAMtI4Ov2vc2aNJrkiOa7Dwik4pYaFo/hukdvB23KSxJGg7fhnLQ+Pp3BjKi6wZoQ8ONImyIzJj77nTja/lvHkcSv1pGdqv4ggQIaJKCzB3a61OCMtVRN6MZB57Ec+uh/eRprOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkmS3+H0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkmS3+H0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746560161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlccjetcOiFoNBMq1PHkU/DMSj79dwUFrKyd+ujZry8=;
	b=gkmS3+H0TqKEaQsA32iwOiuJVAe5PXipmRhSPvfQ9bgxs0s2o3mtqOXN6Eo5OquXvvBR4t
	I/czFKMvyD/d0EL0k+gxNNp8JH3I/yXmo9A4WA0tY8DWkpzOCjx+8PBVAJszc983RmXVqP
	FU1U+QOuxoj55XjH1TTwqDGa8gDlnQg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-DCmOfjKjNpGCTssgZULXpQ-1; Tue, 06 May 2025 15:36:00 -0400
X-MC-Unique: DCmOfjKjNpGCTssgZULXpQ-1
X-Mimecast-MFC-AGG-ID: DCmOfjKjNpGCTssgZULXpQ_1746560159
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22e40e747a3so8365955ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746560158; x=1747164958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlccjetcOiFoNBMq1PHkU/DMSj79dwUFrKyd+ujZry8=;
        b=cesUOGMBqMMEqZgf9oXSM8TzaY3+9nRgxNCH1eKomnBcGkwULlVdkvLEVObOvKWWh0
         2DEhzkd3hYMBNN6gMmQnTqUwd2YGS/zEEGpiAHe8cVzfN8eA1OhcN0mL/i/7gTCzxQMw
         LvvTZ5qT2Jk/AE9H/6B7L/wdY/jd8pQCLSlVNAMKKxTjSajrMgZ7ViN4WQrK2131JT8D
         l7nGd9MnO8vGsgzhW0rcrDjfmErgLteZAdqD7GALnPlwaqOZysaLJ7F3KcFXaCEeKGmX
         E37arUr7I0iUNMExJ+bkvB51F/iS5Xe0hxd7Zi95TZff8G3ICh3irlHWLOnhfXghquaH
         +bSw==
X-Forwarded-Encrypted: i=1; AJvYcCWyhl1Zu291xt5r0SEMXG+PJxn8BTLsCQ/L2mNku3dB0nSs1oruLrrz6t/OQ+3dAXc5WYUMeeH3qeY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTRL4bLk9X8ag86Yt/ZI4HGBG5ejAa7ZvMRWYIO3szOudqjLt5
	LfTU4S3UtJzrcfFr1xOoF7Kz8NXOUmyMCIfWOwQG5f0WLYy4uP700+W7yCeMOAqEJB+TfzmhT3L
	GFselQAvmLsVFCy7M6ciInwIRtJu4QdLJ+LW1TrNSDMKMQYjTeCQCT4i2IOX9FxQW8g==
X-Gm-Gg: ASbGncs8bNxF/9kTkUGHXF5Wr2gtQKcQP2pwbH/0B38AM6MIw/vaP+dZfszBQNRs2P4
	GBj5Map4UQacpwHTZQZpTLn0cE+IQjZGWD7po6CAzXH2FQY0ma1m75DCwF8Q2CfHj9O+UuKgCzo
	rpdKzARtpOr5507NVccmbPJ8XmVgxM4k6wm4j2IHfIYbEcYtTqNXfRpwIwK59rqFK+JWZi0BWad
	m8kETbeN5iLCVaUZbJ8C8p/rxln9JbIHdMGOV7UOcuw5iFqBUtI5I7aJnNd8FvdPf6opHdIJ6cV
	SjJ/VxupCvlNH68N7qK68/ioO88fBfmfgwI+8om8CMR7/xNKDe6m
X-Received: by 2002:a17:903:22cd:b0:224:26fd:82e5 with SMTP id d9443c01a7336-22e5ee1d5a3mr6442955ad.48.1746560158215;
        Tue, 06 May 2025 12:35:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXaUkmzIX6ISVVuvM3v2socpRCWj+mgNkNuzGiAMiabk68CslL2FyQ383GcQbS1Rc8G8xVKQ==
X-Received: by 2002:a17:903:22cd:b0:224:26fd:82e5 with SMTP id d9443c01a7336-22e5ee1d5a3mr6442695ad.48.1746560157815;
        Tue, 06 May 2025 12:35:57 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e9dc9sm78239945ad.87.2025.05.06.12.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:35:57 -0700 (PDT)
Date: Wed, 7 May 2025 03:35:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: add a test to check that data growfs fails
 with internal rt device
Message-ID: <20250506193553.fxwtsheijvvwdh5f@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-5-hch@lst.de>

On Thu, May 01, 2025 at 08:42:41AM -0500, Christoph Hellwig wrote:
> The internal RT device directly follows the data device on the same
> block device.  This implies the data device can't be grown, and growfs
> should handle this gracefully.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4204     | 33 +++++++++++++++++++++++++++++++++
>  tests/xfs/4204.out |  3 +++
>  2 files changed, 36 insertions(+)
>  create mode 100755 tests/xfs/4204
>  create mode 100644 tests/xfs/4204.out
> 
> diff --git a/tests/xfs/4204 b/tests/xfs/4204
> new file mode 100755
> index 000000000000..0b73cee23ba5
> --- /dev/null
> +++ b/tests/xfs/4204
> @@ -0,0 +1,33 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4204
> +#
> +# Check that trying to grow a data device followed by the internal RT device
> +# fails gracefully with EINVAL.
> +#
> +. ./common/preamble
> +_begin_fstest quick auto growfs ioctl zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount

Won't $SCRATCH_DEV be unmounted after each test case done. Is there any reason
we must do this in a specific _cleanup?

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_scratch
> +_require_zoned_device $SCRATCH_DEV
> +
> +echo "Creating file system"
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Trying to grow file system (should fail)"
> +$XFS_GROWFS_PROG -d $SCRATCH_MNT >>$seqres.full 2>&1
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4204.out b/tests/xfs/4204.out
> new file mode 100644
> index 000000000000..b3593cf60d16
> --- /dev/null
> +++ b/tests/xfs/4204.out
> @@ -0,0 +1,3 @@
> +QA output created by 4204
> +Creating file system
> +Trying to grow file system (should fail)
> -- 
> 2.47.2
> 

