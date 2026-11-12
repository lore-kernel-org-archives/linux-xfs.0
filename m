Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491388;
	b=l72Ye7dSvcjc3d0YZMl8+D4arNIG6EdZruGbxw3wuk0wigViH7NPK5aMzfH3UQzjKmvc
	 SKIaPVEfozRLkWTIl+XJ/VTwb6JmM5t65dZG7BfoeYtJQJvuMa7PoS/OAhbSUJnJ3wHQV
	 SFFci/mnA93ucWWmkmck5tlNogNhiBZSmR+u07H1A+2mpl5aHDDkuodrWeel81jJdX3F4
	 mgSBXDcsEuDObqevhxDBkbC7gXOuZN0jCZhmbsssshVC7gW5HpbnV3yIkFHHv8eB7ttcQ
	 zsB/OT5svJxJwC0t/cMwP5Fc7weJO17hUrF4pnK9kDeBQ78fTziUc2QyeHxWFYDR8wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491388;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=XJqHaA+Lr6uyDKV49/9jNpG7MBF6VeHh5SiagRGqoAE=;
	b=I+ImM7Gd7glY9RXSXAOQrakqEicUCzQH7ciZTgR9Aj9TSzkPSh1fALRoqAFvDJbPU6V4
	 g614dbhJk3nmTvfLEokj4DGhlMOxSxFXeZ3TgQoGNPmYe7S9szHJMaAM0AI2RKbsVnvDp
	 1zLEay3pKlB+27fmIyNpTheqV4UOvf+v0y5gpxmwjQHtlIUDuIpqLwv4Y4AW7/WH43sTv
	 kVbxkn2KrK6g/BuEcKHDHqQK2g/7VZdf8v4hs3IkWxBsetrDaUyDTcXEpwjg7YyLci1t/
	 mkrGV3cfcQVmQqvLrUzAZ+tRqMDiYM63Hv+NhcuaLHQ718r4+djtlMUaRuCmiX6AfeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b1tPCf1V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E57606A889
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b1tPCf1V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8373F1F00A05;
	Thu, 12 Nov 2026 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794491387;
	bh=XJqHaA+Lr6uyDKV49/9jNpG7MBF6VeHh5SiagRGqoAE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=b1tPCf1VxzXiNnJMh6LIZf2IORpr0Dh7m5q2wMKD3cUzVoBBLXXJu9VWHMpK4ija3
	 g3X2GddW4aWHIE5k3eEswKf+0IZz+B3TOqC6ZGmQMA8jh9Loz/qLltzitvti8s0BDJ
	 TisNh/NnoL0iablhiZxonjLK0InZC5SquaC+0eOTnGK5D8gkQuLsR1NuMxfE3ZrnzB
	 qTP95fzqC6ARPoB4dbEo0kjtJTu367ekqu+lLB17pmbMlnvCXsO1Q38fRd0Qg1ybht
	 NtLLOMUh71cYdxzQsWgsqfR4bsZdkzxOWZWemCReNtXGVQVtTJLKkfSeKxo66bkT3F
	 jTWi7S8HpQzbQ==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id E4F01780043;
	Thu, 12 Nov 2026 08:49:46 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Thu, 12 Nov 2026 08:49:46 -0500
X-ME-Sender: <xms:-sP1arbnQ8vrUBzxhL5ZL_QdoZ8hvOPk1yXi7QaKCHgqy5x1dX4f9w>
    <xme:-sP1alMAbtn37yFwAS8RbgpqKHwj10JWYFDRz1JhOc9ly8C01CiQM6EJzvnpbw9Oq
    k1rD3U88C_xdrJKQlFGACvQ_kmq9YZ-9sZh91o7NuWAnXNSe7gVF_Tl>
X-ME-Proxy-Cause: dmFkZTF7Teehb4i+tE2VRse8X8CSV5y16KOINGMs2bfeu4Buft52gdF/iP0EmGw5gcGxlF
    WeWYCIwThVVpPLZDOg6TFwR9LuZCcj0eL/waoShAXXvs4yPhZ3BMgh5ocROVlUoRaewptI
    9aE1SJ/or7/cBJBgPjp1d+dn7+ppMefsJCKATl/nZTc9JkDJOdctvha8kS8EPbzr7jTQOR
    OZhgKn0OxKUndMw3jg+VdPNobrX0iASnGiP2qFgNwu1fXhTjA/q2OHnlA6MIH1T0w1OpL8
    yRoOD+gELg2190E+LxuwkIpdg4reNKGCgO4vMD1229T2sX8Krvj1q0xx9xChTmSZPCfYNt
    Y9kdCRdCJUz8QtschlLU83pnRXyMk+vtaUS4sx/JqCpHDSXnN0XnmEzdUrXmqP02ybvrcM
    hd0O+J+6O6LNEUCplZiunr0fHXLpoA2xqguRpmmAOHEviOHQNV6BV1pw2b8MYox0ec6PEM
    FS+v1dDAigxi1woP6V4cbZ2OjYJogTSIosaJEDSglVvo1tG6PIUmrLbuh5FU5wubQ3yLPH
    AS4x1ymSfYX9ylqgP+3iSexG7EnJO/Q0NTt8UU22clsUbLVFk0FOgWKX2nSLELd0q32v6P
    IDTNp2BlHv5iiYRovLdwjN2DUzXe/kDZePXgMyKIh53KPPWOHUh17iliVh8A
X-ME-Proxy: <xmx:-sP1anVY0CPrqxcZFQ3PkhHfHmcZn5NPDHFHPMbSQ1HZ6p_OSIQqGA>
    <xmx:-sP1al9GdcMV5QtCQwEqPCDrhQUk459trMI8y5dMJqzB60e2YoXQfA>
    <xmx:-sP1avpxrFTtwtMkDdt6zvzjOwCoYwDPiAYrhzhBhj77dfkzbtWxOw>
    <xmx:-sP1agLDuD-2DgwDXh7BsYRAo6USrUvCJfSWDkLUhBVxyPb3dJY26Q>
    <xmx:-sP1aqPeoDtd3EeyKz3Pry-POGYG6HPKZIkfSduWTBU3dL9s1dJd8D06>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 9A381F60084; Thu, 12 Nov 2026 08:49:46 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A7TH_TkPFIbc
Date: Thu, 12 Nov 2026 08:49:26 -0500
From: "Chris Mason" <mason@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Theodore Tso" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>,
 "Dave Chinner" <david@fromorbit.com>, "Jan Kara" <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, "Tal Zussman" <tz2294@columbia.edu>,
 "Christian Brauner" <brauner@kernel.org>
Message-Id: <b1d12342-ea96-4a4e-9049-af5345fe9b30@app.fastmail.com>
In-Reply-To: <20261112133555.GC22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org>
 <20261112010229.51029-14-mason@kernel.org> <20261112133555.GC22165@lst.de>
Subject: Re: [PATCH v8 13/15] xfs: resample the extsize hint after taking the ILOCK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Nov 12, 2026, at 8:35 AM, Christoph Hellwig wrote:
> On Wed, Nov 11, 2026 at 08:02:42PM -0500, Chris Mason wrote:
>> A write fault on a file with an extent size hint can overrun its block
>> reservation and shut down the filesystem, if it races with a change of
>> the hint or of the realtime flag.
>> 
>> xfs_iomap_write_direct() sizes the reservation from the hint and the
>> flag before xfs_trans_alloc_inode() takes the ILOCK, and the allocator
>> reads both again under it. But a write fault only holds the MMAPLOCK,
>> and FS_IOC_FSSETXATTR changes both on a file with no blocks without it:
>> 
>
> ... and my previous suggestion of taking the mmlock in fileattr_set
> would take care of this as well.

Yes, it would simplify a lot of this.  I went this route because I thought it was
nicer to have just the ILOCK control these things, but it would be easy to respin
with the mmlock.

-chris
