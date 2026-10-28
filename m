Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793230495;
	b=MjAUBva4Roo2IqCbHpc8rhe87AvIAYUOKrGypOdLmg2XrpR1rRWwOlKaiz5chgOQ7kIf
	 TNs3m6C+rTLTsA0AzczBxnIg400CCAXfeVASscFSYAaKHJ7eQKoVLWhYFttExhJa0sq+G
	 RT9sfHRFiXajmtjhONv/CggcnLS82VVqKQ0E/vDuIIYiMGIw575+beYAeGpHg+ITPTrmV
	 LOSTRSr/7I8jI2Vd4m84r/zXKJAkAwk95TPhtgqgGndYpSXt7qoo59dy4GpTqBTvWhPZj
	 TEOW5AKKyz7JlfMEk8xIcaeBRlVn73o0Hf4M03JGjRmIPY0EB4fIBK1NMlZVoZgnZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793230495;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iP41gDW1dDLb62a6TOWXDfDFJDMH1BCLfRYXQKf/pYo=;
	b=vQlxMZ4lRmFIs/PgXsqZkVOVPDc/VrWW40yAQ86V0b648LfF/dAK3KudQx5TyFPG0Fk8
	 9LKAD6Us11Z8vS2/Kv+cz4v35KTKGUM7j8FwHBtxdXrFXgiuzIlfSs/wxnJoyw8Pw8N6j
	 h+MDUQHbBt2dfkctkKY+BJD/VW7n8fMyc1GUNQKu6CBBFDX/Ch09jwMpa/7JQFIBXhI6r
	 L6p4aaUFOs4RiaNzwVDGKA013qPtd2wBs02+oUxtUVXwaRqGNAdWs0BhNQJHBJ2yZEQDw
	 mezWpGEhulJcfH2JX8VH4WSQnFsei8W0qcykCkgVRrteOgOrX7v8qGaGKYhz7eYvi6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdtMsEtH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48220606A31A;
	Wed, 28 Oct 2026 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdtMsEtH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347B41F01825;
	Wed, 28 Oct 2026 23:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793230494;
	bh=iP41gDW1dDLb62a6TOWXDfDFJDMH1BCLfRYXQKf/pYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kdtMsEtHmDNzVF4YPu+ZcICl/ZXdKh2G0CtWnlPvKGDdE3v8xuBbC6zXrMLdclWYo
	 afqbXoVI2Aq17HAOhQ12dH1IgTkxmkhb6F9zPZcQgJpr7DY7tXfrOiqUB/Phl+GZYc
	 0DbkzFSurp4VOwEo2NLtp+XqNw2P4ttys0hVHicRAMPRsBDtj0f9UTckbATHEBhul6
	 MSwGskoKkUmFOldVwE9w4g7SFUZhJ/P64vqTjyibrLfSUH5WMOF3pzlbs3a+e6QJUb
	 UxpD7/mrdg4kITQFE012/68d5CU95sxWJPz6ULdbl7jLxopDYN2T3iMGZJ2iN+Qpb8
	 RgQCFRZe6bAfA==
Date: Thu, 29 Oct 2026 10:34:44 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Henry Martin <bsdhenrymartin@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Kairui Song <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Likun Gao <Likun.Gao@amd.com>, James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
Message-ID: <auKGlGJwOSZpioMd@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
 <87cxsto38m.fsf@trenco.lwn.net>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cxsto38m.fsf@trenco.lwn.net>

On Wed, Oct 28, 2026 at 04:43:37PM -0600, Jonathan Corbet wrote:
> Dave Chinner <dgc@kernel.org> writes:
> 
> > Unless you know how to fix the discovered problem correctly, don't
> > send what your LLM proposed for review. It will be garbage, and all
> > that will do is annoy whoever has to review it. Just report the bug,
> > let the subsystem developers fix it.
> 
> Just to be obnoxious...this runs counter to the advice we have in
> Documentation/process/security-bugs.rst, where reporters are requested
> to include a proposed fix as well.  It seems we're sending a bit of a
> mixed message...

These aren't security bugs. Bugs that result from maliciously
corrupted filesystem images (i.e. fuzzed) are explicitly stated as
not covered by the kernel security threat models. IOWs, they are
just -bugs-, and bugs that just don't ever happen in the real world.

The journal records are CRC'd and location stamped, so any sort of
real world storage error (e.g.  media corruption, misdirected write,
etc) will already be caught and rejected. Hence to get to these
issues, someone has to corrupt the journal stuctures and manually
rewrite the CRCs to get them to pass verification before we are
exposed to any of these issues.

Really, though, as someone who has learnt how to make LLMs generate
decent code, I'm disappointed in how frequently I'm to tell random
people using LLMs that their code is complete shite. LLMs don't
generate bad code when they are well directed by a human.  Bad code
is a sign of a poor coder (i.e. a human failing), regardless of
whether an LLM generated the code or not.

However, regardless of the skill and capability of the human driving
the LLM, LLMs will still generate decent bug reports. I'll take a
good bug report over bad code every day of the week.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
