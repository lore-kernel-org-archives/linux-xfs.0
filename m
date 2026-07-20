Received: from sender-op-o14.zoho.eu (sender-op-o14.zoho.eu [136.143.169.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC255419FB9;
	Mon, 20 Jul 2026 12:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784551592; cv=pass; b=YlWqbhzfa2sz2kn4mV+KuT/V9cBdfEgX0Kop0I/u/7UiQ/SBZ+MPrRzpEtGeAWIogcQNw+eZ+fEq1rSbi3zlck3kc+svxYNjP5/N2RYJ7j31p4Ou7WTM99BhpToN4fFAe0kcotkQ4OyyEVZz5QmwGhWmixdTPP/eO9GTUba8a7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784551592; c=relaxed/simple;
	bh=A21SuCMct8jYdJaGI5z4aCBpqvBz8ETTikKrqfEeSm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyIuvi/B2kTVtBdBZBAk3pqX6mg5kABhCqDpPkgPWl5B4HJ+bMrJiOjyO+KZKGvJtMYwYqGaABj9Ivvj4Q9l3Jm0yRUENyFS1A4ttQSm8EOl1//aw9Q0B6QmCwIzeWen+GIMKvzczxAfiuaYZOPwaMcOBKqQQJDEYrsQMjDzM+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=a8YPrQxO; arc=pass smtp.client-ip=136.143.169.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="a8YPrQxO"
ARC-Seal: i=1; a=rsa-sha256; t=1784551570; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Z53/NIkPoiOX4C6ww5mOKGV8z0+2jJoXPxkeKIfj80ErOFRZdCJE3dplKhnJyztwj3EPzCDHpOQkrORk8YG3catHRjl2fIt36f3woVw9Kuc7aanZTmEuMDuXNV9yBW5yGl+dA9eyLCSjPU58Ajup0SrjTAp7lQ8a2mD3q4XlX88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784551570; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=A21SuCMct8jYdJaGI5z4aCBpqvBz8ETTikKrqfEeSm0=; 
	b=H1+oj51OjqwLIcSEHBWi0Bet6Vsnd89hhOHJU17TMFBemNwd5XYyo+VO5kMaCn1yG+mrBFUfAR6lyfImaxafKC3hry/tv0MdX1EVgqsnm7hD9jo3DHtjbvvjBaPBY7mXqfKdQbvBi4a/2Ac6GKT6EfK1SFyaARvq12ilPrcahEY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784551570;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=A21SuCMct8jYdJaGI5z4aCBpqvBz8ETTikKrqfEeSm0=;
	b=a8YPrQxO29rP4ZTXFfeusuwYKbZxG9mUV9K4nTFssvfZPRrFR4sr71i1wv3NcWvz
	/ktOlHzOcvDhqh8ufms6FE9Z0fVGOGx4fEGxNC0DHEAxC0fedVGH5kaA2+xrrGRZCLq
	vndGhwRMkF6gAAOSfjN6bc8p3FlGClgjC562+Fwo=
Received: by mx.zoho.eu with SMTPS id 1784551559243859.9312577221739;
	Mon, 20 Jul 2026 14:45:59 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: cem@kernel.org
Cc: djwong@kernel.org,
	bfoster@redhat.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] xfs: bounds-check buffer log item's dirty bitmap
Date: Mon, 20 Jul 2026 14:45:55 +0200
Message-ID: <20260720124555.1148-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <al4OdTezVWyhrKwe@nidhogg.toxiclabs.cc>
References: <al4OdTezVWyhrKwe@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

> We are starting to get rid of Assisted-by tags mentioning specific
> models or completely getting rid of them at all.
> If you are ok with it I'll just remove this tag during commit time, or
> if you prefer, please send a new version without the tag.

That's fine by me -- please go ahead and drop the Assisted-by tag when
you commit it, no need for a resend. Thanks a lot for picking this up,
and thanks to Darrick and Brian for the reviews.

Ibrahim
