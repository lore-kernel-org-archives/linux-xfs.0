Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F337D121
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222304; cv=none; b=NrNY/pzlNreQkbQz6IWrhf9foXkG0Ej+/GQWZkeRYgmhNMP4Y5b9r/AHXPnGeOm2dfyIxiRNZEj7tTGa07MUZghE2bmj2V0vf7wVAQMb/HNCnZwf9j4Vz+xkwHBfs/0Dl+gXVWDGZ6V1L3Tmuvigdt7lj/uwyus7iTDPjGr/Ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222304; c=relaxed/simple;
	bh=Ja2kTVz7ZBrWb/DwALIxGDlxt+WH2WY1qtHq9uDioqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpG0rlgwXOm8PP/COfaQAcqh+Fn2x3M1AlNeoSYFa2TRZiaKrmnxvFEzIS4V3Vq53hTtozmlt5dFGAxezWCO8iiRq3ccr9ORjhs4NfcQkSdqbfeKFlmGiR+mzBqMDOQDmkg9HHy71niwPBjYcbFUqN+umKp3d9rFPG7Q5WwnK6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kc1Qlbk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kc1Qlbk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6401F000E9;
	Tue, 23 Jun 2026 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782222303;
	bh=eeXsblJtuI29oNXXBDsUx+xN9hHunj8qnkFDX55kgxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kc1Qlbk/bcsNeXkNOa2C1dEJllv6xeUNjIaA+3IvXsLnOfg3kN/A3eCohWem5kncz
	 HWREqlBp4DSVbUDhgZIMcjASwPEcSk5Vs+bSq1b23Ga2UQMHIjHXTkK/BAf5L7Q7sa
	 TXot+qkdwKeFrx8tqO8wYJQAKmNAckYVbNUrsFrVbR0P/zVVFQw1YCg68KOlesNIjO
	 vRmi4qJMBAVBoaUBmBIqRf0EiiKz6cEa+zT6t36fLncgRTw1n4XuwjgqTeVJhb0XUS
	 6Bijn5fP52XpcCp7zHOsOp6Fa3FVAGepSbcxCwrAdkrn7abwABP3nuU0w9Hm89v8Nd
	 ncGy5izJSj3Ug==
Date: Tue, 23 Jun 2026 15:44:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: XFS group quota circumvention via NFS and chgrp
Message-ID: <ajqNK89QCTkKbHEv@nidhogg.toxiclabs.cc>
References: <20260616110804.5d26ff85@plasteblaster>
 <20260618230540.424cceee@plasteblaster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618230540.424cceee@plasteblaster>

On Thu, Jun 18, 2026 at 11:05:40PM +0200, Dr. Thomas Orgis wrote:
> Am Tue, 16 Jun 2026 11:08:04 +0200
> schrieb "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>:
> 
> > Dear Linux XFS folks,
> > 
> > I noticed that xfs group quotas can be circumvented via NFS* on vanilla
> > Kernel 6.6.x (slightly differing versions on client and server) as
> > follows:
> 
> I was asked off-list to provide an easier reproducer. Let's try this:
> 
> apt install -y nfs-kernel-server
> mkfs.xfs -f /dev/sda
> mount -o usrquota,grpquota /dev/sda /srv
> xfs_quota -x -c 'limit -g bsoft=1m bhard=2m -d' /srv
> echo "auxgrp:x:1001:user" >> /etc/group
> mkdir -p /srv/share/user
> chown user:user /srv/share/user
> echo "/srv localhost(fsid=0,rw)" >> /etc/exports
> echo "/srv/share localhost(fsid=1,rw)" >> /etc/exports
> systemctl restart nfs-kernel-server
> mount localhost:/share /mnt/
> 

I've been playing around today with this, and I think it's indeed a real
bug. I have an hypothesis on why, now I need to think a bit how to fix it.
I will send a patch (hopefully) soon.

Carlos
