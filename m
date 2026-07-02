Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CC24A2E1D;
	Thu,  2 Jul 2026 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000063; cv=none; b=P/Okf4YeK3c0hmO+7eUVolmNFhhw5dZjlo4N17MRfFDuutidryrwQzVCmg45D3+8lZPiShKGR23fgvm5czN3oy/K0k1p3zuLKD+O0OmNlBx0Em1nLa2S9kfqtinXRQ2lCH5NrU8Mifw/yUqLdu7yCGnGZeme9Yn4+NgGENHcKns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000063; c=relaxed/simple;
	bh=BtUuPo4rwOuAsACUW5icP/dZIxX6SpO67GmMNH+HFfg=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=VDKWC9MPpAJ7wayMIPUp57B343n7nL5pXEVvKq/JL2///sYS4skxG6EmxcVJp8UT8TbeGgRA1Q2PpIpXHMdl58BeGNaB3N7R9nXL0ZHs4iAhUKU+jczq/GLVHcblpRSW5s6jLVsHo+KIE2/NjzMsVDbo7zMu1Yzt1XXjOu9KfZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO7MTJti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO7MTJti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A061F000E9;
	Thu,  2 Jul 2026 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783000061;
	bh=MPni0N/LlpcvmfoFXoNWHVdplzRY7oIGz7o9hlj3rB8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=MO7MTJtifsY2SlktWpHVud+MxcoekewRRrXRcvK2KhhGQjop1ketFqCcQDKedb197
	 Ni8S7MKEhbWLBLOHO+ktpHRFPo7/0pKaoynO1VgTts33vEdJcf8IGg4QQffhFR43um
	 oRA97Mu++74iP95WqqnmDEOXC1a/IeQulVnz/xCPfq5i2Ew+/BbHbve57ZhgQSiIvw
	 +nJxPQr0E1N9exby31Qswv8Q6baAdJzUQV8AFKmXW3o+tGEWsFth7I38hcCTpuhtmA
	 ubVgymEH7w/hzSiuf9UfiypHfc12k1wuVTJM8xDH8D5y5vK2Wupumdipcc8DsWLNz4
	 Y3O5C6gOrwxVw==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/4] Introduce capable_noaudit
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 jack@suze.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com, 
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <akYimPrAcHlv7shR@nidhogg.toxiclabs.cc>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260702-alufelgen-belag-tastatur-b666a49f7fc0@brauner>
 <akYimPrAcHlv7shR@nidhogg.toxiclabs.cc>
Date: Thu, 02 Jul 2026 15:47:37 +0200
Message-Id: <20260702-fortsetzen-verarbeiten-abfertigung-ead54cb2e597@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1381; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BtUuPo4rwOuAsACUW5icP/dZIxX6SpO67GmMNH+HFfg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5Zf++m2O/Q7S0eqHztJCpUpt3Wri/vv5qxnHjdZlzZ
 z3/9E7rZkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBELk9gZJjpmjrZ00zjmMyk
 GaW91xkXiAvLay//OqfgmljFbZHaT1cZGRqmSOXo8jwIi/94qFjAr9LShnFNdYRN7osPFR4lz3Y
 /5QYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-02 10:35 +0200, Carlos Maiolino wrote:
> On Thu, Jul 02, 2026 at 09:41:39AM +0200, Christian Brauner wrote:
> > On 2026-06-26 13:45 +0200, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > > 
> > > In some cases - filesystems quota specifically here - we'd like to check
> > > for effective capabilities without issuing spurious audit messages and
> > > without the need to specify a namespace for that.
> > > 
> > > This series introduce capable_noaudit() which has the same goal as
> > > capable() but without firing audit messages.
> > > 
> > > Also, this updates both generic quota and xfs quota code to use that.
> > > 
> > > The last patch unexports has_capability_noaudit() which was originally
> > > exported to be used in xfs but turns out it does not meet our needs.
> > > 
> > > Note this is based on top of a current series I have to remove
> > > has_capability_noaudit() calls from xfs so the xfs patch won't
> > > apply cleanly without that series.
> > > 
> > > If adding this helper is acceptable, I'll turn this into a non-rfc
> > > series with the required changes to apply properly.
> > > 
> > > Comments? Flames?
> > 
> > Convert more, please.
> > 
> 
> Convert what? :) more callers from capable() to capable_noaudit()?

Yes, there's more code that should use the noaudit variant. Future
work...

