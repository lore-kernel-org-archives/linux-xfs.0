Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5541556328E;
	Wed, 14 Oct 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996812; cv=none; b=O+O6eZCszIvy2T2rwCEMbTYcsNFoHvri91yI8Qfzx6LHBUI74sKjaicfKIH3mW3HWfSG1jjOZPFeq12Nrw0Iuf8w83pLHK0vyawl1iEIyL7ozghcfGicTM+pYNxlE2ZMClL3ZH7l6AzIu4/8TCrjfvYDSSEysg6C3UQlFqhhPiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996812; c=relaxed/simple;
	bh=JArbZIUt+5W3TtG2LggovZ4S5nrrS3IgZgVIrAxlo2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOkGMyaDN2vBZr+2MDLKzXCOBWmcm+v4Z4US1BDn/HoaxCLVkz+kl+FlQglizJ3h1f/SGHyh7WBCbUY+khxJr5z6ZPBLUh28ZuTf0UHrlNDcfPyCCsbReZlo3qBNfc/+WKR4Pwti/NjekDfsltvjeqMKHtUdGc3XGjqz7HYVNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSlvsQK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSlvsQK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72811F000C5;
	Wed, 14 Oct 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996810;
	bh=mUKzizrrqro16HGBBmPwlsBws7QxBEKqP+cXVmCU4iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSlvsQK3jCpdjMtGqEoGDezcOddRvFlVa93TSl08npUOHUSl7w754vNNOobkMUvPd
	 lNsAbOlw5xAT0O9+tmjg2rgkHTpGInY0eFUX8btVpT5IJclFgyK688Tgi/8uQytjTe
	 QtMYhGOW4ar/VLvOSaxRWLIScfdb/2CjHgC/LHNFAWvZey3aLYrb9efFedMhFnwPyo
	 YdvkGW+SyR14q21surCbfvZKjU9ErVLf9hQslJhBhEKqbMcIpm+ILwyMTmnFW8shjh
	 x/jK0hIQmz6nzJXUi2rDXqiBMoV166mA9j/uDHJQuOgGKCZgGrfpD0xCIRSLyk91H1
	 S1McNLHuQrRKw==
From: Sasha Levin <sashal@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Date: Wed, 14 Oct 2026 12:53:12 -0400
Message-ID: <2026-10-14-1-daily-reply-0009-xfs-umount-hang-6-6-needs-ack@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I saw Darrick's ack on the 6.12 series. Still waiting for one on this.

-- 
Thanks,
Sasha
