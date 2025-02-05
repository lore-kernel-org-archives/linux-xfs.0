Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46762BE5E
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714626; cv=none; b=WJw28eMdnhmrjKRj3iHALi5o1aCQH3Bj/CFmv4nPE7Pv1zEB/lmlwU5MWj85Mcd7clook/yAZNnYGrWeS8//m42qIjyhQ0Q9TV9A0l0y3kR/fLGCgCslMkD8axc5g7vXNnMN4C2JxxLphe0hB0dZI5jZ1axOm6NISpxzmL8152U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714626; c=relaxed/simple;
	bh=eVAJEdLuQUb2bLju92QgOKoEHpfCuSg9j/OmZ5BjfDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iySpLV3+KXQjGygvj4a2u6RIEm3TexN2wWIMyC+FkMrioA0dQFhwJYdsuHRzLsLnhYPJDH6h9P2fHwkCtC3u8pZJCKIcSuk+Ll8hf88uJg+uD1o1tofjQCIXD9+qMPrrIh7gJiCYtNfQWOb9fJcpUHFpN8IxWs7z5kyvLrZflTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Qo5jp5u4; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Qo5jp5u4"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21661be2c2dso105781355ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738714624; x=1739319424; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EX4MUvPk7++0CldMOisGfO61xmQCFSwC1NdOvlvdD4Q=;
        b=Qo5jp5u44PyRRPTsDnEXyAHq8SIY7N9gb0WTtGZrIkJSoq2XJhiU9cimGgbcQUXvzB
         rniv4K87J67/r0UbdaO2QmL9U6O6reXYSPngIRYBNYDEFpzoPWjQcglQ9LP6Pig69PC9
         8Ts32xlNTbba/XRfghJXKoPOv6NwV2+jVCX6pksG+oaghvygvh4kIv2Wb5IojU4MPLrE
         /aEYfDJp7h/QkuUdqRoh30Em5IO5TcZfspkc2jkPLrRYfC0/UGib45squx0osbJDufnQ
         22Zqi9gT2jwVipvntN4tJQ6Sm1sM39ozkT+cGVxuo7I35YZ005/BKRvbIHXA/COK54hU
         hqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714624; x=1739319424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EX4MUvPk7++0CldMOisGfO61xmQCFSwC1NdOvlvdD4Q=;
        b=L0HjksmLUxs7h9nGUHjfGDCJJpabBzc2JREQG1Ke2+mCTC/FqVVYtYfLadX/xF6X3+
         FjFMEJ80xvFAf9nr1+U7xA+btWwIaldbgv1FvSimi8gpuFcFc5dMH1D1CE2U061+ctec
         zILJzoXbTkyN1Ak/LUEHaiTyyLYb4Awldz0Q3layTg1/KL5NNLVErZkod9KR75XzB0ke
         BmmiPo4ZtlvrMM/vXLEN1oWbEBvYXsHKGibKoXceYCpizGgoxChPF8ZH2Sd1msUB6ASd
         n0CI7bmmL8dGjKGRufaTqytXsVGs04UMBaouPQS2CxVhQ1LFE7i5hJUzqomuqqfdDGXI
         5xcA==
X-Forwarded-Encrypted: i=1; AJvYcCX2nJAbaYZswGsmXcddlA5lfPKeezGV48CEbrl12rmT9zkRgVpjCFUq/wNtlosGZWP1xySkkdCk9+I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Co4fw2BS08obNZMkqCWXE6OlH/+uxsodFvfxQIjWSkW2TPdd
	yKf7jhH+DApycFDbN2NQdQiY7CvIltZKnjhs/USzCv8Nwes1oq88/xWr0o3rOxA=
X-Gm-Gg: ASbGncvTtsBV0M87kjhBz/szw5CZCA5RdgsTSx+Q/vUWT2D+eci1u35DUn9IByOyGUz
	IzIih3W0zLX6Kbc70jqv5dscZkWMDwfLDUIoiNMsio+S9xdjbvxgA1bc5737ml398ZNv9F2pe9O
	8oXw7QzKqHvOEwEBKWN09EPv3PH8csVrPX5Xx46L6+ZK7QbHQJiWUpxPSQaDM9TmjDR/hK6Kbxn
	JdTv2rN6B1aCOnX+DeqU8aoiij1DqmDfBG7daXHGtSHHNbrWlOXN7ggauarqwCgWXiiCNZ7P/va
	jXhIYkAbJC5kGVuTcok24AzeEvzitNcp4NIOzYPbBEkoeq5Ez+pWyPYP
X-Google-Smtp-Source: AGHT+IF0fGPoZ0o6c3/KifK+4vDFyDlaoMwLReG+Nq+K4DdtJ4zbe4B3HobDOfBADRTDpH6K5vAagw==
X-Received: by 2002:a05:6a00:a82:b0:72f:f764:6269 with SMTP id d2e1a72fcca58-73035125686mr1367074b3a.12.1738714624286;
        Tue, 04 Feb 2025 16:17:04 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe69cea77sm11138362b3a.150.2025.02.04.16.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:17:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfT6D-0000000Eiql-3Ap8;
	Wed, 05 Feb 2025 11:17:01 +1100
Date: Wed, 5 Feb 2025 11:17:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/34] common/rc: hoist pkill to a helper function
Message-ID: <Z6Kt_X1AliA1_2e6@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406306.546134.16510101936129304399.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406306.546134.16510101936129304399.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:25:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to wrap pkill in preparation for the next
> patch.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks fine, apart from the ordering issue with the previous patch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
