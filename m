Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EDD14A4F9
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810366; cv=none; b=pNly7f/IoBgRvQicsduHZk0I79U27KIfwRpHi8TPDaFsL8q/iaXa8YXWulR2wSqCZ33xs0QgQomypTmOUio6Bo1Vyl/cBjLF/zs131oeKv/3ZEoPxXo68EZ+iGvvGHOTmqknCFGSxLMx4pjT7LlLV1lmpWyvH39ezGolaaDrXRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810366; c=relaxed/simple;
	bh=kLQwKT7CQRm1aVedVomGiHl4RkD5BxvZ6Uz8ZXvBO+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RPWT04cfXtiSjYtBGSewilgcuOxTqenM/3DqAo0LEyOe6wVFyMxr/EqjQ2m6f2XNbV7wWhOqzGF2+ViiBbcbWrCon6gt7IqHzl/sGGHy0TIqqo62pUd1x1Qhm2HKmhyuSe5eUBrEAKzg+PiMGF+F09kgGKbyIaJwBe2wAR4KGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=oNUXayj8; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="oNUXayj8"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-85c66a8a462so88110785a.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 07:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758810364; x=1759415164; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kLQwKT7CQRm1aVedVomGiHl4RkD5BxvZ6Uz8ZXvBO+8=;
        b=oNUXayj8uQ0Ru8NGu4sOa/i1394BtdWtFSc9k+alixlkvKpEDQ4G9bGuzZcLuKNw1c
         GvmfACcOJkAumhIau0F9EXurczmvrEuyy9odWt4nW4oIvGIli/xOhNg2n/6z3dQQhX1L
         /CZ38rMGo6lBNrZNgCaQ9UeZTgjYcopgjnTjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810364; x=1759415164;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLQwKT7CQRm1aVedVomGiHl4RkD5BxvZ6Uz8ZXvBO+8=;
        b=qCoJvnzb0IHOGnrMTNXIRi6gXhztne5PhNJgs2pxL7bda7coHQKWpXA0ZxizR3Tx2i
         JGvwyjz6vMJAooOOW5IHqq+Djr2L00I04C2BdOkTzTf89lyVzwgW1yhxbZuc5by4mZw6
         Ap2rs+XeOuhIv0DsjyPJuWu9E97NHiu1AqU1qZuq02nMd7N7Pp3fNspFbCQhQ25OqGol
         Ce9OlyrgS8Zx0a4Oqp1/TXovnPDG9tG4mu7RBiX0pM48ClBc2zBpOAENX+C/h0bChDDn
         CE8sRK4FyUxVl8Zr+0Nub7qxz3CZCybXhDoej+gT9Hbo2w37O2+4JD8sTUiAzAITIhhW
         jZTA==
X-Forwarded-Encrypted: i=1; AJvYcCWTPZ6OcsGveMt46Rhe2+Ez19JXH0crZx67yAuYc24LeoqegVl4zQ/FEIhc5Hd1417RHY+oCu5jkM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIsUuUO6xrhGZs94wWh9YQxrT4xDzfqXyOGBRtJBXPXOFBUHJ7
	ke3aNvc3RyckotmBBbGS4jlPRRwk7FtupQnVDMbC/ptuj5xi1YoAeiGNoQ2SDl/yGNMlMELI/tz
	uEET+lm2yScTX6N+qoQ28fGj8DU7mtsvo3RX1MFl4azeIIhN7V++u
X-Gm-Gg: ASbGnctvDvCMUFxPGnRu7BApYaDDrEicrnV5Qa/PtgQG88Wp04If6lFJweBDyfeB8U5
	eyoqKnaBANkCDR2JfIDx5Wy3PDJAYZbli5fBM1o20FCXoWFVd3CLtC6sUIt2OXeiydgKRjXO1Uk
	nOlk4ZuM88/jXuYFvhsxusXaMhyWF1Q6ZSk5befJ0uMkABzsgO+nVD9epMO1OFlBNqSYngXON+D
	oKhvHgmnLsd7NDGp4uBqRu+/kkdVQwlRzHSgs4=
X-Google-Smtp-Source: AGHT+IEWEZUeqguxX1KmPZKfkWXxC/ABE/OYX1wAAb5sent2at3dsouQvLb+RIkaiW+zn60aorSoDGZZkURvGlr7neU=
X-Received: by 2002:a05:620a:3902:b0:855:24d7:5525 with SMTP id
 af79cd13be357-85ad85abd13mr455953285a.0.1758810364013; Thu, 25 Sep 2025
 07:26:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798150680.382479.9087542564560468560.stgit@frogsfrogsfrogs> <175798150817.382479.14480676596668508285.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150817.382479.14480676596668508285.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 25 Sep 2025 16:25:52 +0200
X-Gm-Features: AS18NWBFMThGopHRbA-o-UBQbTeBlGy3BGU5JkoxwQuiBz9uVdcGsyESsqGmqaI
Message-ID: <CAJfpegvLLOOwzgxbGgRMQrv2m+HhA=TPhKgA9v9QXJjCe1kS7A@mail.gmail.com>
Subject: Re: [PATCH 5/5] fuse: move CREATE_TRACE_POINTS to a separate file
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:27, Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Before we start adding new tracepoints for fuse+iomap, move the
> tracepoint creation itself to a separate source file so that we don't
> have to start pulling iomap dependencies into dev.c just for the iomap
> structures.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Applied, thanks.
Miklos
