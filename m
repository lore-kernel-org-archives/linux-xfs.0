Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173808;
	b=NW7IaIAo7z6acHl8chyiiSol4U6qV0WIw59yjEqANLXfw63/Gb08hd2UcuS662l+BIdX
	 z2OhcDdVE2zPGn6NpqJH8XX31WXnTs1+ohTW9c60Fjxn0kfWw5y/ePZURSCCqDw5i66I+
	 KA8aym/x1SnM4nFOgTfMC30BXH7ELbl2t4VfOgr/HxEzIToBBiC/iD8JgpgXwREQFsMAI
	 gv0d2nvjbraTLcBf/nUF260PeZqhc9YuiA2wAFSjFSIBr8fpir+utky67pqqOG9EYgiYJ
	 2sJ9UKNaqwyS2LwF+TmllRTZM/CxhQAkeIJ59+ebytGqt4UjB9tiYmDo3fXYKT88Bdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173808;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=i5lafit4UmJ7emet+k39+N2owC4JKjAs2LSx+uXECV4=;
	b=p0ms3VNGTZgiDAlqsSldaqHbx/S4TQLMr5qrW7pd1VcjIZn722SItEtK0s21l9b4Mz6V
	 leBBopwBpzSpsx6VDY5m60konMiFjTmTW2ij+NSknCUpvlIu/631i8FP0CH4qdUkqPHKr
	 8gt4p1m0hNjz/0LFbgYxOWJc1keSpnrFL7VTr9gpxc027WGqN4wVuTU5Uk9OMT+ZsMjGm
	 Ld4JFh0R91iwjV/E9Mwnl7FFiEGMgDxVzq57uwLa3mOOD9PrkHVD+13T9eBGWMiPrxYfR
	 5Oq2wrh+dSwmBiCryrwNc4VxuK4MllcKdMi53NfegiHOb85rGIn7l+wuU4HmdTIAIfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJWADXIi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3294606A332;
	Fri, 20 Nov 2026 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJWADXIi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736601F000C6;
	Fri, 20 Nov 2026 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173808;
	bh=i5lafit4UmJ7emet+k39+N2owC4JKjAs2LSx+uXECV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iJWADXIip+BzTBwd8TMTv4KT7x4iWmlKnnEUYkSa1lexez+YJ+I85aiAuSo1kOp8j
	 nEIldJvH4LEw+ecM3mnl+ITCq23vh9wjRPc5nt8xTonAudZo5AB97N9S4ibH4log28
	 3tknTW2mkl6iiBMF1kZnU8OhiZIHSqzxrYDoCwL06a+HsfNYBBlHmBUjgsZLqdTKB6
	 i85hE0Li+8USpSj302NoyUcnjX9fN+xypo7Zv9utuIHTbQBNWTCLapRoLdxwO3A81W
	 KmWnYHcBOA6CzteYMOatYYIQVx4vO14l62dxh4QoYpTTPowyYkNJSUFvHIMgupuzEO
	 zTAJb2nKuTMQg==
Date: Fri, 20 Nov 2026 12:23:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tz2294@columbia.edu
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <20261120-echsen-wolle-gekonnt-03c21df2493a@brauner>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
 <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>

On Mon, Nov 16, 2026 at 12:05:26PM +0100, Carlos Maiolino wrote:
> FWIW, this is another patch that would normally go through Brauner's
> branch, so just in case once we get it settled...
> 
> Chris, Ted, Jan. Are you guys fine if I merge this patch through xfs's
> tree?

Seems fine,
Acked-by: Christian Brauner <brauner@kernel.org>

-- 
