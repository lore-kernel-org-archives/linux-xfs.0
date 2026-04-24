Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5582264A3
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 04:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777004919; cv=none; b=YaUpjFZg7o17X1pEIIu7HFyZqENItj3bs107paHPb9c2506VviypqdQFaj48ezSgadKNLmA/yaxUVCmOl+q6ICTYzjakDmOLKf3sCqwuKECaKD3KMDuobsox0zoyIqNO9dsRuYdaZgWpcpiz1b6mSVUXuwM0YMhAZHLTs0X1D5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777004919; c=relaxed/simple;
	bh=deWB6UrI5bI99n3jNuoT5xgmAqlYj70Qfhs0/y0QX9M=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=nwjmCmngd0e9dwtQM8yIAvSsG+REFRIl6RwqdM8TAAZPMbGEnFsRjIt3v7v6miU/gtR9rkR9KIXytLK0c2CGhSiWNGAmCptLdbe/bR3c+wJzvDPwfHMCzlwrJPsGMj75N9WdQlu3NCQAa3bWCKjGjiEly7YTuA2C/clP8KzY28k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWIiTl8J; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWIiTl8J"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82cf636dac8so3164001b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 21:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777004917; x=1777609717; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xij6ep2gWC7gef2Qky7OxxlHC1yt3hwCxCR56tcvUXc=;
        b=cWIiTl8JHWvMEvypf/0To1/2JH1aepp8+jvD7bdYs37I9x7pjWckXi4ihZI+pyXN3H
         arPNZVCvss0VVyu4ZHm5Mi3evPgMJ+S64SmpM908LkmJMaqCxPLSQ3CY9hDjJkRiILzP
         EQhwnoqeYiR6XNhaCtWAeH8wtjkA5PRBQ7/wJdhYHorsc1vmZCc60pmxVF4y8QcmOrO8
         K2cAn7j3JSbJgg6tnbi1lW5jbtsvDyYoinSR0th52s284jlZ1KQyOCOKLl8tM8wNvA/I
         2sdmdqMVHDinwCV/FLBAff4/wzOfZllCZKCJyF4ETq05VGWe14oezZ8ibMjNuAnSD2Y1
         dTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777004917; x=1777609717;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xij6ep2gWC7gef2Qky7OxxlHC1yt3hwCxCR56tcvUXc=;
        b=jtF+CFNxxLuE9/KRgGwvCgUqm6PrpT5VuMj4mjgw9CilwQpFqvioYiGgJJyusM2b0g
         zaRg6O8HEAZXYlgD9gu1YfANdeDOZ3R98HocFc8q874R19ncr0g9OEAYP2t6AMamDWHG
         faP3HUdODvSoxDs0epJMpmHTrX2+1I5FTgp8AoO/PenCVyDqb8M9dKJj+Bahb7+OgAvk
         TU86ohTakjbKxreiOqgHV3dh9038lr/idnOIUM9NOoBU2kE7pErO/hhH+Eis+6SLq1Wv
         7vRLGWPWfbOQuB8GSh1NZmTvkFUv7MyyR+l5JQ96OG/rvNrTepk5U4x3XWh9Bzmp9Cb+
         /1tQ==
X-Forwarded-Encrypted: i=1; AFNElJ8AqWrjmZCKVvSoCs9eC1LTCHU9XrirQjnoRgfCs8qGeM9obd1NG4lGSN7zbhfCvx8Py7wDBB/B2H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTSQ254qrNugxYcFDIj4oDYTwnrHy2sCQ0mHWdJcXvGUQ1TPoj
	2ZXGP6b3i3Ktu/IyeLL0V1AzqYHxqEOCQqaZ7WLwztbTQEIdkbZ2B76w
X-Gm-Gg: AeBDieuo7BzOHIUIkIn7OOtGF49u3Zn660hgsaZzQNAO054R8+PTdzTqWj39GILRDYS
	ugiAC0e8Yu6+K9nb1bHI4ngERe0uew6vej46nQWFWvrFXRLcLkwSGzCRjxqNem7KDHfdRkyJ6GJ
	fs2alI86A/Bp++CMPaWEgWokgzqzHegT5m5ecvZmB8tC2dd/AosHlE6drbrk0bzBmPnO50k4K4f
	lloZesdA/GqIpwxlEGB99J/YBDl7g2FOFIlnwkravipcPzVJPEEljfc+clOFvMNqTnnR1Bv0keh
	f1Vg+3UGzhcVn9J9xVeQgkipb4t3qLEFxcVdGqlThSIjelnstIgE+0QB5GwusaYfpj+PeyNf4wO
	zwDzS9KiCfg/ZzJP8B89RWcMecFhYtj6GHarQ/vCxVqdL9yQkLhytymGp6WtFwksJ3yK0dxI9Z8
	OkO8dxERyL7MyTEXXFHN6dy3ib3etJxMwf3GXXq3Spn4A=
X-Received: by 2002:a05:6a00:cd6:b0:82c:eafa:8875 with SMTP id d2e1a72fcca58-82f8c82e889mr32885163b3a.2.1777004916865;
        Thu, 23 Apr 2026 21:28:36 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebb33fcsm20983354b3a.33.2026.04.23.21.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 21:28:36 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com> 
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Date: Fri, 24 Apr 2026 06:32:03 +0530
Message-ID: <wlxxrx10.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


Hi Christian / LSF committee,

> The preliminary schedule is accessible here:
> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899
> It just hasn't been liked on the website yet.

Thanks for sharing the preliminary schedule. We had a discuss about this
among us Me, Ojaswin, Pankaj and Andres too is on the same page.

We were thinking if it is possible to extend the Buffered Atomic Write
session into two "continuous" halves of 30mins each (total of 60mins)?
Looks like in the past couple of months, there has been some good
discussion & progress on this topic and we feel a 30min slot might not
be enough to cover everything, since we want to give more time for
QnA/Discussions.

This is how we were thinking it might go:

Buffered atomic write: Usecase & Discussion with Postgres
I think in this slot Pankaj and Andres would like to cover:
1. Buffered atomic write usecases
2. How Postgres would like to use it and why is it important for them, ...
3. Q&A/Discussion

@Pankaj / Andres - please add and/or correct if I missed anything in above.

Buffered atomic write: The writethrough approach 
Ojaswin and I have been working on this and since a few approaches were
tried, before we landed on the writethrough model, we think this may
need a 30-minute slot of its own:

So, I think Ojaswin can cover the following in this slot:

1. Briefly cover the previous 2 approaches on buffered atomic writes and
   what were the problems in those approaches.
2. Design of writethrough and its use beyond just support of buffered atomic
   writes.
3. Performance concern with the current approach (not sure if we will be
   able to get a thorough benchmarking numbers, but will try to share
   some initial data at least)
4. Q&A/Discussion 


Do you think this is possible? It will be best to keep both back to back,
so that buffered writethrough can be discussed in continuation.

-ritesh
