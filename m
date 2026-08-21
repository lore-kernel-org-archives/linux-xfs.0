Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C603E3AB26C;
	Fri, 21 Aug 2026 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297770; cv=none; b=EIhm10vNdhyExC0pebi8h8yAp1GjIeJMMP8CdQf6s3NvHwV6lnMJ3/klfiuJ+TQcnRp7N9PUj2dRYxmyP8ZS9Lmk7D/DDqLZgaXatprP4pMyuAj7ohcNM5Sbxytc6XhbXU/lUdMGn+4pbOwX8WFsP9E/LDl0wrywsQ0XvBkElyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297770; c=relaxed/simple;
	bh=Md1obngXluxKbvYIu1ICh7GXlOtCPOrKFXCNTkhWiU4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YOozBLaz6gwWsbmWbb3riIn1Zxuq/mLs+8Q+gzBTtIVWL/MLJZ88MJyhD/iN7qAY3b71Vfkij9mwzQNyUcAcgEVjMNQOnHnib5Q6qWKq5nB9yzrYkWow9TY3zYfzFit+sANlGmhyGKVL8r047y5XLzTR5bzDu4TjQxPGkLwDDkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2U8IY2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2U8IY2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ED01F00ACF;
	Fri, 21 Aug 2026 07:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297759;
	bh=03eLvzHpgeM92hnYwCNYL3ohPDt/39Y2iqAl8qqH/FQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=U2U8IY2dqIk5fc4IQmbpMOl8XyrzCV8MGrc4PKvLl677mR+6rtv0KO7oUrLtQT0Fi
	 8eItrxljn7+cPGX7MWgxcTwFqwMDOg73+qCkoC8oRZdm/OFgAemzjSEvK3M0ylBVGl
	 JESirfFoosTx50HKSxXLua/XxGOSZx9aEWY/7CyBPoNmxL+/ldBrvZu6wS2Y+pIWEF
	 BxfpARddCWe3v7zBGJ7+0Sz/JHnT3YT/8HvlAdPawtHuMgUgRSPvooQwAh9DnC1RjU
	 CJJwr5ROfodDMRUWjZMClqcISsYrVAnHLvYZUWlLBiB2S7cJYv67eW572RgCQMeVdC
	 +DEAYAN/Om0qA==
From: Carlos Maiolino <cem@kernel.org>
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com, 
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
Subject: Re: [PATCH v4 0/5] Fix quota evasion on xfs and add
 capable_noaudit
Message-Id: <178729775726.580975.5711956270445280777.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 04 Aug 2026 11:45:50 +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Hi there.
> 
> This is the a new version of the series I've been working on
> to fix a quota evasion issue on xfs. I've got to jump to more urgent
> matters before the previous one so my apologies for the time it took to
> cook this new version.
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: fix capability check in xfs
      commit: e2f62a9744ebad3bcb6347a648e615026e9efeff
[2/5] capability: Add new capable_noaudit
      commit: 1b91724d0bdc470ed8f353d1cc8d3e4123b51ed5
[3/5] quota: Don't issue audit messages on quota enforcing
      commit: 4642259374fc9eb99af4cf8b2d54d54ccb0de08e
[4/5] xfs: replace ns_capable_noaudit
      commit: be9c45bdb19461889b16c91c185a284d665ea72d
[5/5] capability: unexport has_capability_noaudit
      commit: 412f89fb3988a344175899776c8bc7073524ad84

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

