Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792604671;
	b=IPmEZdBZsbGaTN6vC6ZPfksxipKCyQfj047iojn1g0QuJVE1g9iVONgsPfj8q0ukEB0+
	 2/JiD6rh8+IO99ZZ9tVLEyPum1fig9IUfLBkk8M6g56FcNxn2Z4FkxO6NJahO5yiriehD
	 rVmIGlB5AqeymWfZaarWD7r3BJi4eaOA7LBvkKk+IWTWKdBmOZIZ42LygIuulQPtXtdhS
	 cgRUGdQdgYYBdYUBELUsiu6zoLHmZtJtNGlHAMBThxDzTzgdL0crh2mBCz9UEwBA6gqzI
	 sog9QTbTJ2Zbmi1Fu4tVKmII0O0aEHb+b4fccWSXyUn4OiN5n3uQj/9GMJFJSSPlxWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604671;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=7CaZ9JS2jRrzvTua4Ov4Nn+8wNqPkglApCwvgGA21AI=;
	b=a793Ffk0b9LN2pm4vLUOP0isG/XwwwbQfgU+kOE3RYyANeWxH5FvnaQROw5w7sioFlkI
	 CY737MZCRyYZWnK2BhNWm+Skz9+ena7a/Ri97J5+CVWLGKd+mVXBkcTbKgbs/aa69ANhz
	 rpLegVrUHzZgPukTA+aQ8RLFHlwqCDfNSu1EEdwo0Nv76914BeSSSNRCC5LQTxxyTlanN
	 cAvx5p1YwQYKtvdevwI6V0tI+zO+tlHdGfBZfGwOZGyF1ISGeFga4Y0CV2+DsVIRMvy/8
	 OXPXS4a9EmXaV/5L7gSTOb4Wk2l5O7pvuPP1CqvohTuxy2mtzRF4tk69ybzwP9/O5Gw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=elrepo.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D203D606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 17:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D203D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=elrepo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c34bff61551so122044466b.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 10:44:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792604668; cv=none;
        d=google.com; s=arc-20260327;
        b=YOonxeHOSXkwK44iFoSlvgJQXZ6KK5nHelG/sI5c5xvS6vEqxIOQ0/2AU8bQ0yz2hW
         xt8rYU77tatbKNKlb9srqT2ni77v19K7vzKYHaCcCqRTt4ln3OZ0fyVZaxL2THwTmFxR
         5VWvAPr8V+XgRq+Ow7TCunv5mvzaovUCLdEf/jj88gWYkWykNAYquIfUy2jyPf7l/mV6
         K5zkZcxxjRoA0D6+cB4/TeV16S0ZtYaa7pKZG7D8cmEwIew27kfbCbLZ3QbIfPRkmksW
         MmlAlEd1d2hJHE3W0v7nsvyLcHJYbrhVVb/KySgN7n6AcQ3DPmf7LAWgBT+ksrqhgutl
         jGsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version;
        bh=7CaZ9JS2jRrzvTua4Ov4Nn+8wNqPkglApCwvgGA21AI=;
        fh=+d03Zk7/hQ/hR3e1fIH9V+/bVQy14me8BM3SMeqezVw=;
        b=My2txNvf3RwAyS1f836jDwdofm+8OnHM0sekHPS548I6cLqHT4jiiiTMVpkR2ykoaU
         e2LUs/t3xfGbXYEDZkQe47R0lNUjHwqQebBMy7bdGQWq/xgF5a4jPOzwbFZnvEGQF8Wc
         NBjvvfHzU/5mSDuoOERYX4xQaLc5kodMjNy2KcwwlBwB8DNuNRRNW3kb2fttN7w6rrD0
         Q368TS7/TS2Cz6zMLl7ppweV+Jj1bQDryrMPAwEw/DY8tb9yv5HDs0LrB/qOK5mwqPgR
         H4jPyK/tWtDk3ixsVieYU9gTGj8SQa1pST9QOabdJgntt5KyJ98y+6X1CI1HR4wBBUAs
         ajvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604668; x=1793209468;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7CaZ9JS2jRrzvTua4Ov4Nn+8wNqPkglApCwvgGA21AI=;
        b=cph2Ovj9N/pq/R54id/Eg43AfOvifhiJ1NtPYm5XbnNDSysQUCT1KT5JBvJ4yukeLO
         ReN5A0Cfj12s1rBVMZL9r5MecpAY7OmEQGgkDL9KhhtBD8TKDPW6mta8RqHopQMMRXRs
         5dnFY5NHu83fKWmZ0aS5tnaVE+56WwWTMsR8b3FFo6yKdOWqRpmyXpnoEuSNvqsopAxt
         mycnU/fKdYlSahWR+mEj2JVlcF7Sns15Sgb+jeKR+VH5ug3jz2n8u1t3wAMMu0N9P3Hg
         R4MRy3cufxajGCMNb1umLCT/MirGVmtbl82QcItdSCdneKENBFGzqf9/lPmUNlTnW57R
         SEgw==
X-Gm-Message-State: AFq9FYKVAw1vcN25mR2zebzQoFXAvBu0WqM9+E5Qdf/ThLIDjAPUO29W
	5FYBFXFMA9JfEFiOd2ZrimYox5ivAYAmlOg5nyLWEJwdB5YcbL6dKDOJSgy2pjvZYrGopyf/dnN
	8Istm3Fb2W9uUDIAcw8T7EikdavPqJSX6oQ==
X-Gm-Gg: AYBFou1SebcgNZ0joaIn9CNQE4GNpHXEDcdPc4xsgnzSBAGniwYG3z+dI5h8oy4CNIB
	A3PJPvtTZGyDRNffxLLBZNWXkZ0iUCIyN7MvXtp+LdXLdMrI7SFTe1t7hKRh2kp7fR6GPlg2lJR
	W9/uLQ/Q9ynyxFXR7MEmilpUCl82THrh1nklDtVNDqBPDepBrgUS2yS13rK9H8tshR3wsoYqrvX
	x2bAzkyHF7w7ydycRq3DONhZVFqUhz8tZ9q4rMKf62DvZf2fgMzRz3OMDWfTPN9wWF5rVBSaT5v
	fREpqQq66osv7tIDvR9a8QzMRq2TfWwUaAY25oxuCSrAl20CwhNkZG+ZgJfbZqaKQAq5ErmDwJ+
	gyM6AYlhl/XQ6xjbNhN2sHSfOI0z6iw6U8RN7LPOm8AZjPiy2mWz1
X-Received: by 2002:a17:907:6d12:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c4679611ee4mr253058066b.15.1792604667944; Wed, 21 Oct 2026
 10:44:27 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Akemi Yagi <toracat@elrepo.org>
Date: Wed, 21 Oct 2026 10:44:16 -0700
X-Gm-Features: AclHuK8AWXDtrArvrMwlSBZkm2-Wg8hsG2N0kAq3IZPen8HGiocOc9Qu3GXpAYs
Message-ID: <CABA31Dp=R3nnFpRGLhw0T80derEGq4eQbHE9FccOUPnLK9qerQ@mail.gmail.com>
Subject: [BUG] XFS Assertion failed: lock_flags != 0 in xfs_file_dio_write_aligned
 (kernel 7.2.6+)
To: linux-xfs@vger.kernel.org
Cc: Akemi Yagi <toracat@elrepo.org>, david@fromorbit.com, chandan.babu@oracle.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This bug happens on the vanilla, unmodified upstream kernel. It was
reported to kernel.org Bugzilla (#222082) but mistakenly closed as a
distro bug due to an ELRepo build tag.

The details reported by the original submitter can be found in the
link to the ELRepo bug tracker.

Thank you in advance for your help,

Akemi
