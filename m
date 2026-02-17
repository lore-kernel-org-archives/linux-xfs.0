Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1B27B33B
	for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771320230; cv=pass; b=Kg1ttjHIWG+8h95VkhYdUlSOPyDxaEC1rQY6U9QKFsdEIQy1uMpTLEwwZGNSrBpFzkwCmlZGAgizElC9vzD51JQHp71ihqLCBAux4+DeChd2pQ+E77kLhxiUJDb8Z22g6jmyKI6l8MvQpMAF7j4Pntqqp65fD2ECMdc/roPY1Hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771320230; c=relaxed/simple;
	bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dDmVaAka+lz5CN8zwzTWwlOz2JR8VUizNZ00YuBhUESP+jz5JafAFBsWCG3FieFu9HBIWPmap3DVUssuhBUlqMU9qdLIf3xEbtwWa8k22D5wQmYfO7maKYEbKMDXhkB00o8Xoaqv1hqYeLXII3dJrqYlqSDtNqS/wEot9S7s7Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EOfJ0AGa; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOfJ0AGa"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8fd976e921so266839566b.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 01:23:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771320228; cv=none;
        d=google.com; s=arc-20240605;
        b=YdPudGOHoEvUfPH8REVPHvRMu4zx8c2Fh0dVSM0VSP4sSGe7Q1GtgujQU56P5xzdAV
         NDeDEFBSJLY/32qKAefb0dOAGxLiCdILeWD6yGxqCiXXlRwTaxd5e8vxpz1wAVe9U4hR
         guyAH4Y4L/HyVFWXXamk6t8emu4h3BCHQCliMIA4b4oMewXVYxKj1KbMXGAEz4MPVvTb
         bffIIOks+QJ/3lin5ehTK8mL2XxgSfL6r4+N6ebZDnlUvYFTIJJtlhOj3HKNpBESarI0
         BDaDaNu53WuuaK7azx7+a625zmvWYPq1UTsrYv1gd8EoHWPumbAXyFPRiOOchQmumzXj
         6S+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        fh=8zYmulY1CQDP3J6fn+ITPUtOEXqnXOmB92Mx43qww6g=;
        b=bsHb3vH9XRcNZpdcLyBStRZNQvJ28rHJpkfoUdgC9ivKvJG95rAXZQ76EcFhv9W8eI
         fT3E1/k/jyoJEC7nEuU4ITLygzgLtZ/LyUQvg8KzHwFoP+vE1dGuWWfX5yt5JYZkuH22
         96ghazBKu2edlsZMdaYEnjh2AnmJERMUuTW2M2Rx+5ITMGyJu9ZIzcX1t2rA1tezO0sm
         bavvx12qnpn7u07ZLL+irMDfXrDTrRF8hRG3W9QJ1p3wmAn5w6T66/Dp8OcxfF9qmYag
         d3898bO8aDDbBAETA0GzlIAWv989wx0Oxvk0Wz1PPMK3Op6Z4CJcTPOUVDe7ldtpomXo
         k1YA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771320228; x=1771925028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        b=EOfJ0AGafuVMabGtPoDxKXxiRNWnhtn3s4gpiKaIVmuoOe4xT01UmOl1gco0cNuXOF
         L/mZShoZZdmR4fyDrq11mxQAS5s/Myqj08iN5Fzfn+WUpgAgLvdcpeTKNpUmXMA6SvrH
         E9U/8uZ59vwuJlkfASwrjYIx642dJ9LJ64n6Q3pNUiotqQIfdizi6b/DCd15Go4aVMYV
         cBrZ2+SB14YLFK0UbFy3BAJrnMfB806lA9CTwJXpfQdHPD+z1mh4GHr/E20SQYw9fCcG
         6rcbV/Y+xsyaV4M2d1oalr0mjgrbWxYdU0JGxxrWrQ0EJ/6LQB41svRJd1Eg564t+XRH
         WalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771320228; x=1771925028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        b=V73gyIorsq1x9A/X7JkAYtmL6g5Fhs4cYxzUUEzQeIsIu/28X+BKpGjUGxRQIyFwEm
         x387HViPm8bRykDM3NlcB7EHFEBPxjJutcabjeByor6AJux4d77zxyLPoyI+w2TaGwgG
         75YHHQDmylulciIIz9GyTvjjiLOIKyn2egh4/3pTKgWenTCh2dH7YXYyi123SDbg5pQ7
         2L5qAz7mBjr6gCKluqEZ5f+qnZZGmZcXO665DVZIYmtpi73QTJB+OVDQJsNUQkcKdU3J
         ctoe2nMNbbDmf/F43vyEAomwz8GQVqPtPmzLRvMDgmkv/fefc3qPiG1YF8ivsxIQsDxf
         mCZA==
X-Forwarded-Encrypted: i=1; AJvYcCWfFmkP53dXd30fl3Bbj9LLDCOmeAC1naUKIbfu9MSjuh/NvRoY6mIiU5D7KwrP3NGUfTezg2J+gz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytke8rvlsy+HdJ7LxInxzr1z20IQlu4f4hTzazDcX1/NRIEeQX
	4Kc0JWn9JJq6NswMOXYZ+SVDAoo0kcSJELJ7khmsdgZVVoqoBtdKFmt+uKoeq2tdtE3sP4Iffgm
	csL483zN2hQlfJP7T9SaGgD9v7NlTs/EukD2B
X-Gm-Gg: AZuq6aKgcq5XCe4K0FS0AmMc7MG2hlFRzMegBkQ3GKqCLLTIf11056MWH4EF44DnPp8
	NoWcqan0Kvu/As7IkJxy+n3iEpAz9O1ONnuwrJ7KOxvYm+I50sK4cUI5u3eoaPLf9JroPvn/sDr
	1Iz1vL9l1KU+130RdLDxQw3oJccM02fjCyXOuzacCI+Ke2/i2bbOKdb2hx5/xv84Yjn/OeoDl98
	mV63DMwgaMOlvgoJ/W0cax71pPpd2ZWjmC7oIPY5HLzI46ePYyMPTh4HYgCd1haGIbappBgcRDb
	JsYa1IW7
X-Received: by 2002:a17:907:e101:b0:b8f:e438:75ba with SMTP id
 a640c23a62f3a-b8fe4388da9mr248776166b.29.1771320227576; Tue, 17 Feb 2026
 01:23:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <20260217055103.GA6174@lst.de>
In-Reply-To: <20260217055103.GA6174@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Feb 2026 10:23:36 +0100
X-Gm-Features: AaiRm52xz8EBc9OEZec10DoizsQ3eTTptMfYZb6-P8BJzMypru0h1TRDSfoM_ik
Message-ID: <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, 
	willy@infradead.org, ritesh.list@gmail.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, 
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, 
	p.raghav@samsung.com, vi.shah@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2026 at 8:00=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> I think a better session would be how we can help postgres to move
> off buffered I/O instead of adding more special cases for them.

Respectfully, I disagree that DIO is the only possible solution.
Direct I/O is a legit solution for databases and so is buffered I/O
each with their own caveats.

Specifically, when two subsystems (kernel vfs and db) each require a huge
amount of cache memory for best performance, setting them up to play nicely
together to utilize system memory in an optimal way is a huge pain.

Thanks,
Amir.
