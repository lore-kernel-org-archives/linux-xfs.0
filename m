Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A114232452
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736900939; cv=none; b=oI5f5rwf+VGZ+TvfaglpJvsA3xd7+DlfgO6H1y1rIv4ZvkxORNJs95SIJq3FrG5o0loJ7nU0mL/tGXz2d5zxtOQQxk5RDJL6pAVYzDv/dYcNqsSHF9oes7qMWcOEE9/DTGQSxUsnTqJsbFV8U+4h/pnTZgk4P+VpfMicbhqAuFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736900939; c=relaxed/simple;
	bh=4wL9BblJwVc29y5rrqfOUTAGMw5lMx+hGvhBssriTnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLhfn/bYJs6Eowc4inot4MbFolQaUT1Fb8f1ogkLMqKw4MzL4jB5Y2c9addVW2a/manZWLc01LM/PyeYjPO4lLfPT34iYkEB1U4VVqi3TgoVcLLdk7+gM0WMY+p2fo+YauNJ9ADjzrjP12rH8mt5XGjXLlLD9a4qqwBABHhuXAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cXbRy9Uk; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cXbRy9Uk"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef760a1001so10158592a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 16:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736900937; x=1737505737; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lYtpoL9EibYd/5yE+lBzA+DrtKubT0uHHdBjBr+3TSU=;
        b=cXbRy9Ukpn0QWh0hzH9E1YCjGPHSJg8i0yENlE8ZjDAxd/DY80BHeXVzdudmjxu2h/
         +E8yXKaBw52ScRpQe6O37ipUVlv2bosn63KpBaC3RElZwqfZThi9Fa1YdAU1VvY+ZaGV
         0nXblhcGk2uxduIPfZ51sbWNTAnYCYnCGcROIE3a9PEnb0H7C9XEIboS+au66kZmEp11
         4TUuTnqfrTZedG7Ge0d6KDyCGsw0eMHEaRgvGVDu6hBYnSECOo6iyicq+2bkXd+M4J/l
         L4pVL7sKnoVCGYTN3963f1E7CnDevX9ngSGKjEGy1OEnZ8zUBav4BDvcTDqWNPXEA7zx
         d5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736900937; x=1737505737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYtpoL9EibYd/5yE+lBzA+DrtKubT0uHHdBjBr+3TSU=;
        b=da4PcQ8d8szALMT+jdzjOrVp6arjU4LU/msoEERUfGIfAaPAdFKKHEmMybNiKTwZJK
         ZikBG/OhKigMZjZx6dvj38jrrHDYN8AHbOFEPqnHv6rrT1z3lXfJ9Y48H6x9M9TROwVz
         kDv4L0tJ1xIn2+sul11uNTB2UfEkWN7bZk151XIEFr/DagpduQD290uJ63deUaDpsYL0
         5W8ixrphlEGwiMpqt+OWspnGLx1UgRhDs5QbI+2C6sFz1/nQ0cXWi22Aa1hDKuvAKo3r
         lkOFP6DEOhJq52uKUrSfKE3ZsmrYY8uXwzNKO1lLjPRK0jvdNe2DnSUePUcnAjAOArC8
         BkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmA/tfduSOwqy59e1863dXtY922Aa8NVYmCXcYqm+cjzuZr8ftqyGtclUHpFtNeP8Xa+jngSNOVuo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzihqff3zshMIWNUTPl0FFI1LvpheHepKySpUSu9gom2kjtp+z6
	nxza2HJDibTQKMvVBxLbRTtkGdsLw4d+39+TQfyzvfrY8JCL4xFN9piNFNxJBLA=
X-Gm-Gg: ASbGncuavlL7mH9kYimg9GlZaVL2Dk8zlKrKlpFouQh+xA6Z59nM0C2jEMq/QSqmeXx
	ZAfVRs1go8Tc3fr5BVcDOn70xbiE7V69GncAZv9EQohAXcJKgPD1jrd3vyhCg4NSD/h7EiGwdqF
	zVl+0VB+WbTHrhKBVAblbvEb9xXBSQ64Syusql7pzB5B5OmQvzNpZPAVLfWO+mNU1gztY37UJz+
	ZLdUQ1f+QAK+Ds5YQKGEUYAVSbM2PxBT1MH0rCAqNNhmsSCYc56QdN7XsM0P5fsNXdPO5ylIRh3
	e/BUDtfNo+O/EMxw3Wcxgw==
X-Google-Smtp-Source: AGHT+IGb+3R4BSWThIWHu00rojTXaCH8qdvGC7yoxLKQgMAcSJfD0FT+zDIh358sie79C0Ktcsfn8w==
X-Received: by 2002:a17:90b:2e86:b0:2ee:b26c:10a0 with SMTP id 98e67ed59e1d1-2f5490abf24mr42449277a91.24.1736900937466;
        Tue, 14 Jan 2025 16:28:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c2bb2cdsm136495a91.34.2025.01.14.16.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 16:28:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXrHC-00000005y5b-21sD;
	Wed, 15 Jan 2025 11:28:54 +1100
Date: Wed, 15 Jan 2025 11:28:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, flyingpeng@tencent.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Message-ID: <Z4cBRufxcp5izFWC@dread.disaster.area>
References: <20241219171629.73327-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219171629.73327-1-alexjlzheng@tencent.com>

On Fri, Dec 20, 2024 at 01:16:29AM +0800, Jinliang Zheng wrote:
> xfs_buf uses a semaphore for mutual exclusion, and its count value
> is initialized to 1, which is equivalent to a mutex.
> 
> However, mutex->owner can provide more information when analyzing
> vmcore, making it easier for us to identify which task currently
> holds the lock.

However, the buffer lock also protects the buffer state and contents
whilst IO id being performed and it *is not owned by any task*.

A single lock cycle for a buffer can pass through multiple tasks
before being unlocked in a different task to that which locked it:

p0			<intr>			<kworker>
xfs_buf_lock()
...
<submitted for async io>
<wait for IO completion>
		.....
			<io completion>
			queued to workqueue
		.....
						perform IO completion
						xfs_buf_unlock()


IOWs, the buffer lock here prevents any other task from accessing
and modifying the contents/state of the buffer until the IO in
flight is completed. i.e. the buffer contents are guaranteed to be
stable during write IO, and unreadable when uninitialised during
read IO....

i.e. the locking model used by xfs_buf objects is incompatible with
the single-owner-task critical section model implemented by
mutexes...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
