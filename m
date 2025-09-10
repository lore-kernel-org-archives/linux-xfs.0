Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A12BE7B1
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497275; cv=none; b=jhh5GLnMFuKBq9lb0jpRchT0xejMjMbFpngd8n9KocjplrWy6w8QrycCB1h2h8A0zA9vtydEfiOGUMnkT4W7Q1Tmj0hUxHdjawHOF/R5gYIZKbpQ9V7wuDWRev9KxdUte2/b5Eb5p3foCsvCyeWlVKEvKc5Qss+BVMxFgnEQkdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497275; c=relaxed/simple;
	bh=Tf41vV8zRfirwyuU1nQNa2lBQWfzvhkFCVJXIeakHKQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eVRKw/NrGF7w+4G+X3xH3L84nmB2DLuFG+sVUFeT2SnZSdR9aC0WaipZihMpHQWAtiFGimYoIHBQcFN26YzqjhBhCtdVdaLhMekxshvXaBOhdWc7IyWn769pmyUNNH1GGZHKCRYd55v3gb554kzYVzL9zZ7VLuA1HZnECFl4jgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrRz2rY+; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrRz2rY+"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b047f28a83dso1129860166b.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757497272; x=1758102072; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OA6/wMtVwYnCpFqHgoNVrw9oTr+hymfr3c9vK9x9Db0=;
        b=QrRz2rY+CmXkSPMFPFlekU2xllgR24BmyEWR7ypcbtVVA30ApfCeeD70CINGUaYxww
         XfyaOa3VCVfhWCaFSwO9E9uuJru2tRVAF00r+i52+4fJCwhsh7vulJGb7V7sKrTKvUdr
         6piBjNqC4UtBQiZ9pNRQUlWQakcaWwOdIEi2HyWhj5ujXF3wWoufMpC2NR/jx0lwHBge
         MKCcDp4VlGOtVWUlBf5aGXb//TNX5NrKoobNvNeNKIh+uXTLJ1GIeM9Sx6ebn+NUzIJW
         eb/LPGlFr77r6xyihBXB3PQXPHMpVCBHjZB12QiKYOEqlkdVieODd9p1/0l08ytXKuuI
         p6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757497272; x=1758102072;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OA6/wMtVwYnCpFqHgoNVrw9oTr+hymfr3c9vK9x9Db0=;
        b=WOKaRsd4zAsw6j3kvfVrh0tA9KvvaV8lahUa1nvTM+H4lJGNNQrVqUc86woTqmN+Jn
         rGA6wL2nF1DUrVGuzmQy74BszgxKa6mNthc1ebrYqysROAyKJNw6MUq5B+hMv13olVHA
         3mhHnHo4pRfY5RFA6RmksTuF1BdTIWtVm7n9lnO7dT+l8r2mgYQ2YNXOgdSJ3KIs4bMU
         lyRWDaC2RQeQniEdmHELgMqT5n8eMAZKkaELGYDY+KtrrHqo3GGTkHJww3EDHuXy5/55
         8eTxKzTR+jlxh8tSL3/NDheM7Mh+muaqtYSm3OmZZyuqnqVzelG+I0eretrl10soxigN
         7FkQ==
X-Gm-Message-State: AOJu0Yz/ZR91dLO6e4KcssgY9mAxbb+ZjPXPZ5peKwt5Qgqp6SC3ah4N
	Idk9rUGpG3/S/bTRjGPPN6YqHOsQX8cAmlRNMul7/EfVOPq77ZMWx+78/iesoZK763OrSQ7errz
	yqOaZCKAY2+d8NYsN6BD9xz/+0uwWrF4MN+49
X-Gm-Gg: ASbGnctU6cgL1yx2Veug6L0CM/Hm4EpCRxwBrJEp0Gme0WvtAHrxs6OS7zfX3rCPKbl
	jDg36XoA+/HXteqIKlLleesMvvUQO7KBlGU73px1EFTiZ0YqQDtjWuPxJZ/iMUPqoxEPoZLWzvM
	qGX9FbrJYHj/PVSQt4kh65b3hrS2D8IfG4e5zyMd+8RNC+lmcaKUbsW/PoC9RP0RYHNqP5zHPtp
	y+mbgfAx1i+ZF86+w==
X-Google-Smtp-Source: AGHT+IEQPe45jsHjLs9e0gid2Iq0VyT9evDVB8Q/2lIHPn3VFaiWtw2j/AI8/Gpa3QoyhGWYai2dTKwtMYWhbsPdvns=
X-Received: by 2002:a17:906:6a0e:b0:b07:8972:2122 with SMTP id
 a640c23a62f3a-b078972216dmr163987866b.18.1757497271414; Wed, 10 Sep 2025
 02:41:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 10 Sep 2025 11:40:59 +0200
X-Gm-Features: AS18NWBrTUNAHF1d30rBMxi4d1i5znr-g9G67n9HlCCUUzIpGIhHDtw_jH4QnNY
Message-ID: <CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWjEwkExSiVSw@mail.gmail.com>
Subject: clearing of I_LINKABLE in xfs_rename without ->I_lock held
To: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"

Normally all changes to ->i_state requires the ->i_lock spinlock held.

The flag initially shows up in xfs_rename_alloc_whiteout, where I
presume the inode is not visible to anyone else yet.

It gets removed later in xfs_rename.

I can't tell whether there is anyone else at that point who can mess
with ->i_state.

The context is that I'm writing a patchset which hides all ->i_state
accesses behind helpers. Part of the functionality is to assert that
the lock is held for changes of the sort.

If this legitimately does not need the lock in your case I'll add some
provisions to keep it that way.
-- 
Mateusz Guzik <mjguzik gmail.com>
