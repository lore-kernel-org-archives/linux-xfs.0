Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67EE322A1F
	for <linux-xfs@vger.kernel.org>; Sun,  8 Mar 2026 09:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772961571; cv=none; b=NC7QDmboH8l+MZETDNxD5YqcqW6YrlXA6U3nj3iFJB4mp3V1VhSBDQcLKQi1i9ieQSkfXy5LymjCDy0QFpNwJZwF3pTAEyHzFV25H9UxHdsjvYtvi2jvzK2KarGV8U6BeXrRogmxfZ3+W0wlColyKoqB/SfV2+YGLXDfwSkyTU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772961571; c=relaxed/simple;
	bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
	h=Date:Message-Id:From:To:Cc:Subject:MIME-version:Content-type; b=F4kRDe6+o/g9yXgYxiOg0fhmLxdTXCljb3odWrGQOagbh8Y8wS158R++Ml+E2nx7g6xmyVqufWSXFxrLho7ZzkbFBrbrw6AQ/ogfOPa8dm2F5yaLULi3BgHf1IhhHqnaQuhP4/+deY+v6VZzRxYGK6+o2O/Xz1s8nWrNEmMT0Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LS3BZNx8; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LS3BZNx8"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8298fad2063so1666642b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 08 Mar 2026 01:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772961570; x=1773566370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
        b=LS3BZNx8AzNx7qnmiBP27oh6GYvUgCEBATLBYY3qytWtx+fSHxuVFhmQ+FzkptCmxE
         COXIKbxt8fiSe3qoU/oUUNJkqOOt4Ii/FM7+Nhayr7td7pdEVBxiypYTMVgwdiCYehMD
         2X4YUdpeWs6L8lC1xLbiNr8LtJ7OUQYRDKrS74y+E+KQavSwLoSNagI5lstpy6KaIbJ1
         IGf7CYLXBlBu+l8d/nJZ/h9oUjJiBanIDEpDmrEERnKIpB3ajSxtFKXD98lZUxaQPibf
         a9c7//W78FWtjcsMfnXkxfwQhXNaQSxs6O99RzSuCs4ifvnIWB4caQygtURoY/tCyavL
         6Qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772961570; x=1773566370;
        h=content-transfer-encoding:mime-version:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
        b=qmt/to94iXpYGNvpj9bC/D2TpKRAuQOqRKSykje8BMB+fCxO+8w8CVrCB2jVYoxBYL
         y29SQNkoyJF1AZw/ym7nBFQQBakQsglL+v4YZFpWACvTTgVOkv0S+Eq5XzsMgNIRrf4F
         c26eUhTc0RWJP0lro3d3H4SXdH2vg+68jwUdQPu5nCEJNLHRd1boH4GCQRQx3BiBiRn7
         /J47oM4PhrbVHJpJ2yEoQNeEm1MzjQoqVjGGNEt4LZSN0IvzLkY7G9BkV2K1m7OaJL2y
         liJ/SEcTIEiO51ltgxfrTSwB/Sshqjv5wQoW3SJZJxwcDLVIXGfcWo+hHPLxVWdxn/MN
         Sd3Q==
X-Forwarded-Encrypted: i=1; AJvYcCURSuLVCOEPN9vvbZ+jwRwNSjK9JRnI4b+ykDOEWyqAYPj1ADV6EpUGUgA9n4K1kULme9wiNd9fsX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU+mHzwmDSk3PCR6lYr21fJ3AFmc4woDwy5Z2TMlzG2iUOG3tC
	l5Ratol1T655Fkczx+jbkaZZxvsH9MPWNC8hZsb/7rOu2yy94vo229rh
X-Gm-Gg: ATEYQzxxThixc5/uiBpsEY/QfXPAJY+HL7xA8oIu7wXg+sjn4UWyZzt1U+zdDXu66Ul
	7JWRdA+BlO+jCkX2ytOgqbGOHkiP5pXM4e1P1JU6TKJ3n9Pzkmn4GI4f46gLS22KlbaEiJtXJ9X
	Slya/24MuQu1I7HHwJCSLoyfNZEVTzDZvHTAEvEEp9iGkkzJ5r29cUMXBUCbBOlYH1adsQZIqj7
	bDMcyBEe+/tXB7umeMC8oK56wZhGT4MsDZl1cTh/+9EsQiYhcnPlHQB1xvQ+f4KeNpfxalxByJw
	0r6/jHNLkRjayeyYlwG7GXSLQ7CWuTvPyxX8KPFs3MOiCMqBu3vV/EgzIN/YFd7JZy7iaMne8xD
	UeTuKshcB7V7cH43qa+h5NmjB0i0HWBI2W29dUrx/JYxgWpSWHWlO4IHfkg0x+i5ztkGea/9T+8
	gC/HoijwNw4SUY+DTUPNeV+g==
X-Received: by 2002:a05:6a00:983:b0:81e:7496:f826 with SMTP id d2e1a72fcca58-829a2f6d717mr7319185b3a.31.1772961570117;
        Sun, 08 Mar 2026 01:19:30 -0800 (PST)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a46765a6sm6709106b3a.29.2026.03.08.01.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 01:19:29 -0800 (PST)
Date: Sun, 08 Mar 2026 14:49:21 +0530
Message-Id: <v7f6u19i.ritesh.list@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Andres Freund <andres@anarazel.de>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, jack@suse.cz, ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Andres Freund <andres@anarazel.de> writes:

Hi,

> Hi,
>
> On 2026-02-17 10:23:36 +0100, Amir Goldstein wrote:
>> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
>> >
>> > I think a better session would be how we can help postgres to move
>> > off buffered I/O instead of adding more special cases for them.
>
> FWIW, we are adding support for DIO (it's been added, but performance isn't
> competitive for most workloads in the released versions yet, work to address
> those issues is in progress).
>

Is postgres also planning to evaluate the performance gains by using DIO
atomic writes available in upstream linux kernel? What would be
interesting to see is the relative %delta with DIO atomic-writes v/s
DIO non atomic writes.

That being said, I understand the discussion in this wider thread is
also around supporting write-through in linux and then adding support of
atomic writes on top of that. We have an early prototype of that
design ready and Ojaswin will be soon posting that out.

-ritesh
