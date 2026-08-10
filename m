Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C181439359;
	Mon, 10 Aug 2026 18:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387674; cv=none; b=m4TfjARNYsUYSET/kHpmQstZqK5Aid+nZrggceP9dOx2SbgUS86Rw+03ttLcswBTU/ftvYk3XUxNZE9xOzFHOZoMSKd2Wlzy3acHb6dIF+wy7g6gpthilvNG3KWfULaqAiRkkZ8wr+DJz5Lum75Iwi3pT+i9HqiXo/gh0ElkP1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387674; c=relaxed/simple;
	bh=wKPc40qSaoRKVCyGFH9JLvWK4+rm3LgzLuumJxmpJYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJVPxZysyaOa8CTveSeW06OoNGOrciX/Jt0r6ovhsutiBKaks5j3bZDo81wxWK+roPwIQetfTncdd8VmnBKarwWvoiw4ms/ntiVmIYHlU7WZzeRHYCyG6YU3N+64cnEOeP77iZTlQQ4prEoLAf0RaSa4gYNqExwze6mUTBUH8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JktxaIKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JktxaIKa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 62A261F000E9;
	Mon, 10 Aug 2026 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786387673;
	bh=pw5WvUuegL/DM2xZ0LP/RHBcvEqawmuu0SOQYhrxUoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JktxaIKawAaRareXhDuQ4C/fupUh6POtSDAlEemxRmxIJKhJR3fq057aBYzm5LBQq
	 3fhKxCEuVPXhM+IGWjsswBlXnz+6MjC0eWFt42ZIjDv4AWm6fEyHypypctvUHWoydo
	 Ohf/yq3LfZzRdR2yIgNzDvhrhnZMo2XsNfnOUicuzJh1Mn30YoE2GouYnkRR7kCa5a
	 hlUFA83ALj6hbqANEcN/YZg4WCdk1KtFxovXKc/BdHoXkZ1SCPN8A1K2ljiA+KsUsM
	 NNFJJ/5rF+YnAWs0IU1a46OOCpabqngR3toDZaapbhnW8NZuyywLm33H1KZCMvaSuS
	 N26iVWRxeruWw==
Date: Mon, 10 Aug 2026 11:47:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <floss@jetm.me>
Cc: Javier Tia <javier@peridio.com>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/6] xfs: initialise args->total for parent pointer
 updates
Message-ID: <20260810184753.GU7398@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
 <20260810164312.960721-13-floss@jetm.me>
 <20260810180802.GS3556460@frogsfrogsfrogs>
 <20260810184005.D5E4D1EA006B@mailuser.phl.internal>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810184005.D5E4D1EA006B@mailuser.phl.internal>

On Mon, Aug 10, 2026 at 12:39:48PM -0600, Javier Tia wrote:
> Hi Darrick,
> 
> Thanks for the reviews on 5/6 and 6/6, and for catching the args->total
> placement in v1.

No problem.

> Noted on sending revisions as their own thread - I'll do that from the
> next one.
> 
> Patch 3 ("report the error that made deferred work shut down the fs") is
> the only one in the series without your Reviewed-by. Would you mind
> taking a look? It only moves the tracepoint ahead of the shutdown and
> logs the errno plus t_blk_res, so nothing invasive, but I'd rather not
> land it without a second pair of eyes.

Done.  I did actually miss that one, so thanks for the hint.

--D
